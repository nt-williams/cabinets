context("Blocks")

test_that("deleting blocks", {
    withr::with_tempfile("block", {
        con <- file(block, open = "a")
        writeLines("blank space", con = con)
        writeLines(glue::glue("## test cabinet start"), con = con)
        writeLines("Text to delete", con = con)
        writeLines(glue::glue("## test cabinet end"), con = con)
        writeLines("blank space", con = con)
        close(con)

        expect_equal(read_utf8(block),
                     c("blank space", "## test cabinet start",
                       "Text to delete", "## test cabinet end",
                       "blank space"))
        block_delete("## test cabinet start", "## test cabinet end", block)
        expect_equal(read_utf8(block), c("blank space", "blank space"))
    }, fileext = "txt")
})

