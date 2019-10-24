#' R6 class for a cabinet
#'
#' Constructs an R6 class of FileCabinet. Objects of class FileCabinet contain information that is used by \code{new_cabinet_proj()} to create project directories.
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
        #' FileCabinet$new("test", "a/path", list(code = NULL, 'data/derived' = NULL, 'data/source' = NULL))

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
#' \code{create_cabinet} writes code to the .Rprofile file so that when new R sessions are started, the newly created cabinet, an R6 object of class FileCabinet, is available in the global environment as a hidden object. The cabinet simply stores file location and file template information that \code{new_cabinet_proj} uses to create new projects with the pre-defined structure.
#'
#' @param name Name of the cabinet; character of length 1. This is how the cabinet will be referenced, so best to chose something memorable.
#' @param directory The file path for where the cabinet will exist.
#' @param structure A list of paths of folders/files to create. See details for further explanation.
#'
#' @return An R6 object of class FileCabinet. The code to generate this object is written to the .Rprofile file of the home directory.
#' @details Before writing to or creating a .Rprofile file, cabinets will explicitly ask for the user's permission to pn exit. The cabinet structure should be defined using a list with the names defining folder paths. List values should be set to NULL.
#' @seealso \code{\link{new_cabinet_proj}}
#' @export
create_cabinet <- function(name,
                           directory,
                           structure) {

    check_interactive()
    check_permissions()
    check_r_profile()
    check_name(name)

    home <- normalizePath("~")
    r_profile <- file(file.path(home, ".Rprofile"), open = "a")
    str_json <- rjson::toJSON(structure)
    directory <- fs::path_tidy(paste(directory, collapse = .Platform$file.sep))

    cabinet <- glue::glue(
    "# creating {name} cabinet
    .{name} <- cabinets::FileCabinet$new(
        name = '{name}',
        directory = '{directory}',
        structure = rjson::fromJSON('{str_json}')
    )"
    )

    writeLines(cabinet, con = r_profile)
    close(r_profile)

    if (in_rstudio()) {
        message("Cabinet ",
                p0(".", name),
                " created... Restarting R.")
        message("Cabinet can be called using: ",
                p0(".", name))
        rstudioapi::restartSession()
    } else {
        message("Cabinet ",
                p0(".", name),
                "created...")
        message("Cabinet can be called using: ",
                p0(".", name))
        message("Restart R to use new cabinet.")
    }
}

#' Print available cabinets
#'
#' \code{get_cabinets} returns objects of class FileCabinet found in the global environment.
#'
#' @return Objects of class FileCabinet found in the global environment.
#' @export
#'
#' @examples
#' get_cabinets()
get_cabinets <- function() {
    hidden <- as.list(ls(all.names = TRUE, envir = .GlobalEnv))
    classes <- lapply(hidden, function(x) class(eval(parse(text = x))))

    if (any(sapply(classes, function(x) "FileCabinet" %in% x))) {
        for (i in seq_along(classes)) {
            if ("FileCabinet" %in% classes[[i]]) message(hidden[[i]])
        }
    } else {
        message("No cabinets found. Cabinets can be created using create_cabinets().")
    }
}

