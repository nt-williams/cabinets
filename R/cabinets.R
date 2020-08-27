#' R6 class for a cabinet
#'
#' Constructs an R6 class of FileCabinet. Objects of class
#' FileCabinet contain information that is used by \code{new_cabinet_proj()}
#' to create project directories.
#'
#' @export
FileCabinet <- R6::R6Class('FileCabinet',
    public = list(
        #' @field name cabinet name.
        name = NULL,

        #' @field directory the path to where future directories will be created, a string.
        directory = NULL,

        #' @field structure the directory structure, a list.
        structure = NULL,

        #' @details
        #' Create a new `FileCabinet` object.
        #'
        #' @param name cabinet name.
        #' @param directory the path to where future directories will be created, a string.
        #' @param structure the directory structure, a list.
        #' @return A cabinet object.
        #'
        #' @examples
        #' FileCabinet$new("test", "a/path",
        #'                 list(code = NULL, 'data/derived' = NULL, 'data/source' = NULL))

        initialize = function(name, directory, structure) {
            stopifnot(is.character(name), length(name) == 1)
            stopifnot(is.character(directory))
            stopifnot(is.list(structure))

            self$name <- name
            self$directory <- fs::path_tidy(directory)
            self$structure <- structure
        },

        #' @details
        #' Print an object of class FileCabinet.

        print = function() {
            cat('Cabinet name: ',
                cat_green(self$name),
                '\n',
                sep = '')
            cat('Cabinet path: ',
                cat_path(self$directory),
                '\n',
                sep = '')
            cat('Cabinet structure: \n')
            print_structure(self$structure)
        }
    )
)

#' Create a cabinet template
#'
#' \code{create_cabinet} writes code to the .Rprofile file so
#'  that when new R sessions are started, the newly created
#'  cabinet, an R6 object of class FileCabinet, is available
#'  in the global environment as a hidden object. The cabinet
#'  simply stores file location and file template information
#'  that \code{new_cabinet_proj} uses to create new projects
#'  with the pre-defined structure.
#'
#' @param name Name of the cabinet; character of length 1.
#'  This is how the cabinet will be referenced, so best to
#'  chose something memorable.
#' @param directory The file path for where the cabinet will exist.
#' @param structure A list of paths of folders/files to
#'  create. See details for further explanation.
#' @param .alias An optional name for the object the cabinet
#'  will be stored in R as. Defaults to \code{name}.
#'
#' @return An R6 object of class FileCabinet. The code to
#'  generate this object is written to the .Rprofile file
#'  of the home directory.
#' @details Before writing to or creating a .Rprofile file,
#'  cabinets will explicitly ask for the user's permission to on exit.
#'  The cabinet structure should be defined using a list with the
#'  names defining folder paths. List values should be set to NULL.
#' @seealso \code{\link{new_cabinet_proj}}
#' @export
create_cabinet <- function(name,
                           directory,
                           structure,
                           .alias = name) {
    check_interactive()
    check_permissions()
    check_r_profile()
    check_name(name)
    write_cabinet(name, directory, structure, .alias)
    created_cabinet(.alias)
}

write_cabinet <- function(name, directory, structure, .alias) {
    directory <- fs::path_tidy(paste(directory, collapse = .Platform$file.sep))

    newFileCabinet <-
        call("$", x = call("::",
                           pkg = substitute(cabinets),
                           name = substitute(FileCabinet)),
             name = substitute(new))

    value <-
        as.call(list(newFileCabinet,
                     name = name,
                     directory = directory,
                     structure = structure))

    cabinet <- call("<-", x = as.symbol(paste0(".", .alias)), value = value)
    con <- file(file.path(normalizePath("~"), ".Rprofile"), open = "a")
    writeLines(glue::glue("## {name} cabinet start"), con = con)
    capture.output(cabinet, file = con, append = TRUE)
    writeLines(glue::glue("## {name} cabinet end"), con = con)
    on.exit(close(con))
}

#' Create a new project using a cabinet template
#'
#' Generate new project directories using cabinet templates.
#'
#' @param cabinet The name of the cabinet template. Available cabinets can
#'  be found using \code{get_cabinets()}.
#' @param project_name The name of the project to store in the cabinet,
#'  a character string. Can be a file path pointing to a directory
#'  within the specified cabinet.
#' @param r_project Logical, should an Rproject be created. Default is
#'  TRUE if working in RStudio (only works in RStudio).
#' @param open Logical, if creating an Rproject, should that project
#'  be opened once created. Default is TRUE if working in
#'  RStudio (only works in RStudio).
#' @param git Logical, should a git repository be initiated.
#' @param git_root A path relative to the project to initiate the
#'  git repository. Default is NULL and the repository is
#'  initiated at the root of the project.
#' @param git_ignore Character vector of files and directories
#'  to add to .gitignore file.
#' @param ... Extra arguments to pass to \code{create_r_proj}.
#'
#' @return Creates a new directory at the path specified in the
#'  cabinet template. If r_project is set to TRUE, a .Rproj file
#'  will also be created using the project name. If open is set
#'  to TRUE, the new R project will opened in a new R session.
#' @seealso \code{\link{create_cabinet}}
#' @export
new_cabinet_proj <- function(cabinet, # TODO I kind of want to change this name
                             project_name,
                             r_project = TRUE,
                             open = TRUE,
                             git = TRUE,
                             git_root = NULL,
                             git_ignore = NULL,
                             ...) {

    check_cabinet(deparse(substitute(cabinet)))

    if (in_rstudio() == FALSE) {
        r_project <- FALSE
    }

    proj_path <- file.path(cabinet$directory, project_name)
    proj_folders <- file.path(proj_path, names(cabinet$structure))

    check_project(proj_path)
    creating_cabinet(project_name, cabinet$name)

    if (r_project) {
        rstudioapi::initializeProject(proj_path)
    } else {
        dir.create(proj_path, recursive = TRUE)
        open <- FALSE
    }

    create_subdirectories(proj_folders)

    if (git) {
        if (is.null(git_root)) {
            git_root <- proj_path
        } else {
            git_root <- file.path(proj_path, git_root)
        }
        use_git(git_root, git_ignore)
    }

    if (open) {
        opening_project(project_name)
        Sys.sleep(2)
        rstudioapi::openProject(proj_path, TRUE)
    }
}

#' Open .Rprofile for editing
#'
#' \code{edit_r_profile} opens the .Rprofile file for editing.
#'  If the .Rprofile file doesn't exist an error message will be returned.
#'  This is essentially a wrapper function for \code{file.edit}.
#'
#' @return A message that .Rprofile is being opened or that it doesn't exist.
#' @export
edit_r_profile <- function() {
    rprof_path <- file.path(normalizePath("~"), ".Rprofile")
    status <- tryCatch(if (file.exists(rprof_path)) {
        cli::cli_text("Opening .Rprofile")
        go(rprof_path)
    } else {
        stop()
    }, error = function(e) {
        no_r_profile()
    })
    invisible(status)
}
