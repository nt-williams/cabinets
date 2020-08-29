in_rstudio <- function() {
    (Sys.getenv("RSTUDIO") == "1") && !nzchar(Sys.getenv("RSTUDIO_TERM"))
}

cat_green <- function(...) {
    crayon::green(...)
}

cat_path <- function(...) {
    crayon::blue(...)
}

create_subdirectories <- function(folders) {
    for (i in 1:length(folders)) {
        dir.create(folders[i], recursive = TRUE)
    }
}

get_paths <- function(x) {
    files <- fs::path_tidy(x)
    n <- stringr::str_count(files, "/")
    recursively_repeat <- function(.x, .reps, .f, ...) {
        if (.reps == 0) {
            .x
        } else {
            recursively_repeat(.f(.x, ...), .reps - 1, .f, ...)
        }
    }
    sapply(0:n, function(y) recursively_repeat(files, y, dirname))
}

print_structure <- function(x, ...) {
    files <- paste0("./",
                    unique(unlist(sapply(names(x),
                                         get_paths),
                                  use.names = FALSE)))
    by_dir <- split(files, fs::path_dir(files))
    ch <- str_chars()

    print_files <- function(x, indent) {
        leafs <- by_dir[[x]]
        for (i in seq_along(leafs)) {
            if (i == length(leafs)) {
                cat(indent,
                    p0(ch$l, ch$h, ch$h, " "),
                    fs::path_file(leafs[[i]]),
                    "\n",
                    sep = "")
                print_files(leafs[[i]],
                            paste0(indent, "    "))
            }
            else {
                cat(indent,
                    p0(ch$j, ch$h, ch$h, " "),
                    fs::path_file(leafs[[i]]),
                    "\n",
                    sep = "")
                print_files(leafs[[i]],
                            paste0(indent,
                                   p0(ch$v, "   ")))
            }
        }
    }
    print_files(".", "")
    invisible(files)
}

str_chars <- function() {
    list(h = "\u2500",
         v = "\u2502",
         l = "\u2514",
         j = "\u251C")

}

p0 <- function(...) paste0(..., collapse = "")

go <- function(path) {
    utils::file.edit(path)
}

# taken from the usethis package!
read_utf8 <- function(path, n = -1L) {
    base::readLines(path, n = n, encoding = "UTF-8", warn = FALSE)
}

# taken from the usethis package!
platform_line_ending <- function() {
    if (.Platform$OS.type == "windows") "\r\n" else "\n"
}

perm_no <- function() {
    cabinets_options_set("cabinets.permission" = FALSE)
    stop("Permission denied.", call. = FALSE)
}

perm_yes <- function() {
    cli::cli_alert_success("Checking for permissions")
    cabinets_options_set("cabinets.permission" = TRUE)
}

new_rprof <- function() {
    r_profile <- file.path(normalizePath("~"), ".Rprofile")
    file.create(r_profile)

    permission <- glue::glue(
        "# cabinets permission
        cabinets::cabinets_options_set('cabinets.permission' = TRUE)"
    )

    writeLines(permission, r_profile)
    cli::cli_alert_success("Creating .Rprofile")
}

old_rprof <- function() {
    r_profile_path <- file.path(normalizePath("~"), ".Rprofile")
    rprof_lines <- readLines(r_profile_path)
    perm_status <- any(grepl("cabinets_options_set", rprof_lines))

    permission <- glue::glue(
        "# cabinets permission
        cabinets::cabinets_options_set('cabinets.permission' = TRUE)"
    )

    if (perm_status) {
        on.exit()
    } else {
        r_profile <- file(r_profile_path, open = "a")
        writeLines(permission, r_profile)
        close(r_profile)
    }
    cli::cli_alert_success("Checking for .Rprofile")
}

stop_quietly <- function() {
    opt <- options(show.error.messages = FALSE)
    on.exit(options(opt))
    stop()
}
