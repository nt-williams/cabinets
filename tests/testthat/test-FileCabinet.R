context("create FileCabinet")

test_that("creating FileCabinet", {
    x <- FileCabinet$new(name = "test_cab",
                         directory = "a/random/path",
                         structure = list('test' = NULL))

    expect_output(x$print())
})
