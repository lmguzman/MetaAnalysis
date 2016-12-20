library(rotl)
library(googlesheets)
library(dplyr)
library(taxize)


# read in google sheets
gs_ls(); Meta_analysis<-gs_title('Meta-analysis sheet')

#to do: subset separately each food web
Food_web_data<-gs_read(Meta_analysis, ws='food web version', range='G3:G160', col_names=FALSE)
#study<-gs_read(Meta_analysis, ws='food web version', range='A3:A160', col_names=FALSE)

sp_list <- Food_web_data %>% unlist() #list of species in foodweb


## To resolve names using taxize
gnr_resolve(sp_list[3])

### Using Open tree of life 
sps_matches <- tnrs_match_names(sp_list[3])

##using Encyclopedia of life
### Need to change this to exact = FALSE
res <- DownloadSearchedTaxa(sp_list[3], exact = FALSE) 


## Using Taxize

ok_name <- sps_matches$unique_name %>% str_split(pattern = '\\(') %>% unlist()

uids <- get_uid(ok_name[1])

classification(uids)

synonyms_try <- synonyms("Acer drummondii", db="itis")

syn_df <- synonyms_df(synonyms_try)

syn_df

get_ids("Acer drummondii", db = 'eol')
