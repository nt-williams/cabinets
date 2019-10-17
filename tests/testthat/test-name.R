context("check name")

test_that("name already exists", {
    withr::with_environment(.GlobalEnv, {
        .test_cab <<- NULL
        expect_error(check_name("test_cab"))
        rm(.test_cab, envir = .GlobalEnv)
    })
})

test_that("name doesn't exist", {
    withr::with_environment(.GlobalEnv, {
        expect_message(check_name("test_cab"), "Checking cabinet name...")
    })
})
