context("Other feedback")

env <- new.env()

test_that("correct feedback", {
    cli::cli_div(theme = list(".alert-success" = list(before = "PASSING ")))
    cli::cli_div(theme = list(ul = list("list-style-type" = "*")))
    cli::cli_div(theme = list(".alert-danger" = list(before = "PASSING ")))
    cli::cli_div(theme = list(".alert-warning" = list(before = "PASSING ")))
    verify_output(test_path("test-feedback.txt"), {
        creating_project("hello", "world")
        opening_project("test")
        checking_existence()
        checking_git()
        no_cabinets()
        no_r_profile()
        initiated_git("test")
        created_cabinet("test")
        no_git()
        initiating_renv()
    })
})

test_that("finding cabinets", {
    withr::with_environment(env, {
        cli::cli_div(theme = list(ul = list("list-style-type" = "*")))
        rm(list = ls(), envir = env)
        assign("x", FileCabinet$new(name = "test_cab",
                                    directory = "a/random/path",
                                    structure = list('test' = NULL)),
               envir = env)
        verify_output(test_path("test-print-available.txt"), {
            get_cabinets(env)
        })
    })
})
