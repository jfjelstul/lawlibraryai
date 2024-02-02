# Joshua C. Fjelstul, Ph.D.
# LawLibrary.AI LLC

#' Get a summary of all LawLibrary.AI databases
#'
#' This function returns a table that summarizes all LawLibrary.AI databases.
#' The table indicates all of the databases that are currently available and all
#' of the datasets that are currently available in each database. The table
#' includes an ID for each database and dataset, which you'll need to provide to
#' \code{download_data()} in order to download the data.
#'
#' @param api_key A string. Your LawLibrary.AI API key.
#'
#' @examples
#' \dontrun{
#' get_databases(
#'   api_key = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
#' )}
#'
#' @export
get_databases <- function(api_key) {

  # construct URL
  url <- stringr::str_c(get_api_address(), "/databases/documentation/routes")

  # make request
  data <- make_request(url = url, api_key = api_key, quietly = TRUE)

  # select variables
  data <- data |>
    dplyr::select(
      database_id, database,
      dataset_id, dataset
    )

  return(data)
}
