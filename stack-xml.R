
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
       #Text = list("attribute", "/row/@Text"),
       CreationDate = list("attribute", "/row/@CreationDate"),
       UserId = list("attribute", "/row/@UserId"))


readStackXMLComments <-
  readXML(spec = c(StackXMLSpecComment,
                   list(content=list("attribute", "/row/@Text"))), 
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
       #Body = list("attribute", "/row/@Body"),
       OwnerUserId = list("attribute", "/row/@OwnerUserId"),
       LastActivityDate = list("attribute", "/row/@LastActivityDate"),
       Title = list("attribute", "/row/@Title"),
       Tags = list("attribute", "/row/@Tags"),
       AnswerCount = list("attribute", "/row/@AnswerCount"),
       CommentCount = list("attribute", "/row/@CommentCount"),
       FavoriteCount = list("attribute", "/row/@FavoriteCount"),
       ClosedDate = list("attribute", "/row/@ClosedDate"))


readStackXMLPosts <-
  readXML(spec = c(StackXMLSpecPost,
                   list(content=list("attribute", "/row/@Body"))), 
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

##################################################################################
## VOTES
##################################################################################

StackXMLSpecVote <-
  list(Id = list("attribute", "/row/@Id"),
       PostId = list("attribute", "/row/@PostId"),
       VoteTypeId = list("attribute","/row/@VoteTypeId"),
       CreationDate = list("attribute", "/row/@CreationDate"))


readStackXMLVotes <-
  readXML(spec = c(StackXMLSpecVote), 
          doc = PlainTextDocument())


##################################################################################
## POSTLINKS
##################################################################################

StackXMLSpecPostLink <-
  list(Id = list("attribute", "/row/@Id"),
       CreationDate = list("attribute", "/row/@CreationDate"),
       PostId = list("attribute","/row/@PostId"),
       RelatedPostId = list("attribute", "/row/@RelatedPostId"),
       LinkTypeId = list("attribute", "/row/@LinkTypeId"))


readStackXMLPostLinks <-
  readXML(spec = c(StackXMLSpecPostLink), 
          doc = PlainTextDocument())


##################################################################################
## POSTHISTORY
##################################################################################

StackXMLSpecPostHistory <-
  list(Id = list("attribute", "/row/@Id"),
       PostHistoryTypeId = list("attribute", "/row/@PostHistoryTypeId"),
       PostId = list("attribute","/row/@PostId"),
       RevisionGUID = list("attribute", "/row/@RevisionGUID"),
       CreationDate = list("attribute", "/row/@CreationDate"),
       UserId = list("attribute", "/row/@UserId"))
       #Text = list("attribute", "/row/@Text"),

readStackXMLPostHistorys <-
  readXML(spec = c(StackXMLSpecPostHistory,
                   list(content=list("attribute", "/row/@Text"))), 
          doc = PlainTextDocument())

##################################################################################
## BADGES
##################################################################################

StackXMLSpecBadge <-
  list(Id = list("attribute", "/row/@Id"),
       UserId = list("attribute", "/row/@UserId"),
       Name = list("attribute","/row/@Name"),
       Date = list("attribute", "/row/@Date"),
       Class = list("attribute", "/row/@Class"),
       TagBased = list("attribute", "/row/@TagBased"))


readStackXMLBadges <-
  readXML(spec = c(StackXMLSpecBadge), 
          doc = PlainTextDocument())
