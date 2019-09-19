test_that("working directory isn't flagged", {
    loc <- path.expand("~")
    setwd(loc)
    expect_output(check_directory(), "OK")

    loc <- tempdir()
    setwd(loc)

    automated_menu <- function(choices,
                               graphics = FALSE,
                               title = NULL) {
        return(3)
    }

    function_env <- environment(menu)
    original <- get("menu", envir = function_env)
    unlockBinding("menu", function_env)
    assign("menu", automated_menu, envir = function_env)

    expect_error(check_directory())

    assign("menu", original, envir = function_env)
})

test_that("names are flagged or not flagged", {
    cab <- FileCabinet$new(name = "test",
                           directory = tempdir(),
                           structure = list('test' = NULL))

    .test <<- NULL

    expect_error(check_name(cab$name))
    rm(.test, envir = .GlobalEnv)

    expect_output(check_name(cab$name), "OK")
})

test_that("projects are flagged or not flagged", {

    dir <- tempdir()
    expect_error(check_project(dir))
    expect_output(check_project("thisisatest/path"), "OK")
})

test_that(".Rprofile exists or creating", {
    loc <- tempdir()
    setwd(loc)

    expect_output(check_r_profile())
    expect_output(check_r_profile(), "OK")
})

test_that("check_cabinet finds cabinets", {
    test_cab <<- FileCabinet$new(name = "test_cab",
                           directory = tempdir(),
                           structure = list('test' = NULL))

    expect_output(check_cabinet("test_cab"), "OK")
    rm(test_cab, envir = .GlobalEnv)
    expect_error(check_cabinet("test_cab"))
})
