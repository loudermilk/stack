library(tm)
source("stack-xml.R")

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!! ONLY FOCUS ON TAGS FOR NOW
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# reuters
#dir_src <- DirSource(system.file("texts", "crude", package = "tm"))

# datascience.stackexchange 
# tags
dir_src <- DirSource(directory = "data", pattern = SE$files$tags)

# reader must correspond to pattern above ^
corpus <- VCorpus(dir_src, readerControl = list(reader = readStackXMLTags))

toTagDF <- function(corpus) {
  #need to deal with uneven columns
  data.frame(id = corpus[[1]]$meta$id,
             tag = corpus[[1]]$meta$tags,
             count = corpus[[1]]$meta$counts)
            # excerpt = corpus[[1]]$meta$excerpt
            # wiki = corpus[[1]]$meta$wikipostid
}

## Create a tags_df 
## How to access XML meta data
corpus[[1]]$meta$tags
tags <- corpus[[1]]$meta$tags
counts <- as.integer(corpus[[1]]$meta$counts)
tags_df <- data.frame(tags = tags, counts = counts, stringsAsFactors = FALSE)

#' Plot bar chart of top n tags
plotTopNTags <- function(tags_df, n) {
  require(ggplot2)
  data <- tags_df[order(-counts),] 
  sub_data <- data[1:n,]
  ggplot(sub_data, aes(x = reorder(tags, -counts), y = counts)) +
    geom_bar(stat = "identity")
}

plotTopNTags(tags_df, 8)
