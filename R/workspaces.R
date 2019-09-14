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
        " created. Restart R to use cabinet. \nCabinet can be called using: .",
        name
    )
}

edit_cabinet <- function(name,
                         directory = NULL,
                         structure = NULL) {

}

delete_cabinet <- function(cabinet) {

}

get_cabinets <- function() {

}

create_r_proj <- function(Version = 1.0,
                          RestoreWorkspace = c("No", "Yes", "Default"),
                          SaveWorkspace = c("No", "Yes", "Default"),
                          AlwaysSaveHistory = c("Default", "No", "Yes"),
                          EnableCodeIndexing = c("Yes", "No", "Default"),
                          UseSpacesForTab = c("Yes", "No", "Default"),
                          NumSpacesForTab = 2,
                          Encoding = "UTF-8",
                          RnwWeave = "Sweave",
                          LaTeX = "pdfLaTeX",
                          AutoAppendNewLine = "Yes",
                          StripTrailingWhiteSpace = "Yes") {

    restore <- match.arg(RestoreWorkspace)
    save <- match.arg(SaveWorkspace)
    always <- match.arg(AlwaysSaveHistory)
    code_index <- match.arg(EnableCodeIndexing)
    space_tabs <- match.arg(UseSpacesForTab)

    glue::glue(
    'Version: {Version}
    RestoreWorkspace: {restore}
    SaveWorkspace: {save}
    AlwaysSaveHistory: {always}
    EnableCodeIndexing: {code_index}
    UseSpacesForTab: {space_tabs}
    NumSpacesForTab: {NumSpacesForTab}
    Encoding: {Encoding}
    RnwWeave: {RnwWeave}
    LaTeX: {LaTeX}
    AutoAppendNewline: {AutoAppendNewLine}
    StripTrailingWhitespace: {StripTrailingWhiteSpace}')
}

new_cabinet_proj <- function(cabinet,
                             project_name,
                             r_project = TRUE,
                             open = TRUE, ...) {

    # check_cabinet()

    message("Creating", project_name, " using cabinet template", cabinet$name)

    proj_path <- file.path(cabinet$directory, project_name)
    proj_folders <- file.path(proj_path, names(cabinet$structure))

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
        if (usethis::proj_activate(proj_path)) {
            on.exit()
        }
    }
}
