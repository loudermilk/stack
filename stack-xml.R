
SE <- StackExchange <- {
  se <- list()
  class(se) <- "StackExchange"
  se$files <- list()
  se$files$badges <- "Badges.xml"
  se$files$comments <- "Comments.xml"
  se$files$posthistory <- "PostHistory.xml"
  se$files$postlinks <- "PostLinks.xml"
  se$files$posts <- "Posts.xml"
  se$files$tags <- "Tags.xml"
  se$files$users <- "Users.xml"
  se$files$votes <- "Votes.xml"
  se
}

##################################################################################
## TAGS
##################################################################################

StackXMLSpecTag <-
  list(id = list("attribute", "/tags/row/@Id"),
       excerpt = list("attribute", "/tags/row/@ExcerptPostId"),
       wikipostid = list("attribute","/tags/row/@WikiPostId"),
       counts = list("attribute", "/tags/row/@Count"),
       tags = list("attribute", "/tags/row/@TagName"))


readStackXMLTags <-
  readXML(spec = c(StackXMLSpecTag,
                   list(content = list(StackXMLSpecTag$tags[[1]], StackXMLSpecTag$tags[[2]]))), #/DATA
          doc = PlainTextDocument())


##################################################################################
## COMMENT
##################################################################################

StackXMLSpecComment <-
  list(id = list("attribute", "/comments/row/@Id"),
       postid = list("attribute", "/comments/row/@PostId"),
       score = list("attribute","/comments/row/@Score"),
       text = list("attribute", "/comments/row/@Text"),
       creationdate = list("attribute", "/comments/row/@CreationDate"),
       userid = list("attribute", "/comments/row/@UserId"))
#, tags = list("attribute", "/tags/row/@TagName")

readStackXMLComments <-
  readXML(spec = c(StackXMLSpecComment), 
          doc = PlainTextDocument())


