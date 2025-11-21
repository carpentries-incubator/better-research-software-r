source("eva_data_analysis.R")

stopifnot(text_to_duration("10:15") == 10.25)
stopifnot(text_to_duration("10:00") == 10)