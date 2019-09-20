check_interactive <- function() {
    if (!interactive()) {
        stop("cabinets can only be run in an interactive R session.")
    }
}

#' Set cabinets options
#'
#' @param ... Options to be set
#' @param .envir Environment to set options in; if NULL, will use environment at \code{parent.frame()}
#'
#' @return If no options are set, returns the options specified in \code{options}.
#' @export
#'
#' @examples
#' \dontrun{
#' cabinets_options_set()
#' }
cabinets_options_set <- function(..., .envir = NULL) {
    if (is.null(.envir)) {
        .envir <- parent.frame()
    } else {
        .envir <- .envir
    }
    new_opts <- list(...)
    old_opts <- lapply(names(new_opts), getOption)
    do.call(base::options, new_opts)
}

ask_permission <- function() {
    perm_no <- function() {
        cabinets_options_set("cabinets.permission" = FALSE)
        cat("\n")
        stop("Permission denied...", call. = FALSE)

    }

    perm_yes <- function() {
        cat(crayon::green("Permission granted"), "\n")
        cabinets_options_set("cabinets.permission" = TRUE)
    }

    interact <- getOption("cabinet.testing")
    if (is.null(interact)) {
        switch(utils::menu(
            c("YES, I do give permission.",
              "NO, I do not give permission."),
            title = "Do you give permission to write .Rprofile and directory files?"
        ),
        perm_yes(),
        perm_no()
        )
    } else {
        if (getOption("cabinet.testingPerm") == TRUE) {
            perm_yes()
        } else {
            perm_no()
        }
    }
}

check_permissions <- function() {
    consent <- getOption("cabinets.permission")

    cat("Checking for permissions...")

    if (is.null(consent)) {
        cat("\n")
        cat("\n")
        ask_permission()
    } else if (identical(consent, TRUE)) {
        cat(cat_ok())
    } else if (identical(consent, FALSE)) {
        cat("\n")
        stop("Permission denied...", call. = FALSE)
    }
}

check_r_profile <- function() {
    wd <- getwd()
    file_stat <- !file.exists(glue::glue(wd, .Platform$file.sep, ".Rprofile"))

    perm_yes <- function() {
        cat("Creating .Rprofile\n")
        r_profile <- glue::glue(wd, .Platform$file.sep, ".Rprofile")
        file.create(r_profile)

        permission <- glue::glue(
            "# cabinets permission
            cabinets::cabinets_options_set('cabinets.permission' = TRUE)"
        )

        cat(permission, file = r_profile, sep = "\n")
    }

    cat("Checking for .Rprofile...")
    status <- tryCatch(if (file_stat) {
        cat(crayon::yellow(" NOT FOUND\n"))
        perm_yes()
    } else {
        cat(cat_ok())
    })
    invisible(status)
}

check_directory <- function() {
    hd <- normalizePath("~")
    wd <- normalizePath(getwd())

    status <- hd == wd
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

        interact <- getOption("cabinet.testing")
        if (is.null(interact)) {
            switch(
                utils::menu(
                    c("Switch directory to home directory",
                      "Continue anyways",
                      "Abort"),
                    title = "Enter one of the following numbers:"
                ),
                sw(),
                cont(),
                stop())
            } else {
                cont()
            }
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


