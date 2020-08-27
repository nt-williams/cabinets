context("pre-existing projects")

test_that("project directory already exists", {
    temp_dir <- tempdir()
    expect_error(check_project(temp_dir))
    unlink(temp_dir)
})

test_that("project doesn't exist", {
    verify_output(test_path("test-project-doesnt-exist.txt"), {
        capt(check_project(file.path("a", "random", "path")))
    },
    crayon = TRUE)
})
