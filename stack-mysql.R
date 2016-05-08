# stack-mysql.R
#
# Create MySQL database and tables for stackexxchange data
#
# Assumes: 
# (1) MySQL server instance running
# (2) has a database called 'stackexchange'
#     mysql> CREATE DATABASE stackexchange;
#     mysql> USE stackexchange;
# (3) user privileges set
#     mysql> grant all privileges on *.* to bill@localhost identified by 'passpass' with grant option;
# from cmd - mysql --host=localhost --user=bill --password=passpass events
#
# grant all privileges on *.* to bill@localhost identified by 'passpass' with grant option;


install.packages("RMySQL")
library(RMySQL)



con <- dbConnect(MySQL(),
                 user = 'bill',
                 password = 'passpass',
                 host = 'localhost',
                 dbname='stackexchange')
#dbWriteTable(conn = con, name = 'Test', value = as.data.frame(Thurstone))

foo <- data.frame(name = "Pirate King", 
                  food = "Mutton Biryani", 
                  confirmed = "Y", 
                  signup_date = '2016-05-07')


createSQLTable <- function(con, name, data) {
  dbWriteTable(conn = con, 
               name = name, 
               value = data, 
               overwrite = TRUE, 
               row.names = FALSE, 
               append = FALSE)
}

createSQLTable(con = con, "stuff", data = foo)

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
  
   meta_list <- list()
  for (i in 1:last) {
    doc <- corpus[[i]]
    m <- meta(doc)
    char_vec <- unlist(m)
    print(length(char_vec))
    
    ## normalize char_vec according to master_vec
    missing_col_names <- setdiff(x = names(master_vec), y = names(char_vec))
    new_vec <- master_vec
    new_vec[1:length(new_vec)] <- NA
    for (j in 1:length(char_vec)) {
      n <- names(char_vec[j])[1]
      v <- char_vec[j]
      new_vec[n] <- v
    }
    
    meta_list[[i]] <- new_vec
  }
  
  df <- data.frame(meta_list)
  names(df) <- meta_col_headers
  return(df)
  #m <- meta(corpus[[1]])
  #data.frame(text = sapply(corpus, as.character), stringsAsFactors = FALSE)
}





#dbWriteTable(conn = con, name = 'potluck', value = foo, overwrite = T, row.names = FALSE, append = FALSE)


dbListTables(con)

#INSERT INTO `potluck` (`id`,`name`,`food`,`confirmed`,`signup_date`) VALUES (NULL, "Sandy", "Key Lime Tarts","N", '2012-04-14')

