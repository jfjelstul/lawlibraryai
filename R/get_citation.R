# Joshua C. Fjelstul, Ph.D.
# LawLibrary.AI LLC

#' Print the citation for LawLibrary.AI database
#'
#' This function generates the recommended citation for a LawLibrary.AI
#' database. You need to provide the ID for the database. You can run
#' \code{get_databases()} to get a list of valid values.
#'
#' @param database_id A string. The ID for the database.
#' @param api_key A string. Your LawLibrary.AI API key.
#'
#' @examples
#' \dontrun{
#' print_citation(
#'   database_id = "state_aid",
#'   api_key = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
#' )}
#'
#' @export
get_citation <- function(database_id, api_key) {

  # construct URL
  url <- stringr::str_c(get_api_address(), "/databases/documentation/citation/", database_id)

  # make request
  data <- make_request(url = url, api_key, quietly = TRUE)

  # get year
  year <- Sys.Date() |>
    lubridate::ymd() |>
    lubridate::year()

  # print message
  cat("\n")
  cat("Please cite the ", data$database, ":\n", sep = "")
  cat("\n")
  cat(data$citation, "\n", sep = "")
  cat("\n")
  cat("Please also cite the lawlibraryai R package:\n")
  cat("\n")
  cat("Joshua C. Fjelstul (", year, "). lawlibraryai: An R Interface to the LawLibrary.AI API. R package version ", as.character(packageVersion("lawlibraryai")), ". https://github.com/jfjelstul/lawlibraryai.\n", sep = "")
}
