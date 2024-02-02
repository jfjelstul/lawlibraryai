# Joshua C. Fjelstul, Ph.D.
# LawLibrary.AI LLC

#' Download LawLibrary.AI data
#'
#' @description This function allows you to download data from LawLibrary.AI
#'   databases via the LawLibrary.AI API. You need to choose a database and a
#'   dataset in that database to download. You can specify filters to select
#'   specific observations.
#'
#' @details The LawLibrary.AI API has a rate limit. This function automatically
#'   manages compliance with the rate limit by downloading data from the API in
#'   batches. It downloads 25,000 observations every 5 seconds. It prints a
#'   message to the console that indicates how many observations you have
#'   requested and approximately how long it will take to download the data. It
#'   also prints a message after every batch that indicates the current
#'   progress. After your download is complete, it will print the suggested
#'   citation for the data.
#'
#' @param database_id A string. The ID of a database. Run \code{get_databases()}
#'   to get a list of valid values.
#' @param dataset_id A string. The ID of a dataset in the specified database.
#'   Run \code{get_databases()} to get a list of valid values.
#' @param api_key A string. Your LawLibrary.AI API key.
#' @param filters A named list. The default is \code{NULL}. Each element in the
#'   list specifies a filter to apply to the dataset. Only some variables in
#'   each dataset can be used to filter. See the documentation for the API for
#'   more information. If you want to filter by a variable that isn't supported
#'   by the API, use \code{dplyr::filter()} after downloading the data. Each
#'   element should be the name of a variable in the specified dataset and the
#'   corresponding value should be a value or vector of values that the variable
#'   can take. The response will only include observations where the variable
#'   equals one of the provided values. If you specify multiple filters, the
#'   results will only include observations that match all of the filters. For
#'   some variables, you can add \code{_min} or \code{_max} to the end of the
#'   variable name to specify a minimum or maximum value. The API will ignore
#'   invalid filters.
#'
#' @return This function returns a tibble containing the requested data.
#'
#' @examples
#' \dontrun{
#' data <- download_data(
#'   database_id = "state_aid",
#'   dataset_id = "cases",
#'   filters = list(
#'     min_date = "2010-01-01",
#'     max_date = "2019-12-31",
#'     member_state = c("France", "Germany")
#'   ),
#'   api_key = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
#' )}
#'
#' @export
download_data <- function(database_id, dataset_id, api_key, filters = NULL) {

  # get API route
  route <- get_route(database_id = database_id, dataset_id = dataset_id, api_key = api_key)

  # make an empty list to store parameters to pass to the API
  parameters <- list()

  # collapse vector to a string if there are multiple values
  if (!is.null(filters)) {
    for (i in 1:length(filters)) {
      parameters[[i]] <- stringr::str_c(filters[[i]], collapse = ",")
    }

    # add names to list
    names(parameters) <- names(filters)
  }

  # code as NULL if there are no parameters
  if (length(parameters) == 0) {
    parameters <- NULL
  }

  # construct URL
  url <- get_url(route = route, parameters = parameters)

  # make request
  data <- make_batch_request(url = url, api_key = api_key)

  # print citation
  get_citation(database_id = database_id, api_key = api_key)

  return(data)
}
