context("check_cabinet function")

test_that("finding existing cabinets", {
    withr::with_environment(.GlobalEnv, {
        .test_cab <<- NULL
        cli::cli_div(theme = list(".alert-success" = list(before = "PASSING ")))
        verify_output(test_path("test-find-existing-cabinets.txt"), {
            check_cabinet(".test_cab")
        })
        rm(.test_cab, envir = .GlobalEnv)
    })
})
