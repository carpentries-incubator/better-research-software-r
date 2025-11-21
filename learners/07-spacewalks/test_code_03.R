source("eva_data_analysis.R")

stopifnot(abs(text_to_duration("10:20") - 10.333333) < 1e-7)
stopifnot(text_to_duration("10:00") == 10)