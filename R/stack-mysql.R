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

#' @title Default connection to MySQL
#' @description manually code fields below to your setup
DEF_CONNECTION <- dbConnect(MySQL(),
                 user = 'brandon',
                 password = 'password',
                 host = 'localhost',
                 dbname='stackexchange')

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
