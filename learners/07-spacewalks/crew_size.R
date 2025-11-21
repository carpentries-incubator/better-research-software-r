
# https://data.nasa.gov/resource/eva.json (with modifications)
library(jsonlite)
library(dplyr) # used for bind_rows

main <- function(input_file, output_file, graph_file) {
  print("--START--")

  # Read the data from JSON file
  eva_data <- read_json_to_dataframe(input_file)

  # Convert and export data to CSV file
  write_dataframe_to_csv(eva_data, output_file)

  # Sort dataframe by date ready to be plotted (date values are on x-axis)
  eva_data <- eva_data[order(eva_data$date), ]

  # Plot cumulative time spent in space over years
  plot_cumulative_time_in_space(eva_data, graph_file)

  print("--END--")
}

# start ...  >

#' Read the data from a JSON file into a dataframe
#'
#' Clean the data by removing any incomplete rows and sort by date
#' @param input_file (character) The path to the JSON file.
#' @return data.frame: The cleaned and sorted data as a dataframe structure
read_json_to_dataframe <- function(input_file) {
  print(paste("Reading JSON file", input_file))
  # Read the data from a JSON file into a dataframe
  eva_list <- jsonlite::read_json(input_file)
  eva_df <- bind_rows(eva_list)
  eva_df$eva <- as.numeric(eva_df$eva)
  eva_df$date <- as.POSIXct(eva_df$date)

  # Clean the data by removing any incomplete rows
  eva_df <- eva_df[rowSums(is.na(eva_df)) == 0, ]
  eva_df
}

#' Write the dataframe to a CSV file
#' 
#' @param df (data.frame) The input dataframe.
#' @param output_file (character) The path to the output CSV file.
#' @return NULL
write_dataframe_to_csv <- function(df, output_file) {
  print(paste("Saving to CSV file", output_file))
  # Save dataframe to CSV file for later analysis
  write.csv(
    format.data.frame(df, nsmall=1),
    output_file, row.names = FALSE, quote = ncol(df)
  )
}

#' Plot the cumulative time spent in space over years
#'
#' Convert the duration column from strings to number of hours
#' Calculate cumulative sum of durations
#' Generate a plot of cumulative time spent in space over years and
#' save it to the specified location

#' @param df (pd.DataFrame): The input dataframe.
#' @param graph_file (str): The path to the output graph file.
#' @return NULL
plot_cumulative_time_in_space <- function(df, graph_file) {
  print(paste("Plotting cumulative spacewalk duration and saving to", graph_file))
  df <- add_duration_hours_variable(df)
  df[["cumulative_time"]] <- cumsum(df[["duration_hours"]])
  plot(
    df$date,
    df$cumulative_time,
    xlab = "Year",
    ylab= "Hours",
    main = "Total time spent in space to date"
  )
  dev.copy(png, graph_file)
  dev.off()
  NULL
}

#' Convert a text format duration "HH:MM" to duration in hours
#'
#' @param duration (str): The text format duration
#' @return duration_hours (float): The duration in hours
text_to_duration <- function(duration) {
  hours_minutes <- strsplit(duration, ":") # results in list of length 2 vectors
  duration_hours <- vapply(
    hours_minutes,
    \(hour_minute) as.numeric(hour_minute[1]) + as.numeric(hour_minute[2])/60,
    # ^ there is an intentional bug on this line (should divide by 60 not 6)
    numeric(1)
  )
  duration_hours
}


#' Add duration in hours (duration_hours) variable to the dataset
#'
#' @param df (pd.DataFrame): The input dataframe.
#' @return df_copy (pd.DataFrame): A copy of df with the new duration_hours variable added
add_duration_hours_variable <- function(df) {
  df[["duration_hours"]] <- text_to_duration(df[["duration"]])
  df
}


if (sys.nframe() == 0) {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 3) {
    input_file <- "data/eva-data.json"
    output_file <- "results/eva-data.csv"
    print("Using default input and output filenames")
  } else {
    input_file <- args[1]
    output_file <- args[2]
    print("Using custom input and output filenames")
  }

  graph_file <- "./cumulative_eva_graph.png"

  main(input_file, output_file, graph_file)
}

# <end ...

#' Calculate the size of the crew for a single crew entry
#'
#' @param crew (character) The text entry in the crew column containing a list of crew member names
#'
#' @return (numeric) The crew size
calculate_crew_size <- function(crew) {
  size <- length(unlist(strsplit(crew, ";")))
  if (size == 0) return(NULL)
  size
}
 
#' Add crew_size column to the dataset containing the value of the crew size
#' 
#' @param df (data.frame): The input data frame.
#' 
#' @return (data.frame): A copy of df with the new crew_size variable added
add_crew_size_column <- function(df) {
  # Adding crew size variable (crew_size) to dataset
  df$crew_size <- vapply(
    df$crew,
    calculate_crew_size,
    integer(1)
  )
  df
}