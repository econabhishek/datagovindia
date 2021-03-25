
#' importFrom magrittr "%>%"

#' Registering/Validating User API key
#'
#'Obtain an API key from data.gov.in by registering on the platform. You can find
#'it on your "My Account page after logging in.
#'
#' @param user_api_key API Key obtained from data.gov.in
#' @param show_key Whether to API show key in messages
#'
#' @return Success/Faliure of API key validation
#' @export
#'
#' @examples
#' register_api_key(api_key=xxx,show_key=FALSE)

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


#' Get a list of unique organization types
#'
#'These include whether a Central/State organization releases the underlying data.
#'This will be helpful while querying for the right API
#'
#'
#' @return character vector of organization types
#' @export
#'
#' @examples
#'   get_list_of_org_types()
get_list_of_org_types<-function(){

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")
  api_details$org_type %>%
    stringr::str_split(.,"\\|") %>%
    unlist %>%
    unique


}


#' Get a list of unique organizations
#'
#'These include which ministry releases the underlying data.
#'This will be helpful while querying for the right API.
#' Get a list of unique sectors
#' @return character vector of organization
#' @export
#'
#' @examples
#'   get_list_of_organizations()

get_list_of_organizations<-function()  {

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")

  api_details$org %>%
  unique %>%
  stringr::str_split(.,"\\|") %>%
  unlist %>%
  unique
}

#' Get a list of unique sectors
#'
#'These include which sector the underlying data belongs to.
#'This will be helpful while querying for the right API.
#' @return character vector of sectors
#' @export
#'
#' @examples
#'   get_list_of_sectors()

get_list_of_sectors<-function()  {

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")


  api_details$sector %>%
  unique %>%
  stringr::str_split(.,"\\|") %>%
  unlist %>%
  unique

}

#' Get a list of unique data sources (website names)
#'
#'These include which websites host the underlying data.
#'This will be helpful while querying for the right API.
#' @return character vector of sectors
#' @export
#'
#' @examples
#'   get_list_of_sources()

get_list_of_sources<-function()  {

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")



  api_details$source %>%
  unique %>%
  stringr::str_split(.,"\\|") %>%
  unlist %>%
  unique

}


#' Search API by title
#'
#' @param title_contains string to match in the title of the API (case insensitive)
#'
#' @return API details filtered by titles that match the string provided
#' @export
#'
#' @examples
#'   search_api_by_title(title_contains="Air Quality")
search_api_by_title<-function(title_contains=""){

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    dplyr::filter(.,grepl(title_contains,title,ignore.case = T))
  return(filtered_details)
}

#' Search API by description
#'
#' @param description_contains string to match in the description of the API (case insensitive)
#'
#' @return API details filtered by descriptions that match the string provided
#' @export
#'
#' @examples
#'   search_api_by_description(description_contains="Air Quality")

search_api_by_description<- function(description_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    dplyr::filter(.,grepl(description_contains,description,ignore.case = T))
  return(filtered_details)
}


#' Search API by organization type
#'
#' @param org_type_contains string to match in the organization type of the API (case insensitive)
#'
#' @return API details filtered by organization types that match the string provided
#' @export
#'
#' @examples
#'   get_list_of_org_types()
#'   search_api_by_org_type(org_type_contains="Central")

search_api_by_org_type<- function(org_type_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    dplyr::filter(.,grepl(org_type_contains,org_type,ignore.case = T))
  return(filtered_details)
}


#' Search API by organization name
#'
#' @param organization_name_contains string to match in the organization type of the API (case insensitive)
#'
#' @return API details filtered by organization names (Ministries) that match the string provided
#' @export
#'
#' @examples
#'   get_list_of_organizations()
#'   search_api_by_organization(organization_name_contains="Agriculture")
#'
search_api_by_organization<- function(organization_name_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    dplyr::filter(.,grepl(organization_name_contains,org,ignore.case = T))
  return(filtered_details)
}


#' Search API by Sector
#'
#' @param sector_name_contains string to match in the organization type of the API (case insensitive)
#'
#' @return API details filtered by Sectors that match the string provided
#' @export
#'
#' @examples
#'   get_list_of_sectors()
#'   search_api_by_organization(sector_name_contains="Consumer")

