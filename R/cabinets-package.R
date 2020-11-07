#' Streamlined organization with project specific custom templates
#'
#' Cabinets makes it easy to create project specific file structure templates
#' that can be referenced at the start of any R session. Cabinets works by writing
#' project specific file templates to the .Rprofile file of the default working directory.
#' Doing so allows the templates to be accessed in new R sessions without having to
#' redefine them. On first use, users will be prompted for explicit permission to
#' write to .Rprofile. Permission to write can be revoked at any time by setting the
#' permission option in the .Rprofile file to FALSE. Due to these explicit permission
#' requirements, cabinets will only work in interactive R sessions.
#'
#' @docType package
#' @name cabinets
#' @importFrom utils capture.output
#' @importFrom R6 R6Class
NULL
