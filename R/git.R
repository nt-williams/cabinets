
use_git <- function(git_root, git_ignore = NULL) {
    status <- tryCatch(
        if (check_git()) {
            init_git(git_root, git_ignore)
        } else {
            warning()
        }, warning = function(w) {
            no_git()
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
    initiated_git(git_root)
}