#' R project settings
#'
#' \code{create_r_proj} is a helper function for \code{new_cabinet_proj}. Calling it outside the scope of \code{new_cabinet_proj} will only print the specified settings the console.
#'
#' @param version R project version number, to be passed as character string.
#' @param restore_workspace Load the .Rdata file (if any) found in the initial working directory into the  R workspace. Options are "No" (default), "Yes", and "Default". If "Default", global behaviour settings are inherited.
#' @param save_workspace Save .RData on exit. Options are "No" (default), "Yes", and "Default". If "Default", global behaviour settings are inherited.
#' @param save_history Always save history (even when not saving .RData). Options are "Default" (default), "Yes", and "No". If "Default", global behaviour settings are inherited.
#' @param enable_code_indexing Determines whether R source files within the project directory are indexed for code navigation. Options are "Yes" (default), "No", and "Default". If "Default", global behaviour settings are inherited.
#' @param spaces_for_tab Determine whether the tab key inserts multiple spaces rather than a tab character (soft tabs). Options are "Yes" (default), "No", and "Default". If "Default", global behaviour settings are inherited.
#' @param num_spaces_for_tab Specify the number of spaces per soft-tab, integer.
#' @param encoding Specify the default text encoding for source files. Default is "UTF-8".
#' @param rnw_weave Specify how to weave Rnw files. Default is "Sweave".
#' @param latex Specify LaTeX processing. Default is "pdfLaTeX".
#' @param auto_append_new_line Ensure that source files end with a new line. Default is "Yes".
#' @param strip_trailing_white_space Strip trailing horizontal white space when saving. Default is "Yes".
#'
#' @return The settings used to write a .Rproj file.
#' @seealso \url{https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects} for more information on these settings.
#' @export
#'
#' @examples
#' create_r_proj()
create_r_proj <- function(version = "1.0",
                          restore_workspace = c("No", "Yes", "Default"),
                          save_workspace = c("No", "Yes", "Default"),
                          save_history = c("Default", "No", "Yes"),
                          enable_code_indexing = c("Yes", "No", "Default"),
                          spaces_for_tab = c("Yes", "No", "Default"),
                          num_spaces_for_tab = 2,
                          encoding = "UTF-8",
                          rnw_weave = "Sweave",
                          latex = "pdfLaTeX",
                          auto_append_new_line = "Yes",
                          strip_trailing_white_space = "Yes") {

    restore <- match.arg(restore_workspace)
    save <- match.arg(save_workspace)
    always <- match.arg(save_history)
    code_index <- match.arg(enable_code_indexing)
    space_tabs <- match.arg(spaces_for_tab)

    glue::glue(
    'Version: {version}
    RestoreWorkspace: {restore}
    SaveWorkspace: {save}
    AlwaysSaveHistory: {always}
    EnableCodeIndexing: {code_index}
    UseSpacesForTab: {space_tabs}
    NumSpacesForTab: {num_spaces_for_tab}
    Encoding: {encoding}
    RnwWeave: {rnw_weave}
    LaTeX: {latex}
    AutoAppendNewline: {auto_append_new_line}
    StripTrailingWhitespace: {strip_trailing_white_space}'
    )
}

#' Create a new project using a cabinet template
#'
#' Generate new project directories using cabinet templates.
#'
#' @param cabinet The name of the cabinet template. Available cabinets can be found using \code{get_cabinets()}.
#' @param project_name The name of the project to store in the cabinet, a character string.
#' @param r_project Logical, should an Rproject be created. Default is TRUE if working in RStudio (only works in RStudio).
#' @param open Logical, if creating an Rproject, should that project be opened once created. Default is TRUE if working in RStudio (only works in RStudio).
#' @param ... Extra arguments to pass to \code{create_r_proj}.
#'
#' @return Creates a new directory at the path specified in the cabinet template. If r_project is set to TRUE, a .Rproj file will also be created using the project name. If open is set to TRUE, the new R project will opened in a new R session.
#' @seealso \code{\link{create_cabinet}}
#' @export
new_cabinet_proj <- function(cabinet,
                             project_name,
                             r_project = TRUE,
                             open = TRUE,
                             ...) {

    check_cabinet(deparse(substitute(cabinet)))

    if (in_rstudio() == FALSE) {
        r_project <- FALSE
    }

    proj_path <- file.path(cabinet$directory, project_name)
    proj_folders <- file.path(proj_path, names(cabinet$structure))

    check_project(proj_path)

    message("Creating ",
            project_name,
            " using cabinet template: ",
            p0(".", cabinet$name))

    dir.create(proj_path, recursive = TRUE)
    purrr::walk(proj_folders, ~dir.create(.x, recursive = TRUE))

    if (r_project) {
        r_proj_args <- list(...)

        if (length(r_proj_args) == 0) {
            proj_settings <- create_r_proj()
        } else {
            proj_settings <- create_r_proj(r_proj_args)
        }

        r_project <- file.path(proj_path,
                               paste0(basename(project_name), ".Rproj"))
        writeLines(proj_settings, r_project)
        message("\nR project settings:")
        message(proj_settings)
    } else {
        open <- FALSE
    }

    if (open) {
        message(glue::glue("Opening new R project, {basename(project_name)}"), "\n")
        Sys.sleep(2)
        if (usethis::proj_activate(proj_path)) {
            on.exit()
        }
    }
}
