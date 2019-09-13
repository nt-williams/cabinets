create_workspace <- function(name,
                             directory,
                             structure) {

    if (path.expand("~") != getwd())
        stop("You can only create workspaces when working in your home directory.")

    if (!file.exists(glue::glue(R.home(), .Platform$file.sep, ".Renviron")))
        file.create(glue::glue(R.home(), .Platform$file.sep, ".Renviron"))

    list(
        name = name,
        directory = here::here(directory),
        structure = structure
    )
}

edit_workspace <- function(name,
                           directory = NULL,
                           structure = NULL) {

}

get_workspace <- function(workspace) {

}

new_workorder <- function(workspace,
                          project_name) {


    dir.create(proj_dir, recursive = TRUE)
}
