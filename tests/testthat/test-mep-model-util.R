# runit-mep-model-util.R


test_that("createGoldStandard", {
  df <- data.frame(a = 1:10, 
                   b = letters[1:10], 
                   class = rep(c("foo", "bar"), 5))
  mp <- DEFAULT_JOIN_MP
  mp$minor <- 1
  remain_df <- createGoldStandard(df = df, mp = mp)
  
  # remain_df should be df, b/c GS constraints not met
  assertthat::assert_that(nrow(remain_df) == nrow(df))
  
  # We don't actually want to test converse b/c of MEP context 
  # sensitivities during unit testing
  
})


test_that("addNamedResultToList", {
  foo_list <- list()
  for (i in 1:10) {
    foo_list <- addNamedResultToList(res = i, name = paste0("X_",i), foo_list)
  }
  
  assertthat::assert_that(length(foo_list) == 10)
  names <- names(foo_list)
  assertthat::assert_that("X_1" %in% names)
  assertthat::assert_that(foo_list$X_1 == 1)
  
})



test_that("remapClassCol", {
  df <- {
    id <- c(1:10)
    ltrs <- letters[1:10]
    class <- rep(c(1, 0), 5)
    data.frame(id = id, ltrs = ltrs, class = class)
  } 

  new_df <- remapClassCol(df, "class", 1, "Member", 0, "Prospect")
  assertthat::assert_that(new_df$class[new_df$id ==1] == "Member")
  assertthat::assert_that(new_df$class[new_df$id ==2] == "Prospect")
  
  old_df <- remapClassCol(new_df, "class", 1, "Member", 0, "Prospect", int2label = FALSE)
  assertthat::assert_that(sum(df$class == old_df$class) == 10)
  assertthat::assert_that(is.numeric(old_df$class))
  
})


test_that("getClassifierCode", {
  df <- {
    id <- c(1:10)
    ltrs <- letters[1:10]
    class <- rep(c(1, 0), 5)
    data.frame(id = id, ltrs = ltrs, class = factor(class))
  } 
  
  
  fit <- trainNB(df = df)
  code <- getClassifierCode(fit = fit)
  assertthat::assert_that(code == "nb")
  
  fit <- trainRF(df = df)
  code <- getClassifierCode(fit = fit)
  assertthat::assert_that(code == "rf")
  
  fit <- trainLogReg(df = df)
  code <- getClassifierCode(fit = fit)
  assertthat::assert_that(code == "lr")
  
  
})

test_that("modelCode", {
  assertthat::assert_that(getCode(JOIN) == "JOIN")
  assertthat::assert_that(getCode(RENEWAL) != getCode(COMPOSITE))
})

test_that("edaViz", {
  CLASS_COLUMN <- "class"
  TARGET_CLASS <- "Member"
  NONTARGET_CLASS <- "Prospect"
  TARGET_INT <- 1
  NONTARGET_INT <- 0
  
  
  MODEL <- getCode(JOIN)
  TYPE <- "generic"
  MAJOR <- 9
  MINOR <- 9
  plot_dir <- REMOTE_DIR <- "temp_plots/"
  
  mp <- createModelParams(model = MODEL, type = TYPE, major = MAJOR, minor = MINOR, 
                          remote_dir = REMOTE_DIR, class_column = CLASS_COLUMN, 
                          target_class = TARGET_CLASS, target_int = TARGET_INT, 
                          nontarget_class = NONTARGET_CLASS, nontarget_int = NONTARGET_INT)
  
  df <- data.frame(var1 = rnorm(100), 
                   var2 = c(rep('foo', 40), rep('bar', 50), rep('foo', 10)), 
                   class = c(rep(1,50), rep(0,50)))

  edaViz(df = df, plot_dir = plot_dir, mp = mp)
  plot_dir <- substr(plot_dir, start=1, stop=stringr::str_length(plot_dir)-1)
  unlink(plot_dir, recursive = TRUE, force = TRUE)
  })

