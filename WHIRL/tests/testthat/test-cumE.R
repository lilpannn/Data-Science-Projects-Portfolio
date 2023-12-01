test_that("Calculate accumulated cyclone energy of a given storm", {
    df = data.frame(ID=c("AL021957","AL021957","AL021957"),
                    Maximum.Wind=c(3,2,1))
    expect_equal(cumE(df,"AL021957"), 0.0014)
})
#> Test passed 🎊

test_that("Basic with NA", {
    df = data.frame(ID=c("AL021957","AL021957","AL021957"),
                    Maximum.Wind=c(3,NA,1))
    expect_equal(cumE(df,"AL021957"), 0.0010)
})
#> Test passed 🎊

