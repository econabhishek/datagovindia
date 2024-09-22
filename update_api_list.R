rm(list = ls())
gc()
library(git2r)
setwd("~/Dropbox/datagovinwrap/datagovindia/")
repo<-repository(getwd())



###scraping all node names for APIs - a weekly scrape is fine
setwd("~/Dropbox/datagovinwrap/datagovindia/")
###load packages
library(git2r)
library(httr)
library(dplyr)
library(stringr)
library(plyr)
library(lubridate)


##turn off scientific notation
options(scipen = 100)


##There are about 80,000 apis available on the open data portal of GoI. We should get
gc()
##Getting the total number of APIs to get an idea of how many requests are required
number_apis_in_page=10
api_list_url<-paste0("https://api.data.gov.in/lists?format=json&notfilters[source]=visualize.data.gov.in&filters[active]=1&offset=0&sort[updated]=desc&limit=",number_apis_in_page)
req<-httr::GET(url = api_list_url)
res<-httr::content(req)
total_apis_avail<-res$total

####Some items in the list are lists themselves - we unlist them, collapse with a "|"
### we can get these back again using names of these. First we identify these fields.
###doing this for the first element is enough

##which lengths are more than 1 -
multiple_element_ind<-which((res$records[[1]] %>%
                               lapply(.,function(x) unlist(x) %>%
                                        length())>1))

##which names are more than 1 -
multiple_names_ind <- which((res$records[[1]] %>%
  lapply(.,function(x) unlist(x) %>%
           names %>%
           unique %>% length))>1)


##names of these fields
res$records[[1]][multiple_names_ind] %>% lapply(.,function(x) unlist(x) %>% names() %>% unique)



 api_df<-lapply(res$records, function(y) {
    lapply(y,function(x) unlist(x) %>%
             paste(.,collapse = "|")) %>%
    as.data.frame()}) %>%
   plyr::rbind.fill(fill=T)

  # %>% as.data.frame %>% plyr::rbind.fill(fill=T)

##drop observations
api_df<-api_df[0,]
##get a portion of the API df


###divide the requests in chunks of 10k

number_apis_in_page<-10000
offset_seq<-seq(0,total_apis_avail,10000)

for(i in 1:length(offset_seq)){



  api_list_url<-paste0("https://api.data.gov.in/lists?format=json&notfilters[source]=visualize.data.gov.in&filters[active]=1&offset=",offset_seq[i],"&sort[updated]=desc&limit=",number_apis_in_page)
  req<-httr::GET(url = api_list_url)
  res<-httr::content(req)
  temp_df<-lapply(res$records, function(y) {
    lapply(y,function(x) unlist(x) %>%
             paste(.,collapse = "|")) %>%
      as.data.frame()}) %>%
    plyr::rbind.fill(fill=T)

  api_df<-bind_rows(api_df,temp_df)

}

##Renaming
api_df<-api_df %>%
  plyr::rename(.,c("desc"="description"))
#
# check_names<-c("index_name", "title", "description", "created", "updated", "visualizable",
#                  "source", "org_type", "org", "sector", "catalog_uuid", "status",
#                  "field", "created_date", "updated_date", "active", "external_ws_url",
#                  "external_ws", "target_bucket", "timestamp", "field_name", "type",
#                  "target_type")

write.csv(api_df,"api_df.csv",row.names = F)

api_df<-read.csv('api_df.csv')

api_df <-api_df %>%
  mutate(created_date=as_datetime(created,tz="Asia/Calcutta"),
         updated_date=as_datetime(updated, tz="Asia/Caclutta"))

# api_df<-api_df[,-c(8:10,11:12,15,17:23)]

api_df<-api_df %>%
  select("index_name", "title", "description",
         "source", "org_type", "org", "sector",
         "field", "created_date", "updated_date", "active")

split_seq<-c(seq(1,nrow(api_df),20000),nrow(api_df))

##For user info
text_info_api_df<-api_df[,c("index_name","title","description","org_type","org","sector","source","created_date","updated_date")]

# ##Break it in chunks and save it
# split_list_text_info<-vector("list",length(split_seq)-1)
# for (i in 1:(length(split_seq)-1)) {
#   split_list_text_info[[i]]<-text_info_api_df[split_seq[i]:split_seq[i+1],]
# }
#
# for(i in 1:length(split_list_text_info)) {
#   saveRDS(split_list_text_info[[1]],paste0("./api_library_data/text_info_api_df_",i,".rds"))
# }



saveRDS(text_info_api_df,"./api_library_data/text_info_api_df.rds")
#write.csv(text_info_api_df,"./text_info_api_df.csv",row.names = F)

#Fields for api
field_api_df<-api_df[,c("index_name","field")]
# split_list_field<-vector("list",length(split_seq)-1)
# for (i in 1:(length(split_seq)-1)) {
#   split_list_field[[i]]<-field_api_df[split_seq[i]:split_seq[i+1],]
# }
#
# for(i in 1:length(split_list_field)) {
#   saveRDS(split_list_field[[1]],paste0("./api_library_data/field_api_df_",i,".rds"))
# }



saveRDS(field_api_df,"./api_library_data/field_api_df.rds")
#write.csv(field_api_df,"field_api_df.csv",row.names = F)


###Git commit and push



config(repo, user.name="econabhishek", user.email="abhishek.arora1996@gmail.com")

add(repo, "./api_library_data/field_api_df.rds")
add(repo, "./api_library_data/text_info_api_df.rds")

Sys.setenv(GITHUB_PAT="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")

cred<-cred_token()

commit(repo, "Updated API library")

push(repo, "origin", "refs/heads/master",credentials = cred)

rm(list=ls())
gc()
