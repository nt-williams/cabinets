.FileCabinet <- R6::R6Class('FileCabinet',
    public = list(
        name = NULL,
        directory = NULL,
        structure = NULL,
        initialize = function(name, directory, structure) {
            stopifnot(is.character(name), length(name) == 1)
            stopifnot(is.vector(directory))
            stopifnot(is.character(structure))

            self$name <- name
            self$directory <- directory
            self$structure <- structure
        },
        print = function(...) {
            cat('Cabinet name: ', self$name, '\n', sep = '')
            cat('Cabinet path: ', self$directory, '\n', sep = '')
            cat('Cabinet structure: \n')
            print(self$structure)
        }
    )
)

#' Create a cabinet template
#'
#' @param name
#' @param directory
#' @param structure
#'
#' @return
#' @export
#'
#' @examples
create_cabinet <- function(name,
                           directory,
                           structure) {
    check_directory()
    check_for_tools()
    check_name(name)

    wd <- getwd()
    r_profile <-
        file(glue::glue(wd, .Platform$file.sep, ".Rprofile"), open = "a")
    str_json <- rjson::toJSON(structure)
    directory <- paste(paste(directory, collapse = .Platform$file.sep),
                       name,
                       sep = .Platform$file.sep)

    cabinet <- glue::glue(
    ".{name} <- .FileCabinet$new(
        name = '{name}',
        directory = '{directory}',
        structure = rjson::fromJSON('{str_json}')
    )"
    )

    cat(cabinet, file = r_profile, sep = "\n")
    close(r_profile)

    message(
        "Cabinet, ",
        paste0(".", name),
        " created. Restarting R. \nCabinet can be called using: .",
        name
    )

    if (in_rstudio()) {
        rstudioapi::restartSession()
    } else {
        startup::restart()
    }
}

get_cabinets <- function() {

}

#' R project settings
#'
#' @param version
#' @param restore_workspace
#' @param save_workspace
#' @param save_history
#' @param enable_code_indexing
#' @param spaces_for_tab
#' @param num_spaces_for_tab
#' @param encoding
#' @param rnw_weave
#' @param latex
#' @param auto_append_new_line
#' @param strip_trailing_white_space
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
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
    StripTrailingWhitespace: {strip_trailing_white_space}')
}

#' Create a new project using a cabinet template
#'
#' @param cabinet
#' @param project_name
#' @param r_project
#' @param open
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
new_cabinet_proj <- function(cabinet,
                             project_name,
                             r_project = TRUE,
                             open = TRUE,
                             ...) {

    check_cabinet(cabinet)

    proj_path <- file.path(cabinet$directory, project_name)
    proj_folders <- file.path(proj_path, names(cabinet$structure))
    r_proj_args <- list(...)

    check_project(proj_path)

    message("Creating ", project_name, " using cabinet template .", cabinet$name)

    dir.create(proj_path, recursive = TRUE)
    purrr::walk(proj_folders, ~dir.create(.x, recursive = TRUE))

    if (r_project) {
        proj_settings <- create_r_proj()
        r_project <- file.path(proj_path, paste0(project_name, ".Rproj"))
        cat(proj_settings, file = r_project)
    } else {
        open <- FALSE
    }

    if (open) {
        cat(glue::glue("Opening new R project, {project_name}"))
        cat("\nR project settings:\n")
        cat("\n")
        create_r_proj()
        Sys.sleep(2)
        if (usethis::proj_activate(proj_path)) {
            on.exit()
        }
    }
}
