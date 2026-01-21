if (getRversion() >= "2.15.1") {
  utils::globalVariables(c("update_date", "currency", "rate", "base_currency", "."))
}
#' Fetch and Tidy Latest Exchange Rate Data
#'
#' This function connects to the ExchangeRate-API to retrieve the most recent
#' exchange rates for a specified base currency and returns the data in a
#' clean, tidy format.
#'
#' @param base_currency A character string representing the base currency code
#' (e.g., "USD", "CNY"). Defaults to "USD".
#' @return A tidied tibble containing the update date, base currency,
#' target currency, and exchange rate.
#' @export
#' @importFrom httr2 request req_perform resp_body_json
#' @importFrom dplyr mutate select %>%
#' @importFrom tibble tibble
get_latest_rates <- function(base_currency = "USD") {

  # 1. get API Key
  api_key <- Sys.getenv("EXCHANGE_API_KEY")
  if (api_key == "") {
    stop("Can't find API Key.Pls run Sys.setenv(EXCHANGE_API_KEY = 'your_key')")
  }

  # 2. build API  request
  url <- paste0("https://v6.exchangerate-api.com/v6/", api_key, "/latest/", base_currency)

  resp <- httr2::request(url) %>%
    httr2::req_perform()

  # 3. JSON
  raw_content <- httr2::resp_body_json(resp)

  #  (Wrangling)

  # get_rate_list
  rates_list <- raw_content$conversion_rates

  # turn list intoTibble
  df <- tibble::tibble(
    currency = names(rates_list),
    rate = as.numeric(unlist(rates_list))
  )

  # turn to R time
  # 1970-01-01
  last_update <- as.POSIXct(raw_content$time_last_update_unix, origin = "1970-01-01")

  #reorder
  df <- df %>%
    dplyr::mutate(
      base_currency = raw_content$base_code,
      update_date = as.Date(last_update)
    ) %>%
    dplyr::select(update_date, base_currency, currency, rate)

  return(df)
}
