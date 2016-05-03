
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
  list(Id = list("attribute", "/row/@Id"),
       ExcerptPostId = list("attribute", "/row/@ExcerptPostId"),
       WikiPostId = list("attribute","/row/@WikiPostId"),
       Count = list("attribute", "/row/@Count"),
       TagName = list("attribute", "/row/@TagName"))


readStackXMLTags <-
  readXML(spec = c(StackXMLSpecTag), 
          doc = PlainTextDocument())


##################################################################################
## COMMENT
##################################################################################

StackXMLSpecComment <-
  list(Id = list("attribute", "/row/@Id"),
       PostId = list("attribute", "/row/@PostId"),
       Score = list("attribute","/row/@Score"),
       Text = list("attribute", "/row/@Text"),
       CreationDate = list("attribute", "/row/@CreationDate"),
       UserId = list("attribute", "/row/@UserId"))


readStackXMLComments <-
  readXML(spec = c(StackXMLSpecComment), 
          doc = PlainTextDocument())


##################################################################################
## POSTS
##################################################################################

StackXMLSpecPost <-
  list(Id = list("attribute", "/row/@Id"),
       PostTypeId = list("attribute", "/row/@PostTypeId"),
       CreationDate = list("attribute","/row/@CreationDate"),
       Score = list("attribute", "/row/@Score"),
       ViewCount = list("attribute", "/row/@ViewCount"),
       Body = list("attribute", "/row/@Body"),
       OwnerUserId = list("attribute", "/row/@OwnerUserId"),
       LastActivityDate = list("attribute", "/row/@LastActivityDate"),
       Title = list("attribute", "/row/@Title"),
       Tags = list("attribute", "/row/@Tags"),
       AnswerCount = list("attribute", "/row/@AnswerCount"),
       CommentCount = list("attribute", "/row/@CommentCount"),
       FavoriteCount = list("attribute", "/row/@FavoriteCount"),
       ClosedDate = list("attribute", "/row/@ClosedDate"))


readStackXMLPosts <-
  readXML(spec = c(StackXMLSpecPost), 
          doc = PlainTextDocument())

##################################################################################
## USERS
##################################################################################

StackXMLSpecUser <-
  list(Id = list("attribute", "/row/@Id"),
       Reputation = list("attribute", "/row/@Reputation"),
       CreationDate = list("attribute","/row/@CreationDate"),
       DisplayName = list("attribute", "/row/@DisplayName"),
       LastAccessDate = list("attribute", "/row/@LastAccessDate"),
       WebsiteUrl = list("attribute", "/row/@WebsiteUrl"),
       Location = list("attribute", "/row/@Location"),
       #AboutMe = list("attribute", "/row/@AboutMe"),
       Views = list("attribute", "/row/@Views"),
       UpVotes = list("attribute", "/row/@UpVotes"),
       DownVotes = list("attribute", "/row/@DownVotes"),
       AccountId = list("attribute", "/row/@AccountId"))


readStackXMLUsers <-
  readXML(spec = c(StackXMLSpecUser,
                   list(content=list("attribute", "/row/@AboutMe"))), 
          doc = PlainTextDocument())

