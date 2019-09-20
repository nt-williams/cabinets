context("setting cabinet options")

test_that("options can be set", {
    cabinets_options_set("cabinets.permission" = FALSE)

    expect_false(getOption("cabinets.permission"))
})
