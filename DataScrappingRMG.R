library(Reol)
library(googlesheets)
library(dplyr)
library(rvest)
library(stringr)


# read in google sheets
gs_ls(); Meta_analysis<-gs_title('Meta-analysis sheet')

#to do: subset separately each food web
Food_web_data<-gs_read(Meta_analysis, ws='food web version', range='G3:G160', col_names=FALSE)
#study<-gs_read(Meta_analysis, ws='food web version', range='A3:A160', col_names=FALSE)


sp_list <- Food_web_data %>% unlist() #list of species in foodweb

data <- data.frame('study'=NA, 'eol_id'=NA, 'spp' = sp_list, 'species' = NA, 'body_length' = NA, 'body_mass' = NA, 'primary_diet' = NA, 'diet_includes' = NA, 'habitat' = NA,
                   'habitat_breadth' = NA, 'diet_breadth' = NA) #sheet to fill in data

cols <- c("\nbody length (VT)\naverage\n",  "\nbody mass\naverage\n", "\nprimary diet\n", "\ndiet includes\n", 
          "\nhabitat\n", "\nhabitat breadth\n", "\ndiet breadth\n") #which variables

i <- 145

#loopthrough all species
for (i in 1:length(sp_list)) {

print(i)

res <- DownloadSearchedTaxa(sp_list[i]) #spp code

#if species not found, skip to next loop interation
possibleError <- tryCatch(
  tmp1<-unlist(strsplit(res,"[l.xm]"))[2], #get species code from eol
    error=function(e) e
  )

  datapage<-paste("http://eol.org/pages/",tmp1,"/data",sep="")
  
  #get right variables
  sp1 <- read_html(datapage) 
  nodes_sp <- html_nodes(sp1, '.term , h3')
  sp_text <- html_text(nodes_sp)
  
  #writes NULL if species name doesnt exist
tryCatch( 
  species.name <- ifelse(is.null(DownloadSearchedTaxa(sp_list[i])),"NULL",matrix(strsplit(sp_text[1], "[><]")[[1]], 1)[1,3]),
  data$species[i]<-species.name,
  error=function(e) e
)


if(inherits(possibleError, "error")) next

#need some way to keep track of missing data in a way that doesnt F up code
tmp.a<-ifelse(cols [1] %in% sp_text == FALSE ,NA,which(sp_text %in% cols[1]))
tmp.b<-ifelse(cols [2] %in% sp_text == FALSE ,NA,which(sp_text %in% cols[2]))
tmp.c<-ifelse(cols [3] %in% sp_text == FALSE ,NA,which(sp_text %in% cols[3]))
tmp.d<-ifelse(cols [4] %in% sp_text == FALSE ,NA,which(sp_text %in% cols[4]))
tmp.e<-ifelse(cols [5] %in% sp_text == FALSE ,NA,which(sp_text %in% cols[5]))
tmp.f<-ifelse(cols [6] %in% sp_text == FALSE ,NA,which(sp_text %in% cols[6]))
tmp.g<-ifelse(cols [7] %in% sp_text == FALSE ,NA,which(sp_text %in% cols[7]))

data.pos <- c(1, tmp.a,tmp.b,tmp.c,tmp.d,tmp.e,tmp.f,tmp.g) #in html, find code and look one over for data
#data.pos <- c(1, (which(sp_text %in% cols) )) #in html, find code and look one over for data
sp_text[data.pos] #showing that it's pulling the right variables


#trait collection  
body.length <- ifelse(is.na(sp_text[data.pos[2]+1]),NA,matrix(strsplit(sp_text[data.pos[2]+1], "[m\n]")[[1]], 1)[1,2])
body.mass <- ifelse(is.na(sp_text[data.pos[3]+1]),NA,as.numeric(matrix(strsplit(sp_text[data.pos[3]+1], "[, m]")[[1]], 1)[1,2]))
diet.prim <- ifelse(is.na(sp_text[data.pos[4]+1]),NA,matrix(strsplit(sp_text[data.pos[4]+1], "[\n]")[[1]], 1)[1,2])
diet.sec <- ifelse(is.na(sp_text[data.pos[5]+1]),NA,matrix(strsplit(sp_text[data.pos[5]+1], "[\n]")[[1]], 1)[1,2])
habitat <- ifelse(is.na(sp_text[data.pos[6]+1]),NA,matrix(strsplit(sp_text[data.pos[6]+1], "[\n]")[[1]], 1)[1,2])
hab.breadth <- ifelse(is.na(sp_text[data.pos[7]+1]),NA,as.numeric(matrix(strsplit(sp_text[data.pos[7]+1], "[\n]")[[1]], 1)[1,2]))
diet.breadth <- ifelse(is.na(sp_text[data.pos[8]+1]),NA,as.numeric(matrix(strsplit(sp_text[data.pos[8]+1], "[\n]")[[1]], 1)[1,2]))

#put in data sheet
data$body_length[i]<-body.length
data$body_mass[i]<-body.mass
data$primary_diet[i]<-diet.prim
data$diet_includes[i]<-diet.sec 
data$habitat[i]<-habitat
data$habitat_breadth[i]<-hab.breadth
data$diet_breadth[i]<-diet.breadth 

#html_nodes(sp1, '.term, h3') %>% html_text()
#str_match(sp_text[data.pos[2]:data.pos[3]], 'adult') %>% as.vector

}                                                        
                            
