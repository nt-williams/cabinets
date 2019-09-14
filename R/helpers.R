
in_rstudio <- function() {
    (Sys.getenv("RSTUDIO") == "1") && !nzchar(Sys.getenv("RSTUDIO_TERM"))
}

cat_ok <- function() {
    crayon::green(" OK\n")
}

