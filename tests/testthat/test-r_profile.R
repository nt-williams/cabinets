context("check_r_profile")

test_that("doing nothing if .Rprofile already exists", {
  withr::with_dir(tempdir(), {
      file.create(file.path(tempdir(), ".Rprofile"))
      expect_message(check_r_profile(), "Checking for .Rprofile...")
      unlink(file.path(tempdir(), ".Rprofile"))
  })
})
