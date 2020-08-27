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
        verify_output(test_path("test-name-doesnt-exist.txt"), {
            capt(check_name("test_cab"))
        })
    })
})
