
library(tidyr)

cab_str <- list(
    'data/derived/x.csv' = NULL,
    'data/derived/y.xlsx' = NULL,
    'data/derived' = NULL,
    'data/source' = NULL,
    'data' = NULL,
    'code/reports_code/report_1.rmd' = NULL,
    'code/analysis_code/analysis.R' = NULL
)

cab_str2 <- list(
    'cab/data/derived/x.csv' = NULL,
    'cab/data/derived/y.xlsx' = NULL,
    'cab/data/source' = NULL,
    'cab/code' = NULL
)

file_str <- list(
    'data' = NULL,
    'code' = NULL,
    'data/derived' = NULL,
    'data/source' = NULL,
    'reports' = NULL,
    'documents' = NULL,
    'log' = NULL
)

cab_names <- names(cab_str)
fs::path_file(cab_names)
fs::path_dir(cab_names)
by_dir <- split(cab_names, fs::path_dir(cab_names))

get_paths <- function(x) {
    n <- stringr::str_count(x, "/")

    recursively_repeat <- function(.x, .reps,.f, ...) {
        if (.reps == 0) {
            .x
        } else {
            recursively_repeat(.f(.x, ...), .reps - 1, .f, ...)
        }
    }

    sapply(0:n, function(y) recursively_repeat(x, y, dirname))
}

test <- function(x, ...) {
    files <- unique(unlist(sapply(names(x),
                           get_paths),
                    use.name = FALSE))
    files <- paste0("./", files)
    by_dir <- split(files, fs::path_dir(files))
    ch <- fs:::box_chars()

    print_leaf <- function(x, indent) {
        leafs <- by_dir[[x]]
        for (i in seq_along(leafs)) {
            if (i == length(leafs)) {
                cat(
                    indent,
                    fs:::pc(ch$l, ch$h, ch$h, " "),
                    fs::path_file(leafs[[i]]),
                    "\n",
                    sep = ""
                )
                print_leaf(leafs[[i]], paste0(indent, "    "))
            }
            else {
                cat(
                    indent,
                    fs:::pc(ch$j, ch$h, ch$h, " "),
                    fs::path_file(leafs[[i]]),
                    "\n",
                    sep = ""
                )
                print_leaf(leafs[[i]], paste0(indent, fs:::pc(ch$v,
                                                              "   ")))
            }
        }
    }
    print_leaf(".", "")
    invisible(files)
}
