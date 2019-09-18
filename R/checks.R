check_r_profile <- function() {
    wd <- getwd()
    file_stat <- !file.exists(glue::glue(wd, .Platform$file.sep, ".Rprofile"))

    cat("Checking for .Rprofile...")
    status <- tryCatch(if (file_stat) {
        cat(crayon::yellow(" NOT FOUND:"), "Creating .Rprofile \n")
        file.create(glue::glue(wd, .Platform$file.sep, ".Rprofile"))
    } else {
        cat(cat_ok())
    })
    invisible(status)
}

check_directory <- function() {
    status <- path.expand("~") == getwd()
    cat("Checking working directory...")
    status <- tryCatch(if (status) {
        cat(cat_ok())
    } else {
        sw <- function() {
            cat("Switching directory to...",
                crayon::blue(path.expand('~')),
                "\n")
            setwd(path.expand('~'))
        }
        cont <- function() {
            cat("Continuing anyways...\n")
        }
        cat(crayon::red(" WARNING:\n"))
        cat("Cabinets should be built when the working directory is set to the home directory.\n")
        cat("\n")
        cat("The home directory is...\n")
        cat("\n")
        cat(crayon::blue(path.expand('~')), "\n")
        cat("\n")
        switch(
            utils::menu(
                c("Switch directory to home directory",
                  "Continue anyways",
                  "Abort"),
                title = "Enter one of the following numbers:"
            ),
            sw(),
            cont(),
            stop()
        )
    }, error = function(e) {
        stop("Aborting...", call. = FALSE)
    }
    )
    invisible(status)
}

check_name <- function(name) {
    name_stat <- exists(paste0(".", name), envir = .GlobalEnv)
    cat("Checking cabinet name...")

    status <- tryCatch(
        if (name_stat) {
            stop("Cabinet already exists.")
        } else {
            cat(cat_ok())
        }, error = function(e) {
            cat(crayon::red("Cabinet already exists.\n"))
            stop("Aborting...", call. = FALSE)
        }
    )
    invisible(status)
}

check_cabinet <- function(cabinet) {

    cab_stat <- exists(cabinet, envir = .GlobalEnv)
    cat("Checking cabinet existence...")

    status <- tryCatch(
        if (cab_stat) {
            cat(cat_ok())
        } else {
            stop()
        }, error = function(e) {
            cat(crayon::red(" Cabinet not found.\n"))
            cat("These are the available cabinets:\n")
            get_cabinets()
            stop("Aborting...", call. = FALSE)
        }
    )
    invisible(status)
}

check_project <- function(proj_path) {
    cat("Checking if project already exits...")

    status <- tryCatch(
        if (dir.exists(proj_path)) {
            stop()
        } else {
            cat(cat_ok())
        }, error = function(e) {
            cat(crayon::red("Project already exists in cabinet\n"))
            stop("Aborting...", call. = FALSE)
        }
    )
    invisible(status)
}


