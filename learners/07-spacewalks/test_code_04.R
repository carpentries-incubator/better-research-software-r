source("eva_data_analysis.R")

library(testthat)
test_that(
  "duration calcalulation works off the hour",
  expect_true(abs(text_to_duration("10:20") - 10.333333) < 1e-5)
)
test_that(
  "duration calcalulation works on the hour",
  expect_true(text_to_duration("10:00") == 10)
)