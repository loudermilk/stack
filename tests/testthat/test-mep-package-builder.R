# test-mep-package-builder.R

#' @title Manually test updateDesc()
#' 
#' @description This is a manual test procedure to ensure
#' that updateDesc() functions as designed - because of context
#' dependencies we were not able to design this as an actual
#' testthat::test_that code block.
testUpdateDesc <- function() {
  
  orig_old_desc <- NULL
  
  if (!file.exists(file = system.file(DESCRIPTION_OLD_FILE, package = "mepapi"))) {
    stop(paste("DESCRIPTION.OLD file does not exist :", 
               system.file(DESCRIPTION_OLD_FILE, package = "mepapi")))
  }
  
  if (!file.exists(file = system.file(DESCRIPTION_FILE, package = "mepapi"))) {
    stop(paste("DESCRIPTION file does not exist :",
               system.file(DESCRIPTION_FILE, package = "mepapi")))
  }
  
  # Read in the current DESCRIPTION & DESCRIPTION.OLD
  orig_cur_desc <- read.dcf(file = system.file(DESCRIPTION_FILE, package = "mepapi"))
  orig_old_desc <- read.dcf(file = system.file(DESCRIPTION_OLD_FILE, package = "mepapi"))
  
  # What is the current package version?
  cur_version <- package_version(orig_cur_desc[, VERSION_FIELD])
  
  # Create the next logical package version
  next_major <- cur_version$major
  next_minor <- cur_version$minor
  next_patch <- as.integer(cur_version$patch + 1)
  next_str <- paste(next_major, next_minor, next_patch, sep = ".")
  next_version <- package_version(next_str)
  
  # DESCRIPTION should be updated w new version after following call
  # DESCRIPTION.OLD should be updated with version cur_version
  updateDesc(pv = next_version)
  
  # Updated DESCRIPTION file exists
  assertthat::assert_that(file.exists(file = system.file(DESCRIPTION_FILE, package = "mepapi")))
  
  # Old DESCRIPTION file exists
  assertthat::assert_that(file.exists(file = system.file(DESCRIPTION_OLD_FILE, package = "mepapi")))
  
  # Read in the newly updated DESCRIPTION file
  new_cur_desc <- read.dcf(file = system.file(DESCRIPTION_FILE, package = "mepapi"))
  new_version <- package_version(new_cur_desc[, VERSION_FIELD])
  
  # Next version is bigger than current version
  assertthat::assert_that(cur_version < new_version)
  
  # Roll everything back to the way it was before we called this unit test
  write.dcf(x = orig_cur_desc, file = system.file(DESCRIPTION_FILE, package = "mepapi"))
  if (!is.null(orig_old_desc)) {
    write.dcf(x = orig_old_desc, file = system.file(DESCRIPTION_OLD_FILE, package = "mepapi"))
  }
}