
#' Basic Utility to check internet connection
#'
#' @return Message
#' @export
#'
#' @examples
#' check_internet_connection()
check_internet_connection<-function() {
##function to stop without error message
stop_quietly <- function() {
  opt <- options(show.error.messages = FALSE)
  on.exit(options(opt))
  stop()
}


  if(curl::has_internet()) {message("Connected to the internet")} else
    {message("Check your internet connection!")
    stop_quietly()}
}


##import rds file from github

#' Utility to import RDS files from Github
#'
#' @param url url of the raw girhub file
#'
#' @return file (data frame)
#' @export
#'
#' @examples
#' read_rds_from_github(url)
read_rds_from_github<-function(url){
  data <- readRDS(url(url, method="libcurl"))
  return(data)
}

