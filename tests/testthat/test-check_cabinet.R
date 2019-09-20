context("check_cabinet function")

test_that("finding existing cabinets", {
    withr::with_environment(.GlobalEnv, {
        .test_cab <<- NULL
        expect_output(check_cabinet(".test_cab"), "OK")
        rm(.test_cab, envir = .GlobalEnv)
    })
})

test_that("cabinet doesn't exist", {
    withr::with_environment(.GlobalEnv, {
        expect_error(check_cabinet(".test_cab"))
    })
})
