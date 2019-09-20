context("checking directory")

test_that("directory is ok", {
    withr::with_dir(path.expand("~"), {
        expect_output(check_directory(), "OK")
    })
})

test_that("directory should be changed", {
    withr::with_dir(tempdir(), {
        withr::with_options(list("cabinet.testing" = TRUE), {
            expect_output(check_directory())
        })
    })
})
