
block_delete <- function(block_start, block_end,
                         path = file.path(normalizePath("~"), ".Rprofile")) {
    block_lines <- read_utf8(path)
    to_delete <- block_find(block_lines,
                            block_start,
                            block_end)
    to_delete <- seq(to_delete[1] - 1L, to_delete[2] + 1L)
    new_lines <-
        enc2utf8(gsub("\r?\n", platform_line_ending(), block_lines[-to_delete]))

    con <- file(path, open = "wb", encoding = "utf-8")
    writeLines(new_lines, con = con, sep = platform_line_ending())
    on.exit(close(con))
}

# based on code from the usethis package
block_find <- function(lines, block_start, block_end) {
    if (is.null(lines)) {
        return(NULL)
    }

    start <- which(lines == block_start)
    end <- which(lines == block_end)

    if (length(start) == 0 && length(end) == 0) {
        return(NULL)
    }

    c(start + 1L, end - 1L)
}
