
use_git <- function(git_root, git_ignore = NULL) {
    cg <- check_git()
    status <- tryCatch(
        if (cg) {
            init_git(git_root, git_ignore)
        } else {
            warning()
        }, warning = function(w) {
            message("Git not found or git not fully configured. Check out https://happygitwithr.com/ for configuring git with R.")
        }
    )
    invisible(status)
}

init_git <- function(git_root, git_ignore = NULL) {
    ignores <- c(".Rproj.user", ".Rhistory", ".Rdata", ".Ruserdata")
    if (!is.null(git_ignore)) ignores <- c(ignores, git_ignore)
    ignores <- paste0(ignores, "\n", collapse = "")

    git2r::init(git_root)
    gi <- file.path(git_root, ".gitignore")
    writeLines(ignores, gi)

    message(glue::glue("Git repository initiated in {git_root}"))
}
