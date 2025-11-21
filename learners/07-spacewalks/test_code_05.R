source("eva_data_analysis.R")

library(testthat)
test_that(
  "duration calcalulation works off the hour",
  expect_equal(text_to_duration("10:20"), 10.3333333)
)
test_that(
  "duration calcalulation works on the hour",
  expect_identical(text_to_duration("10:00"), 10)
)