library(tm)
source("stack-xml.R")

##
## Use this if you want to process multiple files
# dir_src <- DirSource(directory = "data", pattern = SE$files$tags)

xml_file <- "data/Users.xml"



mySource <- function(x){
  XMLSource(x, function(tree) XML::xmlChildren(XML::xmlRoot(tree)), 
            readStackXMLUsers)
} 


corpus <- VCorpus(mySource(xml_file))
meta(corpus[[3298]])


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

searchCorpus(corpus, attribute, value)


dtm <- DocumentTermMatrix(corpus)
inspect(dtm[, grepl("Brandon", dtm$dimnames$Terms)])

dtm$dimnames$Terms
# reader must correspond to pattern above ^
#corpus <- VCorpus(dir_src, readerControl = list(reader = readStackXMLUsers))
# if we don't use $content then NULL it
#corpus[[1]]$content <- NULL

#corpus[[1]]$meta$AboutMe
#df <- toTagDF(corpus)
#View(head(df))



# ## Create a tags_df 
# ## How to access XML meta data
# corpus[[1]]$meta$tags
# tags <- corpus[[1]]$meta$tags
# counts <- as.integer(corpus[[1]]$meta$counts)
# tags_df <- data.frame(tags = tags, counts = counts, stringsAsFactors = FALSE)
# 
#
# Need to refactor plotTopNTags
#
# #' Plot bar chart of top n tags
# plotTopNTags <- function(tags_df, n) {
#   require(ggplot2)
#   data <- tags_df[order(-counts),] 
#   sub_data <- data[1:n,]
#   ggplot(sub_data, aes(x = reorder(tags, -counts), y = counts)) +
#     geom_bar(stat = "identity")
# }
# 
# plotTopNTags(tags_df, 5)
