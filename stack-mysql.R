# stack-mysql.R
#
# Create MySQL database and tables for stackexxchange data
#
# Assumes: 
# (1) MySQL server instance running
#     $ mysql -u root -p
# (2) has a database called 'stackexchange'
#     mysql> CREATE DATABASE stackexchange;
#     mysql> USE stackexchange;
# (3) user privileges set
#     mysql> CREATE USER 'foobar'@'localhost' IDENTIFIED BY 'password'
#     mysql> GRANT ALL PRIVILEGES ON *.* TO foobar@localhost IDENTIFIED BY 'password' WITH GRANT OPTION;
#     $ mysql --host=localhost --user=foobar --password=password stackexchange
#

library(RMySQL)

DEF_CONNECTION <- dbConnect(MySQL(),
                 user = 'brandon',
                 password = 'password',
                 host = 'localhost',
                 dbname='stackexchange')


createSQLTable <- function(con, name, data) {
  dbWriteTable(conn = con, 
               name = name, 
               value = data, 
               overwrite = TRUE, 
               row.names = FALSE, 
               append = FALSE)
  
}


#' Create data.frame of meta data from corpus
#' @param corpus
#' @return data.frame
#' 
corpusToDF <- function(corpus) {
  last <- length(corpus) 
  
  # assume that the doc with most meta info has *all* the meta info
  # get list of number of meta entries
  ll <- sapply(corpus, function(d) length(unlist(meta(d))))
  indices <- which(max(ll) == ll)
  ref_index <- indices[1]
  
  ## determine number of columns
  ref_doc <- corpus[[ref_index]]
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
    
    meta_list[[i]] <- new_vec
  }
  
  df <- t(data.frame(meta_list))
  names(df) <- meta_col_headers
  df <- as.data.frame(df)
  return(df)
}

