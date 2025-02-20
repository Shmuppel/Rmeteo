get_coordinates <- function(location_name) {
  # Construct the URL for the Nominatim API endpoint
  nominatim_url <- "https://nominatim.openstreetmap.org/search"
  location_name <- gsub(", ", ",", location_name)
  location_name <- gsub(" ", "+", location_name)
  location_name <- iconv(location_name, to = 'ASCII//TRANSLIT')
  # Set query parameters
  query <- list(
    q = location_name,
    format = "json",
    limit = 1
  )
  # Make GET request to the Nominatim API
  query_string <- paste0(names(query), "=", unlist(query), collapse = "&")
  full_url <- paste0(nominatim_url, "?", query_string)
  response <- url(full_url)
  # Check if request was successful
  if (inherits(response, "error")) {
    print("Error: Failed to retrieve coordinates.")
    return(NULL)
  } else {
    # Parse JSON response
    response_content <- readLines(response, warn = FALSE)
    data <- fromJSON(response_content)
    close(response)
    # Extract latitude and longitude from the response
    if (length(data) > 0) {
      lat <- as.numeric(data[1, ]$lat)
      lon <- as.numeric(data[1, ]$lon)
      return(c(lat, lon))
    } else {
      print("Error: Location not found.")
      return(NULL)
    }
  }
}