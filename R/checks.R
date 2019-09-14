check_r_profile <- function() {
    wd <- getwd()
    file_stat <- !file.exists(glue::glue(wd, .Platform$file.sep, ".Rprofile"))

    cat("Checking for .Rprofile...")
    status <- tryCatch(if (file_stat) {
        cat("\n")
        message("NOT FOUND: Creating .Rprofile")
        file.create(glue::glue(wd, .Platform$file.sep, ".Rprofile"))
    } else {
        cat(" OK\n")
    })
    invisible(status)
}

check_for_tools <- function() {
    check_r_profile()

    wd <- getwd()

    r_profile <-
        file(glue::glue(wd, .Platform$file.sep, ".Rprofile"), open = "a")

    r6 <-
        ".FileCabinet <-
         R6::R6Class('FileCabinet',
         public = list(
         name = NULL,
         directory = NULL,
         structure = NULL,
         initialize = function(name, directory, structure) {
         stopifnot(is.character(name), length(name) == 1)
         stopifnot(is.vector(directory))
         stopifnot(is.list(structure))
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
         ))"

    cab_stat <- exists(".FileCabinet", envir = .GlobalEnv)
    cat("Checking for .FileCabinet...")
    status <- tryCatch(if (cab_stat) {
        cat(" OK\n")
    } else {
        cat("\n")
        message("NOT FOUND: Writing .FileCabinet to .Rprofile")
        cat(r6, file = r_profile, sep = "\n")
    },
    finally = close(r_profile))
    invisible(status)
}

check_directory <- function() {
    status <- path.expand("~") == getwd()
    cat("Checking working directory...")
    status <- tryCatch(if (status) {
        cat(" OK\n")
    } else {
        cat("\n")
        message("WARNING: are you working in your default working directory?\nCabinents should only be created when working in your default working directory.")
    })
    invisible(status)
}

check_name <- function(name) {
    name_stat <- exists(paste0(".", name), envir = .GlobalEnv)
    cat("Checking cabinet name...")
    if (name_stat) {
        stop("Cabinet already exists.")
    } else {
        cat(" OK\n")
    }
}

check_cabinet <- function(cabinet) {
    cab_stat <- exists(deparse(substitute(.FileCabinet)), envir = .GlobalEnv)
    cat("Checking cabinet existence...")
    if (cab_stat) {
        cat(" OK\n")
    } else {
        stop("Cabinet not found")
    }
}


