library(Reol)
library(googlesheets)
library(dplyr)
library(rvest)
library(stringr)


# read in google sheets
gs_ls()

Meta_analysis<-gs_title('Meta-analysis sheet')

# Change the range for the appropriate cols 

Food_web_data<-gs_read(Meta_analysis, ws='food web version', range='G3:G160', col_names=FALSE)


sp_list <- Food_web_data %>% unlist()
names(sp_list) <- NULL




GetIUCNStat(res[[2]])

res <- DownloadSearchedTaxa(sp_list[158], to.file=FALSE, exact=TRUE)

res %>% names()

sp1 <- read_html("http://eol.org/pages/328580/data")

nodes_sp <- html_nodes(sp1, '.term , h3')

sp_text <- html_text(nodes_sp)


sp_text %>% as.data.frame()

str_locate(sp_text, "Physical Description")

cols <- c("\nbody length (VT)\naverage\n",  "\nbody mass\naverage\n", "\nprimary diet\n", "\ndiet includes\n", 
          "\nhabitat\n", "\nhabitat breadth\n", "\ndiet breadth\n")


data.pos <- c(1, (which(sp_text %in% cols) + 1))

final_data <- data.frame('Species' = NA, 'Body_Length' = NA, 'Body_Mass' = NA, 'primary_diet' = NA, 'diet_includes' = NA, "habitat" = NA,
                         "habitat breadth" = NA, "diet breadth" = NA) 

sp_text_2[data.pos]

Species <- str_extract(sp_text_2[1], "\>[\.]"


html_nodes(sp1, '.term, h3') %>% html_text()

str_match(sp_text[data.pos[2]:data.pos[3]], 'adult') %>% as.vector

"Physical Description" -> all


 Search for adult 
   
"Ecology"  



                                                            
                            

"\nwater nitrate concentration\nmin\n"                                      
"\nwater nitrate concentration\nmax\n"                                      
"\nwater temperature\nmin\n"                                   
"\nwater temperature\nmax\n"                                      
"\nwater silicate concentration\nmin\n"                                   
 "\nwater silicate concentration\nmax\n"                                 
"\nwater phosphate concentration\nmin\n"                                   
"\nwater phosphate concentration\nmax\n"                                   
"\nwater dissolved O2 concentration\nmin\n"                                 
"\nwater dissolved O2 concentration\nmax\n"                               
"\nwater O2 saturation\nmin\n"                                          
"\nwater O2 saturation\nmax\n"                                          
"\nwater salinity\nmin\n"                                                   
"\nwater salinity\nmax\n" 


"Life History and Behavior"  
"\nhome range\naverage\n" 
"\nclutch/brood/litter size\naverage\n" 
"\ntotal life span\nmax\n"
"\npopulation group size\naverage\n"


"Conservation"
"\nconservation status\n"  

sp_text_1 <- str_replace(sp_text, "\n", "")
sp_text_2 <- str_replace(sp_text_1, "\n", "")


grep()
