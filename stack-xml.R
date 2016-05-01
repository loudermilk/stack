# <posts>
#   <row Id="5" PostTypeId="1" CreationDate="2014-05-13T23:58:30.457" Score="7" ViewCount="286" Body="<p>I've always been interested in machine learning, but I can't figure out one thing about starting out with a simple "Hello World" example - how can I avoid hard-coding behavior?</p> <p>For example, if I wanted to "teach" a bot how to avoid randomly placed obstacles, I couldn't just use relative motion, because the obstacles move around, but I don't want to hard code, say, distance, because that ruins the whole point of machine learning.</p> <p>Obviously, randomly generating code would be impractical, so how could I do this?</p> " OwnerUserId="5" LastActivityDate="2014-05-14T00:36:31.077" Title="How can I do simple machine learning without hard-coding behavior?" Tags="<machine-learning>" AnswerCount="1" CommentCount="1" FavoriteCount="1" ClosedDate="2014-05-14T14:40:25.950"/>
#   <row Id="7" PostTypeId="1" AcceptedAnswerId="10" CreationDate="2014-05-14T00:11:06.457" Score="2" ViewCount="266" Body="<p>As a researcher and instructor, I'm looking for open-source books (or similar materials) that provide a relatively thorough overview of data science from an applied perspective. To be clear, I'm especially interested in a thorough overview that provides material suitable for a college-level course, not particular pieces or papers.</p> " OwnerUserId="36" LastEditorUserId="97" LastEditDate="2014-05-16T13:45:00.237" LastActivityDate="2014-05-16T13:45:00.237" Title="What open-source books (or other materials) provide a relatively thorough overview of data science?" Tags="<education><open-source>" AnswerCount="3" CommentCount="4" FavoriteCount="1" ClosedDate="2014-05-14T08:40:54.950"/>
# </posts>

# <REUTERS TOPICS="YES" LEWISSPLIT="TRAIN" CGISPLIT="TRAINING-SET" OLDID="5670" NEWID="127">
#   <DATE>26-FEB-1987 17:00:56.04</DATE>
#   <TOPICS>
#     <D>crude</D>
#   </TOPICS>
#   <PLACES>
#     <D>usa</D>
#   </PLACES>
#   <PEOPLE/>
#   <ORGS/>
#   <EXCHANGES/>
#   <COMPANIES/>
#   <UNKNOWN>
#   Y f0119 reute u f BC-DIAMOND-SHAMROCK-(DIA 02-26 0097
#   </UNKNOWN>
#   <TEXT>
#     <TITLE>DIAMOND SHAMROCK (DIA) CUTS CRUDE PRICES</TITLE>
#     <DATELINE>NEW YORK, FEB 26 -</DATELINE>
#     <BODY>
#     Diamond Shamrock Corp said that effective today it had cut its contract prices for crude oil by 1.50 dlrs a barrel. The reduction brings its posted price for West Texas Intermediate to 16.00 dlrs a barrel, the copany said. "The price reduction today was made in the light of falling oil product prices and a weak crude oil market," a company spokeswoman said. Diamond is the latest in a line of U.S. oil companies that have cut its contract, or posted, prices over the last two days citing weak oil markets. Reuter
#     </BODY>
#   </TEXT>
# </REUTERS>
# 

StackXMLSpecTag <-
  list(id = list("attribute", "/tags/row/@Id"),
       excerpt = list("attribute", "/tags/row/@ExcerptPostId"),
       wikipostid = list("attribute","/tags/row/@WikiPostId"),
       counts = list("attribute", "/tags/row/@Count"),
       tags = list("attribute", "/tags/row/@TagName"))


# readStackXML <-
#   readXML(spec = c(StackXMLSpec,
#                    list(content = list("node", "/REUTERS/TEXT/BODY"))), #/DATA
#           doc = PlainTextDocument())

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




#node <- "/REUTERS/TEXT/BODY"
#node <- "/REUTERS/TEXT/TITLE"
#attr <- "/REUTERS/@TOPICS"
#attr <- "/posts/row/@Body"
#attr <- "/REUTERS/@CGISPLIT"
#attr <- "/tags/row/@TagName"

#NODE <- "node"
#ATTRIBUTE <- "attribute"

#TYPE <- SE$type
#KEY <- SE$key

readStackXMLTags <-
  readXML(spec = c(StackXMLSpecTag,
                   list(content = list(StackXMLSpecTag$tags[[1]], StackXMLSpecTag$tags[[2]]))), #/DATA
          doc = PlainTextDocument())



