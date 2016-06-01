##################################################################
## CorpusManager.R
##
## Easy mechanaism for create corpus given search directory and
## regex expression.
##
## Example:
##
## dir <- "docs"
## pattern <- "*.txt"
## cm <- CorpusManager(dir, pattern)
## ff <- listFiles(cm)
## my_corpus <- createCorpusByFiles(cm, ff)
## print(my_corpus)
##



#' @title Create FileLoader object (S3)
#' 
#' @description FileLoader stores a list of full pathnames
#' to the all the files stored in dir and its subdirectories that
#' match the pattern argument. File loader also stores a list of
#' tags, currently defaulting to the set of unique directies under dir.
#' 
#' @example
#' fl <- FileLoader("OANC-GrAF", pattern = "*.txt")
#' fl$files
#' fl$tags
#' 
#' @param dir character name of starting directory
#' @param pattern character regex
#' 
#' @return FileLoader
FileLoader <- function(dir, pattern) {
  file_list <- list.files(dir, pattern = pattern, recursive = TRUE, full.names=TRUE)
  
  
  #files <- sapply(file_list, FUN = basename)
  directories <- sapply(file_list, FUN = dirname)
  
  tags <- unique(unlist(sapply(directories, FUN = strsplit, "/")))
  
  
  file_loader <- list()
  class(file_loader) <- "FileLoader"
  file_loader$files <- file_list
  file_loader$tags <- tags
  return(file_loader)
}


#' @title Create CorpusManager object
#' @return CorpusManager
CorpusManager <- function(dir = ".", pattern = "*.txt") {
  cm <- list()
  class(cm) <- "CorpusManager"
  cm$file_loader <- FileLoader(dir, pattern)
  
  return(cm)
}

listFiles <- function(cm, ...) {
  UseMethod("listFiles",cm)
}


#' @title List files
#' @param cm CorpusManager
#' @return character vector of file names
listFiles.CorpusManager <- function(cm, ...) {
  return(cm$file_loader$files)
}

listTags <- function(cm, ...) {
  UseMethod("listTags", cm)
}

#' @title List tags
#' @param cm CorpusManager
#' @return character vector of tag names
listTags.CorpusManager <- function(cm, ...) {
  return(cm$file_loader$tags)
}


createCorpusByFiles <- function(cm, files, ...) {
  UseMethod("createCorpusByFiles", cm)
}

#' @title Create VCorpus with files
#' 
#' @param cm CorpusManager
#' @param character vector of files
#' 
#' @return VCorpus
createCorpusByFiles.CorpusManager <- function(cm, files,...) {
  corpus_list <- lapply(files, FUN = function(f){
    lines <- readLines(f)
    lines <- lines[lines != ""]
    lines <- concat(lines, collapse = " ")
    lines
  })
  VCorpus(VectorSource(corpus_list))
}


#removePunct <- function(x){gsub("[[:punct:]]", "", x)}



##
## Just some code that runs when the script is sourced.
## Primarily used as a drawing board duing development.
## Just uncomment and run.

# 
# dir <- "OANC-GrAF"
# pattern <- "*.txt"
# max_records <- 10
# 
# 
# cm <- CorpusManager(dir, pattern)
# ff <- listFiles(cm)
# target_files <- {
#   if (length(ff) < max_records){
#     ff
#   } else {
#     ff[1:max_records]
#   }
# }
# 
# 
# 
# preprocessText <- function (cp) {
#   cp <- tm_map(cp, stripWhitespace)
#   cp <- tm_map(cp, content_transformer(tolower))
#   cp <- tm_map(cp, removeWords, stopwords("english"))
#   #cp <- tm_map(cp, removePunct)
#   cp <- tm_map(cp, removePunctuation, preserve_intra_word_dashes = TRUE)
#   cp <- tm_map(cp, stripWhitespace)
#   return(cp)
# }
# 
# 
# 
# cp <- createCorpusByFiles(cm, target_files)
# cp <- preprocessText(cp)
# 
# 
# writeLines(as.character(cp[[1]]))
# 
# tdm <- TermDocumentMatrix(cp)
# inspect(tdm[100:110,1:5])
# 
# findFreqTerms(tdm, 50)
# 
# findAssocs(tdm, "can", 0.95)
# 
# 
# 
# 
