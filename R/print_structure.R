
cab_str <- list(
    'cab/data/derived/x' = NULL,
    'cab/data/derived/y' = NULL,
    'cab/data/derived' = NULL,
    'cab/data/source' = NULL,
    'cab/data' = NULL,
    'cab/code' = NULL
)

cab_names <- names(cab_str)
fs::path_file(cab_names)
fs::path_dir(cab_names)
by_dir <- split(cab_names, fs::path_dir(cab_names))

test <- function (x, ...) {
    files <- names(x)
    by_dir <- split(files, fs::path_dir(files))
    # by_dir <- purrr::map(by_dir, fs::path_file)
    ch <- fs:::box_chars()

    print_leaf <- function(x, indent) {
        leafs <- by_dir[[x]]
        for (i in seq_along(leafs)) {
            if (i == length(leafs)) {
                cat(
                    indent,
                    fs:::pc(ch$l, ch$h, ch$h, " "), fs::path_file(leafs[[i]]),
                    "\n",
                    sep = ""
                )
                print_leaf(leafs[[i]], paste0(indent, "    "))
            }
            else {
                cat(
                    indent,
                    fs:::pc(ch$j, ch$h, ch$h, " "), fs::path_file(leafs[[i]]),
                    "\n",
                    sep = ""
                )
                print_leaf(leafs[[i]], paste0(indent, fs:::pc(ch$v,
                                                              "   ")))
            }
        }
    }
    print_leaf("cab", "")
    invisible(files)
}
