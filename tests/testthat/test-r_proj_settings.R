test_that("create_r_proj outputs", {
    expect_identical(capture_output(create_r_proj(), print = TRUE), "Version: 1.0\nRestoreWorkspace: No\nSaveWorkspace: No\nAlwaysSaveHistory: Default\nEnableCodeIndexing: Yes\nUseSpacesForTab: Yes\nNumSpacesForTab: 2\nEncoding: UTF-8\nRnwWeave: Sweave\nLaTeX: pdfLaTeX\nAutoAppendNewline: Yes\nStripTrailingWhitespace: Yes")
})
