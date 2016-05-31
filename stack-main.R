## stack-main.R
##
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

#' @title Create StackExchange SQL Tables
#' 
#' @description Creates all SE SQL tables 
#' 
createStackExchangeSQLTables <- function() {

  #' Create new SQL table
  #' @param type character
  #' @description Given a supported SE table type
  #' create a corpus from the XML file, then create
  #' a data.frame which is used to generate the
  #' SQL table
  newSQLTable <- function(type) {
    print(paste("Creating table...", type))
    corpus <- newSECorpus(type)
    if (type %in% c("Comments", "Posts", "Users", "PostHistorys")) {
      data <- corpusToDF(corpus, add_content = TRUE)
    } else {
      data <- corpusToDF(corpus)
    }
    data$id <- NULL # SQL isn't case sensitive (ID/id the same)
    createSQLTable(con = DEF_CONNECTION, name = type, data = data)
  }
  
  ## create SQL table for all supported stackexchange tables
  mapply(newSQLTable, names(SE))
}


#' @title Do random SQL database stuff
#' 
#' @description Not a "real" function, just a place to
#' store various idioms and db functions as examples.
#' 
doDBStuff <- function(){
  
  ## list all database tables
  dbListTables(DEF_CONNECTION)
  
  ## create a new table 
  dbWriteTable(DEF_CONNECTION, "mtcars", mtcars)
  dbListTables(DEF_CONNECTION)

  ## list the column names
  dbListFields(DEF_CONNECTION, "mtcars")
  
  ## create data.frame from table
  foo <- dbReadTable(DEF_CONNECTION, "mtcars")
  class(foo)
  
  ## create and execute SQL select statements
  
  ## GET ALL QUESTIONS
  q <- "SELECT Id, OwnerUserId FROM Posts WHERE PostTypeId='1' LIMIT 10;"
  
  ## GET USER INFO FOR POST NODE
  q <- "SELECT p.Id, p.OwnerUserId, u.DisplayName, u.Reputation, u.CreationDate 
        FROM Posts as p, Users as u 
        WHERE p.Id='7' 
          AND p.OwnerUserId=u.Id;"
  
  q <- "SELECT p.ParentId FROM Posts as p WHERE p.ParentId='7'"
  
  res <- dbSendQuery(DEF_CONNECTION, q)
  dbFetch(res)
  dbClearResult(res)
  
  ## Or a chunk at a time
  res <- dbSendQuery(DEF_CONNECTION, "SELECT * FROM mtcars WHERE cyl = 4")
  while(!dbHasCompleted(res)){
    chunk <- dbFetch(res, n = 5)
    print(nrow(chunk))
  }
  # Clear the result
  dbClearResult(res)
  
  # Disconnect from the database
  dbDisconnect(DEF_CONNECTION)  
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




