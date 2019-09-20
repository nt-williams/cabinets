context("check_r_profile")

test_that("doing nothing if .Rprofile already exists", {
  withr::with_dir(tempdir(), {
      file.create(file.path(tempdir(), ".Rprofile"))
      expect_output(check_r_profile(), "OK")
      unlink(file.path(tempdir(), ".Rprofile"))
  })
})

test_that("writing .Rprofile", {
  withr::with_dir(tempdir(), {
      expect_output(check_r_profile())
      unlink(file.path(tempdir(), ".Rprofile"))
    })
  })
