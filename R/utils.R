
##function to stop without error message
stop_quietly <- function() {
  opt <- options(show.error.messages = FALSE)
  on.exit(options(opt))
  stop()
}


##function to check internet connection
check_internet_connection<-function() {
  if(curl::has_internet()) {} else {message("Check your internet connection!")
    stop_quietly()}
}


##import rds file from github

# import_rds_github(github_raw_url){
#   download.file(github_raw_url,"best2.My.Lu2.rds", method="curl")
#   BestMyyu <- readRDS("best2.My.Lu2.rds")
# }

