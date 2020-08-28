context("pre-existing projects")

test_that("project directory already exists", {
    temp_dir <- tempdir()
    expect_error(check_project(temp_dir))
    unlink(temp_dir)
})

skip_if(!cli::is_utf8_output())

test_that("project doesn't exist", {
    cli::cli_div(theme = list(".alert-success" = list(before = "PASSING ")))
    verify_output(test_path("test-project-doesnt-exist.txt"), {
        check_project(file.path("a", "random", "path"))
    })
})
