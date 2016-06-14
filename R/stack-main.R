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
source("R/stack-xml.R")
source("R/stack-mysql.R")


#' @title Create file path to xml source files
#' @param name character
#' @return character
#'
filePath <- function(name) {
  DATA_DIR <- "se-data"
  PATH_SEP <- "/"
  EXT_XML <- "xml"
  DOT <- "."

  paste0(DATA_DIR, PATH_SEP, name, DOT, EXT_XML)
}


#' @title SE - StackExchange structure containing file_name reference and reader.
SE <- list(Tags = list(file_name = filePath("Tags"), reader = readStackXMLTags),
           Users = list(file_name = filePath("Users"), reader = readStackXMLUsers),
           Posts = list(file_name = filePath("Posts"), reader = readStackXMLPosts),
           Comments = list(file_name = filePath("Comments"), reader = readStackXMLComments),
           Votes = list(file_name = filePath("Votes"), reader = readStackXMLVotes),
           PostLinks = list(file_name = filePath("PostLinks"), reader = readStackXMLPostLinks),
           PostHistorys = list(file_name = filePath("PostHistory"), reader = readStackXMLPostHistorys),
           Badges = list(file_name = filePath("Badges"), reader = readStackXMLBadges))



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
    tm::XMLSource(x, function(tree) XML::xmlChildren(XML::xmlRoot(tree)), reader)
  }
  corpus <- tm::VCorpus(mySource(file_name))
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
#' @notes there is a ton of stuff that can be optimized
#' here (i.e. uber slow and inefficient), but for now
#' "pre-mature optimization is the root of all that is evil
#' in computer science" to paraphases Dr. Knuth.
#'
corpusToDF <- function(corpus, add_content = FALSE) {
  last <- length(corpus)

  ## BEGIN - alternative approach to df constructor
  dd <- lapply(corpus, function(d) unlist(meta(d)))
  d1 <- unlist(dd)
  fields <- unique(names(d1))

  strip_fields <- c()
  for (f in fields) {
    pos <- gregexpr('\\.', f)
    strip_fields <- c(strip_fields, substr(f, pos[[1]][2] + 1, nchar(f)))
  }

  out_list <- list()
  for (i in 1:last) {
    doc <- corpus[[i]]
    m <- meta(doc)
    out_row <- list()
    for (s in strip_fields) {
      out_row[[s]] <- NA
      val <- m[[s]]
      if (length(val) != 0) {
        out_row[[s]] <- val
      }
    }
    if (add_content){
      content <- content(doc)
      if (length(content) > 0) {
        out_row["Content"] <- content
      } else {
        out_row["Content"] <- NA
      }
    }
    out_list[[i]] <- data.frame(out_row)
  }

  ## Build the data.frame (needs to be optimized)
  df <- data.frame(out_list[[1]])
  for (j in 2:length(out_list)) {
    new_df <- data.frame(out_list[[j]])
    df <- rbind(df, new_df)
  }

  return(df)
}

#' @title create bag of words data.frame
#' @param df data.frame
#' @param content_col character name of content column
#' @return data.frame
generateBagOfWords <- function(df, content_col = "Content") {

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




