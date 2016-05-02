
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
  list(Id = list("attribute", "/tags/row/@Id"),
       ExcerptPostId = list("attribute", "/tags/row/@ExcerptPostId"),
       WikiPostId = list("attribute","/tags/row/@WikiPostId"),
       Count = list("attribute", "/tags/row/@Count"),
       TagName = list("attribute", "/tags/row/@TagName"))


readStackXMLTags <-
  readXML(spec = c(StackXMLSpecTag,
                   list(content = list(StackXMLSpecTag$TagName[[1]], StackXMLSpecTag$TagName[[2]]))), #/DATA
          doc = PlainTextDocument())


##################################################################################
## COMMENT
##################################################################################

StackXMLSpecComment <-
  list(Id = list("attribute", "/comments/row/@Id"),
       PostId = list("attribute", "/comments/row/@PostId"),
       Score = list("attribute","/comments/row/@Score"),
       Text = list("attribute", "/comments/row/@Text"),
       CreationDate = list("attribute", "/comments/row/@CreationDate"),
       UserId = list("attribute", "/comments/row/@UserId"))
#, tags = list("attribute", "/tags/row/@TagName")

readStackXMLComments <-
  readXML(spec = c(StackXMLSpecComment), 
          doc = PlainTextDocument())


##################################################################################
## POSTS
##################################################################################

StackXMLSpecPost <-
  list(Id = list("attribute", "/posts/row/@Id"),
       PostTypeId = list("attribute", "/posts/row/@PostTypeId"),
       CreationDate = list("attribute","/posts/row/@CreationDate"),
       Score = list("attribute", "/posts/row/@Score"),
       ViewCount = list("attribute", "/posts/row/@ViewCount"),
       Body = list("attribute", "/posts/row/@Body"),
       OwnerUserId = list("attribute", "/posts/row/@OwnerUserId"),
       LastActivityDate = list("attribute", "/posts/row/@LastActivityDate"),
       Title = list("attribute", "/posts/row/@Title"),
       Tags = list("attribute", "/posts/row/@Tags"),
       AnswerCount = list("attribute", "/posts/row/@AnswerCount"),
       CommentCount = list("attribute", "/posts/row/@CommentCount"),
       FavoriteCount = list("attribute", "/posts/row/@FavoriteCount"),
       ClosedDate = list("attribute", "/posts/row/@ClosedDate"))


readStackXMLPosts <-
  readXML(spec = c(StackXMLSpecPost), 
          doc = PlainTextDocument())


