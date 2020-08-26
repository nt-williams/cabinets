
#' Print available cabinets
#'
#' \code{get_cabinets} returns objects of class FileCabinet found in the global environment.
#'
#' @return Objects of class FileCabinet found in the global environment.
#' @export
#'
#' @examples
#' get_cabinets()
get_cabinets <- function() {
    hidden <- as.list(ls(all.names = TRUE, envir = .GlobalEnv))
    classes <- lapply(hidden, function(x) class(eval(parse(text = x))))

    if (any(sapply(classes, function(x) "FileCabinet" %in% x))) {
        cli::cli_text("These are the available cabinets:")
        for (i in seq_along(classes)) {
            if ("FileCabinet" %in% classes[[i]]) cli::cli_ul(hidden[[i]])
        }
    } else {
        no_cabinets()
    }
}

creating_cabinet <- function(project_name, cabinet_name) {
    cli::cli_text("Creating {project_name} using cabinet template: {p0('.', cabinet_name)}")
}

opening_project <- function(project_name) {
    cli::cli_text("Opening R project, {basename(project_name)}, in a new session")
}

checking_project <- function() {
    cli::cli_alert_success("Checking if project already exists... ")
}

checking_existence <- function() {
    cli::cli_alert_success("Checking cabinet existence... ")
}

cabinet_not_found <- function() {
    cli::cli_alert_warning("Cabinet not found!")
    get_cabinets()
}

no_cabinets <- function() {
    cli::cli_alert_danger("No cabinets found. Cabinets can be created using {.code create_cabinets()}")
}

no_r_profile <- function() {
    cli::cli_alert_danger("{.path .Rprofile} doesn't exist")
}
