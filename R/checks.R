#' Set cabinets options
#'
#' @param ... Options to be set
#' @param .envir Environment to set options in; if NULL, will use environment at \code{parent.frame()}
#'
#' @return If no options are set, returns the options specified in \code{options}.
#' @details Mainly used for specifying if cabinets has permission to write to .Rprofile. Permission can be revoked at any time by opening the .Rprofile file and setting \code{"cabinets.permission" = FALSE}.
#' @export
#'
#' @examples
#' \donttest{
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
        message("Permission granted")
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

check_interactive <- function() {
    if (!interactive()) {
        stop("cabinets can only be run in an interactive R session.")
    }
}

check_permissions <- function() {
    consent <- getOption("cabinets.permission")

    message("Checking for permissions...")

    if (is.null(consent)) {
        ask_permission()
    } else if (identical(consent, TRUE)) {
        message(cat_ok())
    } else if (identical(consent, FALSE)) {
        cat("\n")
        stop("Permission denied...", call. = FALSE)
    }
}

check_r_profile <- function() {
    wd <- getwd()
    file_stat <- !file.exists(glue::glue(wd, .Platform$file.sep, ".Rprofile"))

    perm_yes <- function() {
        message("Creating .Rprofile")
        r_profile <- glue::glue(wd, .Platform$file.sep, ".Rprofile")
        file.create(r_profile)

        permission <- glue::glue(
            "# cabinets permission
            cabinets::cabinets_options_set('cabinets.permission' = TRUE)"
        )

        cat(permission, file = r_profile, sep = "\n")
    }

    message("Checking for .Rprofile...")
    status <- tryCatch(if (file_stat) {
        message(cat_yellow("Not found."))
        perm_yes()
    } else {
        message(cat_ok())
    })
    invisible(status)
}

check_directory <- function() {
    hd <- normalizePath("~")
    wd <- normalizePath(getwd())

    status <- hd == wd
    message("Checking working directory...")
    status <- tryCatch(if (status) {
        on.exit()
    } else {
        sw <- function() {
            message("Switching directory to... ",
                cat_path(path.expand('~')),
                "\n")
            setwd(path.expand('~'))
        }
        cont <- function() {
            message("Continuing anyways... ")
        }
        message(cat_red(" WARNING: "), "cabinets should be built when the working directory is set to the home directory.")
        message("The home directory is...")
        message(cat_path(path.expand('~')), "\n")

        interact <- getOption("cabinet.testing")
        if (is.null(interact)) {
            switch(
                utils::menu(
                    c("Switch directory to home directory (will be switched back after automatically)",
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
    message("Checking cabinet name... ")

    status <- tryCatch(
        if (name_stat) {
            stop("Cabinet already exists.")
        } else {
            on.exit()
        }, error = function(e) {
            message(cat_red("Cabinet already exists."))
            stop("Aborting...", call. = FALSE)
        }
    )
    invisible(status)
}

check_cabinet <- function(cabinet) {

    cab_stat <- exists(cabinet, envir = .GlobalEnv)
    message("Checking cabinet existence... ")

    status <- tryCatch(
        if (cab_stat) {
            message(cat_ok())
        } else {
            stop()
        }, error = function(e) {
            message(cat_red(" Cabinet not found."))
            message("These are the available cabinets:")
            get_cabinets()
            stop("Aborting...", call. = FALSE)
        }
    )
    invisible(status)
}

check_project <- function(proj_path) {
    message("Checking if project already exits... ")

    status <- tryCatch(
        if (dir.exists(proj_path)) {
            stop()
        } else {
            message(cat_ok())
        }, error = function(e) {
            message(cat_red("Project already exists in cabinet\n"))
            stop("Aborting...", call. = FALSE)
        }
    )
    invisible(status)
}


