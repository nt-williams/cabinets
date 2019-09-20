context("check_r_profile")

test_that("doing nothing if .Rprofile already exists", {
  og <- getwd()
  setwd(tempdir())
  withr::with_file(
      file.create(file.path(tempdir(), ".Rprofile")), {
          expect_output(check_r_profile(), "OK")
          setwd(og)
      }
  )
})
