context("permission checking")

test_that("permission is granted", {
  options("cabinet.testing" = TRUE)
  options("cabinet.testingPerm" = TRUE)

  expect_message(ask_permission(), "Permission granted.")
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
    expect_message(check_permissions(), "Checking for permissions...")

    options("cabinets.permission" = NULL)
    options("cabinet.testing" = TRUE)
    options("cabinet.testingPerm" = FALSE)
    expect_error(check_permissions())
})
