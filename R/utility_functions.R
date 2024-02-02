# Joshua C. Fjelstul, Ph.D.
# LawLibrary.AI LLC

get_api_address <- function() {
  "https://www.api.lawlibrary.ai"
}

get_url <- function(route = NULL, parameters = NULL) {

  # if there are parameters
  if (!is.null(parameters)) {

    # create an empty vector
    parameters_vector <- NULL

    # loop through parameters in list
    for(i in 1:length(parameters)) {

      # create a new parameter
      new_parameter <- parameters[[i]]

      # collapse vectors into comma-separated strings
      if (length(parameters) > 1) {
        new_parameter <- stringr::str_c(new_parameter, collapse = ",")
      }

      # assign a value
      new_parameter <- stringr::str_c(names(parameters)[i], "=", new_parameter)

      # add to parameter vector
      parameters_vector <- c(parameters_vector, new_parameter)
    }

    # collapse multiple parameters into one string
    parameters_string <- stringr::str_c(parameters_vector, collapse = "&")

    # add parameters to route
    route <- stringr::str_c(route, "?", parameters_string)
  }

  # add API address to route
  url <- stringr::str_c(get_api_address(), route, sep = "")

  return(url)
}

get_route <- function(database_id, dataset_id, api_key) {

  # construct URL
  url <- stringr::str_c(get_api_address(), "/databases/documentation/routes")

  # make request
  data <- make_request(url = url, api_key = api_key, quietly = TRUE)

  # extract route
  route <- data |>
    dplyr::filter(database_id == !!database_id & dataset_id == !!dataset_id) |>
    dplyr::pull(api_route)

  # error handling
  if (length(route) != 1) {
    stop("database_code or dataset_code not valid")
  }

  return(route)
}

clear_console_line <- function() {

  # overwrite current line
  string <- "\r"

  # add spaces to clean line
  for(i in 1:50) {
    string <- stringr::str_c(string, " ")
  }

  # print message
  cat(string)
}
