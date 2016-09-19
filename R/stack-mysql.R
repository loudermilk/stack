## stack-mysql.R
##
## Create MySQL database and tables for StackExchange data
##
## Assumes:
## (1) MySQL server instance running
##     $ mysql -u root -p
## (2) has a database called 'stackexchange'
##     mysql> CREATE DATABASE stackexchange;
##     mysql> USE stackexchange;
## (3) user privileges set
##     mysql> CREATE USER 'foobar'@'localhost' IDENTIFIED BY 'password'
##     mysql> GRANT ALL PRIVILEGES ON *.* TO foobar@localhost IDENTIFIED BY 'password' WITH GRANT OPTION;
##     $ mysql --host=localhost --user=foobar --password=password stackexchange
##
## Useful SQL commands:
## mysql> SHOW DATABASES;
## mysql> USE database;
## mysql> SHOW TABLES;
## mysql> DESCRIBE table;
## mysql> DROP TABLE table;
##
library(RMySQL)



#' @title Create SQL Table
#'
#' @param con connection
#' @param name character name of table
#' @param data data.frame
#'
createSQLTable <- function(con, name, data) {
  dbWriteTable(conn = con,
               name = name,
               value = data,
               overwrite = TRUE,
               row.names = FALSE,
               append = FALSE)
}


#' @title Create StackExchange SQL Tables
#'
#' @description Creates all SE SQL tables
#'
createStackExchangeSQLTables <- function() {

  #' @title Default connection to MySQL
  #' @description manually code fields below to your setup
  #' !! WARNING !!- hard-codes need to be parameterized
  DEF_CONNECTION <<- dbConnect(MySQL(),
                              user = 'brandon',
                              password = 'password',
                              host = 'localhost',
                              dbname='stackexchange')

  #' Create new SQL table
  #' @param type character
  #' @description Given a supported SE table type
  #' create a corpus from the XML file, then create
  #' a data.frame which is used to generate the
  #' SQL table
  newSQLTable <- function(type) {
    cleanFun <- function(htmlString) {
      return(gsub("<.*?>", "", htmlString))
    }

    print(paste("Creating table...", type))
    corpus <- newSECorpus(type)
    print("Removing whitespace...")
    corpus <- tm::tm_map(corpus, tm::stripWhitespace)
    print("Scrubbing html...")
    corpus <- tm::tm_map(corpus, tm::content_transformer(cleanFun))
    print("To lowercase...")
    corpus <- tm::tm_map(corpus, tm::content_transformer(tolower))
    print("Removing numbers...")
    corpus <- tm::tm_map(corpus, tm::content_transformer(tm::removeNumbers))
    print("Removing punctuation") #removePunctuation
    corpus <- tm::tm_map(corpus, tm::content_transformer(tm::removePunctuation))
    print("Removing stop words")
    corpus <- tm::tm_map(corpus, tm::removeWords, tm::stopwords('english'))

    if (type %in% c("Comments", "Posts", "Users", "PostHistorys")) {
      dtm <- tm::DocumentTermMatrix(corpus)
      m <- as.matrix(dtm)
      bow_df <- as.data.frame(m)

      ## Start PR-21 - (remove hapaxes)
      col_sums <- apply(bow_df, 2, sum) ## count ocurrences of word features
      non_hapax_index <- col_sums > 3 ## that have freq higher than three
      bow_df <- bow_df[,non_hapax_index] ## only select high freq columns
      ## End PR-21


      ## Start PR-17 - (remove non-Roman words features)
      names <- names(bow_df)
      # Then find indices of words with non-ASCII characters using ICONV
      characters.non.ASCII <- grep("names",
                                   iconv(names, "latin1", "ASCII", sub="characters.unlist"))
      # subset original vector of words to exclude words with non-ASCII characters
      bow_df <- bow_df[,-characters.non.ASCII]
      ## End PR-17

      names(bow_df) <- paste0("has_", names(bow_df))
      data <- corpusToDF(corpus, add_content = TRUE)
      data <- cbind(data, bow_df)

      data <- data[, nchar(names(data)) < 30] #filter out long names (b/c MySQL)
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
  DEF_CONNECTION <- NULL #turning this off until #14 fixed

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


  ## PR-3 : create sql query to retreive questions and answers
  ## Going to create two different queries:
  ## QUESTIONS
  q <- "SELECT Id, OwnerUserId FROM Posts WHERE PostTypeId='1' AND Id=7 LIMIT 10;"
  ## RESPONSES
  q <- "SELECT Id, ParentId, OwnerUserId FROM Posts WHERE ParentId=7;"

  q <- "SELECT Id, ParentId, OwnerUserId FROM Posts WHERE ParentId=7 OR Id=7"


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
