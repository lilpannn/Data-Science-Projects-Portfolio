test_that("Basic test for landfall false", {
    df = data.frame(ID=c("AL042017","AL042017","AL042017"),
                  Latitude=c(11.8,12.0,12.4),
                  Longitude=c(-35.9,-37.1,-38.6))
    expect_equal(landfall(df,"AL042017"), FALSE)
})
#> Test passed 🎊

test_that("Basic test for landfall true", {
    df = data.frame(ID=rep("AL012018",26),
                  Latitude=c(18.8,18.7,18.9,19.6,21.3,22.6,
                             23.6,24.9,26.6,27.6,28.2,28.6,29.1,
                             29.8,30.3,30.9,31.9,33,34.2,35.4,36.7,
                             38.2,39.9,41.5,43.5,46),
                  Longitude=c(-87.1,-86.5,-85.9,-85.7,-85.6,-85.3,
                              -84.8,-84.3,-84.4,-85,-85.8,-86,-85.9,
                              -85.9,-86,-86.1,-86.6,-87,-87.3,-87.6,
                              -87.9,-87.7,-87,-86,-84.6,-83.3))
    expect_equal(landfall(df,"AL012018"),
               data.frame(intersects=c(rep(0,14),rep(1,5),rep(0,5),1,0)))
})
#> Test passed 🎊

test_that("Basic test for landfall with NA", {
    df = data.frame(ID=rep("AL012018",27),
                  Latitude=c(18.8,18.7,18.9,19.6,21.3,22.6,
                             23.6,24.9,26.6,27.6,28.2,28.6,29.1,
                             29.8,30.3,30.9,31.9,33,34.2,35.4,36.7,
                             38.2,39.9,41.5,43.5,46,NA),
                  Longitude=c(-87.1,-86.5,-85.9,-85.7,-85.6,-85.3,
                              -84.8,-84.3,-84.4,-85,-85.8,-86,-85.9,
                              -85.9,-86,-86.1,-86.6,-87,-87.3,-87.6,
                              -87.9,-87.7,-87,-86,-84.6,-83.3,NA))
    expect_equal(landfall(df,"AL012018"),
               data.frame(intersects=c(rep(0,14),rep(1,5),rep(0,5),1,0)))
})
#> Test passed 🎊
