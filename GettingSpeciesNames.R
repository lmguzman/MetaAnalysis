library(rotl)
library(googlesheets)
library(dplyr)
library(taxize)
library(stringr)


# read in google sheets
gs_ls(); Meta_analysis<-gs_title('Meta-analysis sheet')

#to do: subset separately each food web
Food_web_data<-gs_read(Meta_analysis, ws='food web version', range='G3:G160', col_names=FALSE)
#study<-gs_read(Meta_analysis, ws='food web version', range='A3:A160', col_names=FALSE)

sp_list <- Food_web_data %>% unlist() #list of species in foodweb


for(i in 1:length(sp_list)){
  i <- 4
  ## To resolve names using taxize
  resolved_name <- gnr_resolve(sp_list[i])$matched_name[1]
  ### Using Open tree of life 
  
  sps_matches <- tryCatch({
     tnrs_match_names(sp_list[i])
  }, error=function(e) e)
  
  str(sps_matches)
  if(is.list(sps_matches), sps_matches = NA)
  getting_other_matches <- sps_matches$unique_name %>% str_split(pattern = '\\(') %>% unlist()
  
  TOL_name <- getting_other_matches[1]
  
  # Get classification to try by genus
  
  genus <- tryCatch({
    uids <- get_uid(TOL_name)
    Classification <- classification(uids)[[1]]
    if(!is.na(Classification)) {Classification %>% filter(rank == 'genus') %>% select(name) %>% unlist()}
  },error=function(e) e)
  
  names_all <- c(resolved_name, TOL_name, genus)

}






##using Encyclopedia of life
### Need to change this to exact = FALSE
res <- DownloadSearchedTaxa(sp_list[3], exact = FALSE) 



## to get the IDS from eol for the scrapping 
get_ids("Acer drummondii", db = 'eol')

# Get synonyms

synonyms_try <- synonyms(resolved_name, db="itis", rows = 1:5)

syn_df <- synonyms_df(synonyms_try)