search_api_by_sector<- function(sector_name_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    dplyr::filter(.,grepl(sector_name_contains,sector,ignore.case = T))
  return(filtered_details)
}

#' Search API by Data Source
#'
#' @param source_name_contains string to match in the organization type of the API (case insensitive)
#'
#' @return API details filtered by Sectors that match the string provided
#' @export
#'
#' @examples
#'   get_list_of_sources()
#'   search_api_by_source(sector_name_contains="gov")

search_api_by_source<- function(source_name_contains=""){
  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")

  filtered_details<-api_details %>%
    dplyr::filter(.,grepl(source_name_contains,source,ignore.case = T))
  return(filtered_details)
}


#' Get information about the API using the API index name
#'
#' @param api_index API index name (string) you found using the search functions. You can
#' also get these from data.gov.in from a specific API page. In the request url,
#' it is followed by /resource/xxxxxxxx
#' For getting the relevant fields in the api use get_api_fields
#'
#' @return Data frame with 1 row , API that matches API ID
#' @export
#'
#' @examples
#'   get_api_info("3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69")
get_api_info<-function(api_index) {

  if(is.null(getOption("api_info_data"))){
    options(api_info_data=import_api_details())}
  api_details<-getOption("api_info_data")
  api_details %>%
    dplyr::filter(.,index_name==api_index)

}



#' Get fields contained in the response of the API using the API index name
#'
#' @param api_index API index name you found using the search functions. You can
#' also get these from data.gov.in from a specific API page. In the request url,
#' it is followed by /resource/xxxxxxxx
#' For getting the relevant fields in the api use get_api_fields
#'
#' @return Data frame with 1 row , API that matches API ID ;
#'  contains id,name and type of the field - name and type are usually the same
#' @export
#'
#' @examples
#'   get_api_fields("3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69")
#'
#'
get_api_fields<-function(api_index) {

  if(is.null(getOption("api_fields_data"))){
    options(api_fields_data=import_field_details())}
    api_fields<-getOption("api_fields_data")

    df_api_fields<-api_fields %>%
      dplyr::filter(.,index_name==api_index) %>%
    .[1,2] %>%
    stringr::str_split(.,"\\|",simplify = F) %>%
    .[[1]] %>%
    matrix(.,ncol = 3,byrow = T) %>%
    data.frame()

  names(df_api_fields)<-c("id","name","type")

  return(df_api_fields)

}


#' Get data from API Index Name
#'
#' Using the API index name you got from the API Search/Discovery functions or
#' from the API list available on data.gov.in, get the data in a convenient way
#' parsed into a an R-friendly data frame.
#'
#' @param api_index Index name of the API
#' @param results_per_req Results to get per request ; "all" would get all the results
#' @param filter_by A named character vector of field name - value(s) pairs; can take multiple fields
#' as well as multiple comma separated values
#' @param field_select A character vector of fields required in the final data frame
#' @param sort_by A character vector of fields to sort by in the final data frame
#'
#' @return
#' @export
#'
#' @examples
#' search_api_by_title(title_contains="Air Quality") #Get index name from here
#' get_api_fields('3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69') #Example Index; get a list of fields
#' get_api_data(api_index="3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69",
#' results_per_req="all",filter_by=c(state="Punjab,Haryana",district="Amritsar,Ludhiana"),
#' field_select=c('state','district','city'),sort_by=c('state','district','city'))
get_api_data<-function(api_index, results_per_req="all",
                       filter_by=c(),field_select=c(),sort_by=c()){

  check_internet_connection()
  ##first a function that scrubs the API key if the show key option is false
  scrub_key<-function (string, with = "xxx")
  { if(getOption("datagovin")$key_shown==TRUE) {return(string)} else {}
    stringr::str_replace_all(string, "(key|client|signature)=(\\w+)",
                    stringr::str_c("\\1=", with))
  }





  ##filter takes only one value per field in the API - we need to make a solution for that
  ##within the wrrapper



  filter_matrix <- filter_by %>%
    stringr::str_split(.,",",simplify = T) %>%
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

      fill_data<-dplyr::bind_rows(fill_data,api_data)
      Sys.sleep(1)
      message("gave the API a rest")
      if((length(res$records)==0) | (results_per_req<req_cap)) break

      i=i+1

    }
    full_data<-dplyr::bind_rows(full_data,fill_data)

  }
  return(full_data)

}




