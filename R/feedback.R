
creating_cabinet <- function(project_name, cabinet_name) {
    cli::cli_text("Creating {project_name} using cabinet template: {p0('.', cabinet_name)}")
}

opening_project <- function(project_name) {
    cli::cli_text("Opening R project, {basename(project_name)}, in a new session")
}

checking_project <- function() {
    cli::cli_alert_success("Checking if project already exists... ")
}
