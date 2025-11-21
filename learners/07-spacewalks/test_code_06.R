source("crew_size.R")

library(testthat)
test_that(
  "duration calcalulation works off the hour",
  expect_equal(text_to_duration("10:20"), 10.333333333)
)
test_that(
  "duration calcalulation works on the hour",
  expect_identical(text_to_duration("10:00"), 10)
)

test_that("calculate_crew_size returns expected values for typical crew values", {
  actual_result <- calculate_crew_size("Valentina Tereshkova;")
  expected_result <- 1L
  expect_identical(actual_result, expected_result)

  actual_result <- calculate_crew_size("Judith Resnik; Sally Ride;")
  expected_result <- 2L
  expect_identical(actual_result, expected_result)
})

# Edge cases
test_that("calculate_crew_size returns expected values for edge case where crew is an empty string", {
  actual_result <- calculate_crew_size("")
  expect_null(actual_result)
})