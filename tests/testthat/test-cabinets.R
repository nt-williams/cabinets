test_that("printing available cabinets", {

    test_cab <<- FileCabinet$new(name = "test_cab",
                                 directory = tempdir(),
                                 structure = list('test' = NULL))

    expect_output(get_cabinets(), "test_cab")
    rm(test_cab, envir = .GlobalEnv)
})

test_that("create_r_proj outputs", {
    expect_identical(capture_output(create_r_proj(), print = TRUE), "Version: 1.0\nRestoreWorkspace: No\nSaveWorkspace: No\nAlwaysSaveHistory: Default\nEnableCodeIndexing: Yes\nUseSpacesForTab: Yes\nNumSpacesForTab: 2\nEncoding: UTF-8\nRnwWeave: Sweave\nLaTeX: pdfLaTeX\nAutoAppendNewline: Yes\nStripTrailingWhitespace: Yes")
})
