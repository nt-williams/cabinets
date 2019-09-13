.FileCabinet <- R6::R6Class("FileCabinet",
    public = list(
        name = NULL,
        directory = NULL,
        structure = NULL,
        initialize = function(name, directory, structure) {
            stopifnot(is.character(name), length(name) == 1)
            stopifnot(is.vector(directory))
            stopifnot(is.character(structure))

            self$name <- name
            self$directory <- paste(paste(directory, collapse = .Platform$file.sep),
                                    name, sep = .Platform$file.sep)
            self$structure <- structure
        },
        print = function(...) {
            cat("Cabinet name: ", self$name, "\n", sep = "")
            cat("Cabinet path: ", self$directory, "\n", sep = "")
            cat("Cabinet structure: \n")
            print(self$structure)
        }
    )
)

check_for_tools <- function() {
    home <- path.expand("~")

    if (!file.exists(glue::glue(home, .Platform$file.sep, ".Rprofile")))
        file.create(glue::glue(home, .Platform$file.sep, ".Rprofile"))

    r_profile <- file(glue::glue(home, .Platform$file.sep, ".Rprofile"))

    if (!(exists(".FileCabinet"))) {
        cat(".FileCabinet <- R6::R6Class('FileCabinet',
                                         public = list(
                                           name = NULL,
                                           directory = NULL,
                                           structure = NULL,
                                           initialize = function(name, directory, structure) {
                                               stopifnot(is.character(name), length(name) == 1)
                                               stopifnot(is.vector(directory))
                                               stopifnot(is.list(structure))

                                               self$name <- name
                                               self$directory <- paste(paste(directory, collapse = .Platform$file.sep),
                                                                       name, sep = .Platform$file.sep)
                                               self$structure <- structure
                                           },
                                           print = function(...) {
                                               cat('Cabinet name: ', self$name, '\n', sep = '')
                                               cat('Cabinet path: ', self$directory, '\n', sep = '')
                                               cat('Cabinet structure: \n')
                                               print(self$structure)
                                           }
                                       )
        )", file = r_profile, append = TRUE)
    }

    close(r_profile)
}

create_cabinet <- function(name,
                           directory,
                           structure) {

    if (home != getwd())
        stop("You can only create cabinets when working in your home directory.")

    check_for_tools()

    home <- path.expand("~")
    r_profile <- file(glue::glue(home, .Platform$file.sep, ".Rprofile"))
    str_json <- rjson::toJSON(structure)

    cabinet <- glue::glue(
    "{name} <- FileCabinet$new(
        name = {name},
        directory = {directory},
        structure = {str_json}
    )"
    )

    cat(cabinet, file = r_profile, append = TRUE)
    close(r_profile)

    message("Cabinet, ", name, " created. Restart R to use cabinet. \nCabinet can be called using: .", name)
}

edit_cabinet <- function(name,
                         directory = NULL,
                         structure = NULL) {

}

get_cabinet <- function(cabinet) {
    print(cabinet)
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
