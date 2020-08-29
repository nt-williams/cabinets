
#' Print available cabinets
#'
#' \code{get_cabinets} returns objects of class FileCabinet.
#'
#' @param envir The environment to check in. The default is the global environment.
#'
#' @return Objects of class FileCabinet found in the global environment.
#' @export
#'
#' @examples
#' get_cabinets()
get_cabinets <- function(envir = parent.frame()) {
    hidden <- as.list(ls(all.names = TRUE, envir = envir))
    classes <- lapply(hidden, function(x) class(eval(parse(text = x), envir = envir)))

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
    cli::cli_alert_success("Creating {project_name} using cabinet template: {.field {p0('.', cabinet_name)}}")
}

opening_project <- function(project_name) {
    cli::cli_ul("Opening R project, {basename(project_name)}, in a new session")
}

checking_project <- function() {
    cli::cli_alert_success("Checking if project already exists")
}

checking_existence <- function() {
    cli::cli_alert_success("Checking cabinet existence")
}

cabinet_not_found <- function() {
    cli::cli_alert_danger("Cabinet not found!")
    get_cabinets()
}

checking_name <- function() {
    cli::cli_alert_success("Checking cabinet name")
}

checking_git <- function() {
    cli::cli_alert_success("Checking for git configuration")
}

no_cabinets <- function() {
    cli::cli_alert_danger("No cabinets found. Cabinets can be created using {.code create_cabinets()}")
}

no_r_profile <- function() {
    cli::cli_alert_danger("{.path .Rprofile} doesn't exist")
}

created_cabinet <- function(name) {
    cli::cli_alert_success("Cabinet .{name} created")
    cli::cli_ul(c("Restart R for changes to take effect",
                  "Cabinet can be called with .{name}"))
}

initiated_git <- function(root) {
    cli::cli_alert_success("Git repository initiated in {.path {root}}")
}

no_git <- function() {
    cli::cli_alert_warning("Git not found or git not fully configured")
    cli::cli_ul("Check out {.url https://happygitwithr.com/} for configuring git with R.")
}
