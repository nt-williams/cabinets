context("permission checking")

test_that("permission is granted", {
  options("cabinet.testing" = TRUE)
  options("cabinet.testingPerm" = TRUE)

  verify_output(test_path("test-permission-granted.txt"), {
    capt(ask_permission())
  })
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

    verify_output(test_path("test-checking-permissions.txt"), {
      capt(check_permissions())
    })

    options("cabinets.permission" = NULL)
    options("cabinet.testing" = TRUE)
    options("cabinet.testingPerm" = FALSE)
    expect_error(check_permissions())
})
