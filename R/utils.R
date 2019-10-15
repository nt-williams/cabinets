in_rstudio <- function() {
    (Sys.getenv("RSTUDIO") == "1") && !nzchar(Sys.getenv("RSTUDIO_TERM"))
}

cat_green <- function(...) {
    crayon::green(...)
}

cat_path <- function(...) {
    crayon::blue(...)
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
    special_fx <- l10n_info()$`UTF-8`
    if (special_fx) {
        list(h = "\u2500",
             v = "\u2502",
             l = "\u2514",
             j = "\u251C")
    } else {
        list(h = "\u0006",
             v = "\u0005",
             l = "\u0003",
             j = "\u0019")
    }
}

p0 <- function(...) paste0(..., collapse = "")
