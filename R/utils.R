


#' Basic Utility to check internet connection
#'
#' @return Message
#' @export
#'
#' @examples check_internet_connection()
check_internet_connection<-function() {
##function to stop without error message
stop_quietly <- function() {
  opt <- options(show.error.messages = FALSE)
  on.exit(options(opt))
  stop()
}


  if(curl::has_internet()) {} else {message("Check your internet connection!")
    stop_quietly()}
}


##import rds file from github

read_rds_from_github<-function(url){
  data <- readRDS(url(url, method="libcurl"))
  return(data)
}

read_rds_from_github("https://github.com/econabhishek/datagovindia/raw/master/field_api_df.rds")
