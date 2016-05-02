library(tm)
source("stack-xml.R")

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!! ONLY FOCUS ON TAGS FOR NOW
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
toTagDF <- function(corpus) {
  #need to deal with uneven columns
  data.frame(Id = corpus[[1]]$meta$Id,
             TagName = corpus[[1]]$meta$TagName,
             Count = corpus[[1]]$meta$Count)s
  # excerpt = corpus[[1]]$meta$excerpt
  # wiki = corpus[[1]]$meta$wikipostid
}

toPostDF <- function(corpus) {
  data.frame(Id = corpus[[1]]$meta$Id,
             PostTypeId = corpus[[1]]$meta$PostTypeId,
             CreationDate = corpus[[1]]$meta$CreationDate,
             Score = corpus[[1]]$meta$Score,
             Body = corpus[[1]]$meta$Body)
#   length(corpus[[1]]$meta$viewcount)
#   length(corpus[[1]]$meta$body)
#   length(corpus[[1]]$meta$owneruserid)
#   length(corpus[[1]]$meta$lastactivitydate)
#   length(corpus[[1]]$meta$title)
#   length(corpus[[1]]$meta$tags)
#   length(corpus[[1]]$meta$answercount)
#   length(corpus[[1]]$meta$commentcount)
#   length(corpus[[1]]$meta$favoritecount)
#   length(corpus[[1]]$meta$closeddate)
}



toCommentDF <- function(corpus) {
  data.frame(Id = corpus[[1]]$meta$Id,
             PostId = corpus[[1]]$meta$PostId,
             Score = corpus[[1]]$meta$Score,
             Text = corpus[[1]]$meta$Text,
             CreationDate = corpus[[1]]$meta$CreationDate)
  # ,  userid = corpus[[1]]$meta$userid
}


# datascience.stackexchange 
# tags, comments, posts
dir_src <- DirSource(directory = "data", pattern = SE$files$tags)

# reader must correspond to pattern above ^
corpus <- VCorpus(dir_src, readerControl = list(reader = readStackXMLTags))

# if we don't use $content then NULL it
corpus[[1]]$content <- NULL

df <- toTagDF(corpus)
View(head(df))



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
