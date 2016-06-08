## PR-4
## DEBUG SCRIPT
##
## SQL tables don't appear to have all the meta data provided by *.xml.
## For example in Posts we should see a ParentId field which we don't.
## Moreover field is not in the data.frame used to create the table,
## nor is it in the meta data of the corpora.

type <- 'Posts'
corpus <- newSECorpus(type)
length(corpus)
data <- corpusToDF(corpus, add_content = TRUE)
dim(data)
names(data)

ln_vec <- c()
for (i in 1:length(corpus)) {
  ln <- length(meta(corpus[[i]]))
  ln_vec <- c(ln_vec, ln)
}

max(ln_vec)
min(ln_vec)
#all recs are same length and none have ParentId, so must be in xml reader
