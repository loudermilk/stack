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
#' @param name 
#' @param data
createSQLTable <- function(con, name, data) {
  dbWriteTable(conn = con, 
               name = name, 
               value = data, 
               overwrite = TRUE, 
               row.names = FALSE, 
               append = FALSE)
}


