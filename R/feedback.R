
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
