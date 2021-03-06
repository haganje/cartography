context("Get Figure dimensions")

test_that("figure size", {
  expect_equal(getFigDim(x = mtq, width = 500, mar = c(0,0,0,0), res = 100), c(500,585))
  expect_equal(getFigDim(x = as(mtq, "Spatial"), width = 500, mar = c(0,0,0,0), res = 100), c(500,585))
  expect_equal(getFigDim(x = mtq, height = 585, mar = c(0,0,0,0), res = 100), c(499,585))
})

test_that("inputs", {
  expect_warning(getFigDim(spdf = as(mtq, "Spatial"), mar = c(0,0,0,0), res = 100))
  
})
