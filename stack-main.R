## stack-main.R
##
## Main driver program for stackexchange analytics
##
## `main()` - will overwrite MySQL database `stackexchange` with 
## new data imported from SE *.xml files. It will create the following
## tables: Tags, Users, Posts, Comments, Votes, PostLinks, PostHistorys,
## and Badges.
##
library(tm)
source("stack-xml.R")
source("stack-mysql.R")


#' @title SE - StackExchange structure containing file_name reference and reader.
SE <- list(Tags = list(file_name = "data/Tags.xml", reader = readStackXMLTags),
           Users = list(file_name = "data/Users.xml", reader = readStackXMLUsers),
           Posts = list(file_name = "data/Posts.xml", reader = readStackXMLPosts),
           Comments = list(file_name = "data/Comments.xml", reader = readStackXMLComments),
           Votes = list(file_name = "data/Votes.xml", reader = readStackXMLVotes),
           PostLinks = list(file_name = "data/PostLinks.xml", reader = readStackXMLPostLinks),
           PostHistorys = list(file_name = "data/PostHistory.xml", reader = readStackXMLPostHistorys),
           Badges = list(file_name = "data/Badges.xml", reader = readStackXMLBadges))



#' @title New StackExchange Corpus
#' 
#' @param type character name of SE table (see SE_TABLES for supported table types)
#' @return VCorpus
#' 
newSECorpus <- function(type) {
  if (!type %in% names(SE)) {return(NULL)} 
  
  f <- SE[[type]]$file_name
  r <- SE[[type]]$reader
  createCorpus(f, r)
}

#' @title Create a corpus from file_name using reader
#' 
#' @param file_name character name of xml file
#' @param reader
#' @return VCorpus
#' 
createCorpus <- function(file_name, reader) {
  mySource <- function(x){
    XMLSource(x, function(tree) XML::xmlChildren(XML::xmlRoot(tree)), 
              reader)
  } 
  corpus <- VCorpus(mySource(file_name))
  return(corpus)
}




#' @title Exhaustive corpus search for attribute == value
#' 
#' @param corpus
#' @param attribute (e.g., "DisplayName")
#' @param value ("Brandon Loudermilk")
#' 
#' @return integer vector
searchCorpus <- function(corpus, attribute, value){
  out_list <- c()
  for (i in 1:length(corpus)) {
    mt <- meta(corpus[[i]])
    if (mt[[attribute]] == value) {
      out_list <- c(out_list, i)
    }
  }
  return(out_list)
}


#' @title Create data.frame of meta data from corpus
#' @param corpus
#' @return data.frame
#' 
corpusToDF <- function(corpus, add_content = FALSE) {
  last <- length(corpus) 
  
  # assume that the doc with most meta info has *all* the meta info
  # get list of number of meta entries
  ll <- sapply(corpus, function(d) length(unlist(meta(d))))
  indices <- which(max(ll) == ll)
  ref_index <- indices[1]
  
  ## determine number of columns
  ref_doc <- corpus[[ref_index]] # has most meta-data
  
  master_vec <- unlist(meta(ref_doc))
  meta_col_headers <- names(master_vec)
  meta_list <- list()
  for (i in 1:last) {
    doc <- corpus[[i]]
    m <- meta(doc)
    char_vec <- unlist(m)
    
    ## normalize char_vec according to master_vec
    new_vec <- master_vec
    new_vec[1:length(new_vec)] <- NA
    for (j in 1:length(char_vec)) {
      n <- names(char_vec[j])[1]
      v <- char_vec[j]
      new_vec[n] <- v
    }
    
    if (add_content){
      content <- content(doc)
      if (length(content) > 0) {
        new_vec["Content"] <- content
      } else {
        new_vec["Content"] <- NA
      }
    }
    
    meta_list[[i]] <- new_vec
  }
  
  df <- t(data.frame(meta_list))
  names(df) <- meta_col_headers
  df <- as.data.frame(df)
  return(df)
}



# searchCorpus(corpus, attribute, value)
# dtm <- DocumentTermMatrix(corpus)
# inspect(dtm[, grepl("Brandon", dtm$dimnames$Terms)])
# dtm$dimnames$Terms

##
## MAIN
##

##
## Method #1
##
# type <- "Badges"
# cc <- newSECorpus(type)
# corpus <- cc[1:4]
# 
# name <- "posts"
# data <- corpusToDF(corpus)
# data$id <- NULL # SQL isn't case sensitive
# createSQLTable(con = DEF_CONNECTION, name = name, data = data)

##
## Method #2
##
# file_name <- xml_file <- "data/PostLinks.xml"
# reader <- readStackXMLPostLinks
# corpus <- createCorpus(file_name, reader)
# meta(corpus[[1]])


main <- function() {
  createStackExchangeSQLTables()
}




