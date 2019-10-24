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
    perm_no <- function() {
        cabinets_options_set("cabinets.permission" = FALSE)
        stop("Permission denied.", call. = FALSE)

    }

    perm_yes <- function() {
        message("Permission granted.")
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

    message("Checking for permissions...")

    if (is.null(consent)) {
        ask_permission()
    } else if (identical(consent, TRUE)) {
        on.exit()
    } else if (identical(consent, FALSE)) {
        stop("Permission denied.", call. = FALSE)
    }
}

check_r_profile <- function() {
    file_stat <- !file.exists(file.path(normalizePath("~"), ".Rprofile"))

    perm_yes <- function() {
        message("Creating .Rprofile...")
        r_profile <- file.path(normalizePath("~"), ".Rprofile")
        file.create(r_profile)

        permission <- glue::glue(
            "# cabinets permission
            cabinets::cabinets_options_set('cabinets.permission' = TRUE)"
        )

        writeLines(permission, r_profile)
    }

    message("Checking for .Rprofile...")
    status <- tryCatch(if (file_stat) {
        message(".Rprofile not found.")
        perm_yes()
    } else {
        on.exit()
    })
    invisible(status)
}

check_name <- function(name) {
    name_stat <- exists(paste0(".", name), envir = .GlobalEnv)
    message("Checking cabinet name... ")

    status <- tryCatch(
        if (name_stat) {
            stop()
        } else {
            on.exit()
        }, error = function(e) {
            stop("Cabinet already exists.", call. = FALSE)
        }
    )
    invisible(status)
}

check_cabinet <- function(cabinet) {

    cab_stat <- exists(cabinet, envir = .GlobalEnv)
    message("Checking cabinet existence... ")

    status <- tryCatch(
        if (cab_stat) {
            on.exit()
        } else {
            warning()
        }, warning = function(w) {
            message("Cabinet not found.")
            message("These are the available cabinets:")
            get_cabinets()
        }
    )
    invisible(status)
}

check_project <- function(proj_path) {
    message("Checking if project already exists... ")

    status <- tryCatch(
        if (dir.exists(proj_path)) {
            stop()
        } else {
            on.exit()
        }, error = function(e) {
            stop("Project already exists in cabinet.", call. = FALSE)
        }
    )
    invisible(status)
}
