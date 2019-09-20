context("permission checking")

test_that("permission is granted", {
  options("cabinet.testing" = TRUE)
  options("cabinet.testingPerm" = TRUE)

  expect_output(ask_permission())
})

test_that("permission is denied", {
    options("cabinet.testing" = TRUE)
    options("cabinet.testingPerm" = FALSE)

    expect_error(ask_permission())
})

test_that("check permission catches permission", {
    options("cabinets.permission" = FALSE)
    expect_error(check_permissions())

    options("cabinets.permission" = TRUE)
    expect_output(check_permissions(), "OK")

    options("cabinets.permission" = NULL)
    options("cabinet.testing" = TRUE)
    options("cabinet.testingPerm" = FALSE)
    expect_error(check_permissions())
})
