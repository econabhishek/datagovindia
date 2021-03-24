#####Key functions

###Set option function
library(httr)
library(plyr)
library(dplyr)
library(curl)
library(stringr)


##check internet connection




register_api_key<-function(user_api_key,show_key=TRUE){

  check_internet_connection()

  #test key function
  test_api_key<-function(key){
    ##make a test request using any working api
    ##Get a working API from the master API
    working_api<-httr::GET(url="https://api.data.gov.in/lists?format=json&notfilters[source]=visualize.data.gov.in&filters[active]=1&offset=0&sort[updated]=desc&limit=1") %>%
      httr::content()
    working_api_index_name<-working_api$records[[1]]$index_name
    working_api_response<-httr::GET(url=paste0("https://api.data.gov.in/resource/",working_api_index_name,"?api-key=",key,"&format=json&offset=0&limit=10")) %>%
      content()
    if((working_api_response$records %>% length())>0){
      success=TRUE
    } else
      success=FALSE
    return(success)
    #####

  }

  #if test is a success
  if(test_api_key(key=user_api_key)){options(datagovin=list(user_api_key_set=user_api_key,key_valid=TRUE,key_shown=show_key))
    message("The api key is valid and you won't have to set it again")} else
      message("The API key is invalid. Please generate your API key on- \n https://data.gov.in/user")
  ###make a test request ; if it doesn't work, unset this one and set it to sample key


  }




########################################API Discovery and Info

###list of unique sectors
get_list_of_sectors<-function(){

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")
  api_details$sector %>%
    str_split(.,"\\|") %>%
    unlist %>%
    unique


}



###list of unique organisations
get_list_of_organisations<-function()  {

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")

  api_details$org %>%
  unique %>%
  str_split(.,"\\|") %>%
  unlist %>%
  unique
}


###List of unique sectors
get_list_of_sectors<-function()  {

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")


  api_details$sector %>%
  unique %>%
  str_split(.,"\\|") %>%
  unlist %>%
  unique

}


###List of unique sources
get_list_of_sources<-function()  {

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")



  api_details$source %>%
  unique %>%
  str_split(.,"\\|") %>%
  unlist %>%
  unique

}


##search by title
search_api_by_title<-function(title_contains=""){

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    filter(.,grepl(title_contains,title))
  return(filtered_details)
}


##search by descriptions
search_api_by_description<- function(description_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    filter(.,grepl(description_contains,description))
  return(filtered_details)
}
##search by org_type
search_api_by_org_type<- function(org_type_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    filter(.,grepl(org_type_contains,org_type))
  return(filtered_details)
}



##search by org
search_api_by_organisation<- function(organisation_name_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    filter(.,grepl(organisation_name_contains,org))
  return(filtered_details)
}


##search by sector
search_api_by_sector<- function(sector_name_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    filter(.,grepl(sector_name_contains,sector))
  return(filtered_details)
}

#search by source
search_api_by_sector<- function(source_name_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    filter(.,grepl(source_name_contains,source))
  return(filtered_details)
}


###get api info by index of the api
get_api_info<-function(api_index) {

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")
  api_details %>%
    filter(.,index_name==api_index)

}

##Get API details
get_api_info<-function(api_index) {

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=readRDS("text_info_api_df.rds"))}
  api_details<-getOption("api_info_data")
  api_details %>%
    filter(.,index_name==api_index)

}



#####Get fields of the API
##Fields have triples of c("id","name","type")
##Get API details
get_api_fields<-function(api_index) {

  if(is.null(getOption("api_fields_data"))){
    options(api_fields_data=readRDS("field_api_df.rds"))}
    api_fields<-getOption("api_fields_data")

    df_api_fields<-api_fields %>%
    filter(.,index_name==api_index) %>%
    .[1,2] %>%
    str_split(.,"\\|",simplify = F) %>%
    .[[1]] %>%
    matrix(.,ncol = 3,byrow = T) %>%
    data.frame()

  names(df_api_fields)<-c("id","name","type")

  return(df_api_fields)

}





###Call API for data using resource index

get_api_data<-function(api_index, results_per_req="all",
                       filter_by=c(),field_select=c(),sort_by=c()){

  check_internet_connection()
  ##first a function that scrubs the API key if the show key option is false
  scrub_key<-function (string, with = "xxx")
  { if(getOption("datagovin")$key_shown==TRUE) {return(string)} else {}
    str_replace_all(string, "(key|client|signature)=(\\w+)",
                    str_c("\\1=", with))
  }





  ##filter takes only one value per field in the API - we need to make a solution for that
  ##within the wrrapper



  filter_matrix <- filter_by %>%
    str_split(.,",",simplify = T) %>%
    t() %>%
    data.frame()

  names(filter_matrix) <- names(filter_by)

  filter_matrix<-expand.grid(filter_matrix)

  full_data<-data.frame()
  ##for each filter combination there will be a separate request, iterating
  for(filter_combination in 1:nrow(filter_matrix)){

    ## Cap the requests at req_cap to avoid errors
    if(results_per_req=="all"){
      results_per_req<-Inf} else {}
    req_cap<-5000
    if(results_per_req > req_cap) {
      message(paste0("The API works well only under ",req_cap," results per request,
            capping the results to 1000 at a time"))}  else {}

    ###Filter portion of the url
    if(length(filter_by) > 0) {
      gen_filter_portion=paste(paste0("&filters[",names(filter_matrix),"]=",unlist(filter_matrix[filter_combination,])),collapse = "")} else
        gen_filter_portion=""


    ##Field portion of the url
    if(length(field_select)>0) {
      gen_field_portion=paste0("&fields=",paste(field_select,collapse = ","))
    } else gen_field_portion=""


    ##Sort Portion of the URL
    if(length(sort_by)>0) {
      gen_sort_portion=paste0("&sort=",paste(sort_by,collapse = ","))
    } else gen_field_portion=""

    ###parsing data and making the dataset
    fill_data<-data.frame()

    i=1
    repeat{


      #calculate result limit per iteration
      if(i*req_cap>results_per_req){
        results_calc=results_per_req-((i-1)*req_cap)
      }   else {results_calc = min(results_per_req,i*req_cap)}

      req<-httr::GET(url=paste0("https://api.data.gov.in/resource/",
                                api_index,"?api-key=",getOption("datagovin")$user_api_key_set,
                                "&format=json&offset=",(i-1)*req_cap,
                                "&limit=", results_calc ,gen_filter_portion,gen_field_portion))
      message(paste0("url-",scrub_key(req$url)))
      if (req$status_code==200) {
        res<-content(req)
        api_data<-res$records %>%
          lapply(.,data.frame) %>%
          plyr::rbind.fill(fill=T)
      } else message("bad input parameters; choose again")

      fill_data<-bind_rows(fill_data,api_data)
      Sys.sleep(1)
      message("gave the API a rest")
      if((length(res$records)==0) | (results_per_req<req_cap)) break

      i=i+1

    }
    full_data<-bind_rows(full_data,fill_data)

  }
  return(full_data)

}




