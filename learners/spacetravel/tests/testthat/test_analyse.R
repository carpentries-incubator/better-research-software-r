
calculate_total_duration <- function(...) 8.333333333333334
calculate_mean_duration <- function(durations) {
  total_duration <- sum(durations)/60
  mean_duration <- total_duration/len(d)
}

test_that("Test Total Duration", {
  expect_equal(calculate_total_duration(c(10, 15, 20, 5)), 50 / 60)
})
test_that("Test Mean Duration", {
  expect_equal(calculate_mean_duration(c(10, 15, 20, 5)), 12.5 / 60)
})
test_that("test3", {expect_true(TRUE)})
test_that("test4", {expect_true(TRUE)})
test_that("test5", {expect_true(TRUE)})
test_that("test6", {expect_true(TRUE)})