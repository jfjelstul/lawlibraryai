# Joshua C. Fjelstul, Ph.D.
# LawLibrary.AI LLC

make_request <- function(url, api_key, quietly = FALSE) {

  # print message
  if (quietly == FALSE) {
    cat("Connecting to the LawLibrary.AI API...\n")
  }

  # create request
  req <- url |>
    httr2::request() |>
    httr2::req_headers("x-api-key" = api_key)

  # make request
  resp <- NULL
  try(
    {
      resp <- req |>
        httr2::req_perform()
    },
    silent = TRUE
  )

  # error handling
  if (is.null(resp)) {

    # check status
    status <- httr2::last_response() |>
      httr2::resp_status()

    # throw error
    if (status == 404) {
      stop(stringr::str_c("The API query was't successful: The API isn't responding."))
    }

    # extract error message
    error <- httr2::last_response() |>
      httr2::resp_body_json()

    # throw error
    stop(stringr::str_c("The API query wasn't successful: ", error$error$message))
  }

  # extract data
  data <- resp |>
    httr2::resp_body_json(simplifyVector = TRUE) |>
    purrr::pluck("data") |>
    dplyr::as_tibble()

  # drop ID
  if ("_id" %in% names(data)) {
    data <- data |>
      dplyr::select(-"_id")
  }

  # print message
  if (quietly == FALSE) {
    cat("Response received.\n")
  }

  return(data)
}
