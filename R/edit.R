
cab_start <- "## {name} cabinet start"
cab_end <- "## {name} cabinet end"

#' Delete Cabinets
#'
#' @param cabinet An R6 object of class Cabinet written to the .Rprofile.
#'
#' @export
delete_cabinet <- function(cabinet) {
    name <- cabinet$name
    cab_start <- glue::glue(cab_start)
    cab_end <- glue::glue(cab_end)
    block_delete(cab_start, cab_end)
    on.exit(rm(list = paste0(".", name), envir = .GlobalEnv))
}
