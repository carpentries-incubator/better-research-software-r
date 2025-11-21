source("eva_data_analysis.R")

input_value = "10:00"
test_result = text_to_duration("10:00") == 10
print(paste("text_to_duration('10:00') == 10?", test_result))