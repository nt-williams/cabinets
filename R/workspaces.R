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
        name,
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

new_folder <- function(cabinet,
                       project_name,
                       open = TRUE) {

    dir.create(proj_dir, recursive = TRUE)

    message("Creating", project_name, " in", )

    if (open) {
        if (proj_activate()) {
            on.exit()
        }
    }
}
