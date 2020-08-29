#' Set cabinets options
#'
#' @param ... Options to be set
#' @param .envir Environment to set options in; if NULL, will use environment at \code{parent.frame()}
#'
#' @return If no options are set, returns the options specified in \code{options}.
#' @details Mainly used for specifying if cabinets has permission to write to .Rprofile. Permission can be revoked at any time by opening the .Rprofile file and setting \code{"cabinets.permission" = FALSE}.
#' @export
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
        if (identical(getOption("cabinet.testingPerm"), TRUE)) {
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

    if (is.null(consent)) {
        ask_permission()
    } else if (identical(consent, TRUE)) {
        cli::cli_alert_success("Checking for permissions")
    } else if (identical(consent, FALSE)) {
        stop("Permission denied.", call. = FALSE)
    }
}

check_r_profile <- function() {
    file_stat <- !file.exists(file.path(normalizePath("~"), ".Rprofile"))
    status <- tryCatch(
        if (file_stat) {
            new_rprof()
        } else {
            old_rprof()
        }
    )
    invisible(status)
}

check_name <- function(name) {
    name_stat <- exists(paste0(".", name), envir = .GlobalEnv)
    status <- tryCatch(
        if (name_stat) {
            stop()
        } else {
            checking_name()
        }, error = function(e) {
            stop("Cabinet already exists!", call. = FALSE)
        }
    )
    invisible(status)
}

check_cabinet <- function(cabinet) {
    status <- tryCatch(
        if (exists(cabinet, envir = .GlobalEnv)) {
            checking_existence()
        } else {
            stop()
        }, error = function(e) {
            cabinet_not_found()
            stop_quietly()
        }
    )
    invisible(status)
}

check_project <- function(proj_path) {
    status <- tryCatch(
        if (dir.exists(proj_path)) {
            stop()
        } else {
            checking_project()
        }, error = function(e) {
            stop("Project already exists in cabinet!", call. = FALSE)
        }
    )
    invisible(status)
}

check_git <- function() {
    files <- git2r::git_config_files()
    git_stat <- is.na(files[3, "path"])
    config_stat <- git2r::config()

    if (git_stat || length(config_stat) == 0) {
        status <- FALSE
    } else {
        status <- TRUE
        checking_git()
    }

    return(status)
}
