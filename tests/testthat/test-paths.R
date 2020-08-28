
context("Path specific")

test_that("Parse paths correctly", {
    expect_equal(get_paths("hello/world/test"), c("hello/world/test", "hello/world", "hello"))
})
