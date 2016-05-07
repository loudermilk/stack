df <- data.frame(x = 1:20, y = c(rep("a",10), rep("b",10)))
fit <- glm(y~x, data = df, family = "binomial")
predict(fit, df$x)


summary(fit)


library(tm)

custom.xml <- system.file("texts", "custom.xml", package = "tm")
print(readLines(custom.xml), quote = FALSE)

mySource <- function(x){
  XMLSource(x, function(tree) XML::xmlChildren(XML::xmlRoot(tree)), myXMLReader)
} 


myXMLReader <- readXML(spec = list(author = list("node", "/document/writer"),
                                   content = list("node", "/document/description"),
                                   datetimestamp = list("function", 
                                                        function(x) as.POSIXlt(Sys.time(), 
                                                                               tz = "GMT")),
                                   description = list("attribute", "/document/@short"),
                                   heading = list("node", "/document/caption"),
                                   id = list("function", function(x) tempfile()),
                                   origin = list("unevaluated", "My private bibliography"),
                                   type = list("node", "/document/type")),
                       doc = PlainTextDocument())

corpus <- VCorpus(mySource(custom.xml))

