library(tm)
source("stack-xml.R")
source("stack-mysql.R")

##
## Use this if you want to process multiple files
# dir_src <- DirSource(directory = "data", pattern = SE$files$tags)


SE <- list(Tags = list(file_name = "data/Tags.xml", reader = readStackXMLTags),
           Users = list(file_name = "data/Users.xml", reader = readStackXMLUsers),
           Posts = list(file_name = "data/Posts.xml", reader = readStackXMLPosts),
           Comments = list(file_name = "data/Comments.xml", reader = readStackXMLComments),
           Votes = list(file_name = "data/Votes.xml", reader = readStackXMLVotes),
           PostLinks = list(file_name = "data/PostLinks.xml", reader = readStackXMLPostLinks),
           PostHistorys = list(file_name = "data/PostHistory.xml", reader = readStackXMLPostHistorys),
           Badges = list(file_name = "data/Badges.xml", reader = readStackXMLBadges))






newSECorpus <- function(type) {
  f <- SE[[type]]$file_name
  r <- SE[[type]]$reader
  createCorpus(f, r)
}

#' Create a corpus from file_name using reader
#' @param file_name character
#' @param reader
#' 
createCorpus <- function(file_name, reader) {
  mySource <- function(x){
    XMLSource(x, function(tree) XML::xmlChildren(XML::xmlRoot(tree)), 
              reader)
  } 
  corpus <- VCorpus(mySource(file_name))
  return(corpus)
}
##
## Method #1
##
# type <- "Posts"
# cc <- newSECorpus(type)
# corpus <- cc[1:4]
# 
# name <- "posts"
# data <- corpusToDF(corpus)
# data$id <- NULL # SQL isn't case sensitive
# createSQLTable(con = DEF_CONNECTION, name = name, data = data)

createStackExchangeSQLTables <- function() {
  newSQLTable <- function(type) {
    print(paste("Creating table...", type))
    corpus <- newSECorpus(type)
    data <- corpusToDF(corpus)
    data$id <- NULL # SQL isn't case sensitive
    createSQLTable(con = DEF_CONNECTION, name = type, data = data)
  }
  
  newSQLTable("Tags")
  newSQLTable("Users")
  newSQLTable("Posts")
  newSQLTable("Comments")
  newSQLTable("Votes")
  newSQLTable("PostLinks")
  newSQLTable("PostHistorys")
  newSQLTable("Badges")
}

doDBStuff <- function(){
  dbListTables(DEF_CONNECTION)
  dbWriteTable(DEF_CONNECTION, "mtcars", mtcars)
  dbListTables(DEF_CONNECTION)

  dbListFields(DEF_CONNECTION, "mtcars")
  foo <- dbReadTable(DEF_CONNECTION, "mtcars")
  class(foo)
  
  # You can fetch all results:
  #query
  
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
  
  # Or a chunk at a time
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
##
## Method #2
##
# file_name <- xml_file <- "data/PostLinks.xml"
# reader <- readStackXMLPostLinks
# corpus <- createCorpus(file_name, reader)
# meta(corpus[[1]])


#' Exhaustive corpus search for attribute == value
#' @param corpus
#' @param attribute (e.g., "DisplayName")
#' @param value ("Brandon Loudermilk")
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

# searchCorpus(corpus, attribute, value)
# dtm <- DocumentTermMatrix(corpus)
# inspect(dtm[, grepl("Brandon", dtm$dimnames$Terms)])
# dtm$dimnames$Terms
