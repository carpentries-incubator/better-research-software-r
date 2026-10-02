---
title: Code Structure
teaching: 60
exercises: 30
---

:::::::::::::::::::::::::::::::::::::: questions

- How can we best structure code?
- What is a common code structure (pattern) for creating software that can read input from command line?
- What are conventional places to store data, code, results, tests, auxiliary information and metadata 
within our software or research project?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives
After completing this episode, participants should be able to:

- Structure code into smaller, reusable components with a single responsibility/functionality.
- Use the common code pattern for creating software that can read input from command line
- Follow best practices for organising software/research project directories for improved 
readability, accessibility and reproducibility.

::::::::::::::::::::::::::::::::::::::::::::::::

In the previous episode we practiced with tools that can help improve readability of our code, 
including breaking work into single-task functions.
Now we are going to explore common code structures, which can improve readability, accessibility and 
reusability of our code when implemented on our projects as a whole.

:::::: spoiler

### Code state

At this point, the code in your local software project's directory should be as in:
<https://github.com/carpentries-incubator/better-research-software-r/blob/main/tree/04-code-structure>

::::::

::: spoiler

### Make sure your packages and dependencies are up to date

In the previous episode we discussed using the `renv.lock` package to track packages and their dependencies.
At this time, you should have a current renv.lock file and a restored package library. 

You can check that the project is up-to-date with 

```r
renv::status() #you can run this any time
```

If you don't have up-to-date packages, you can restore the packages and their dependencies by running

```r
renv::restore("renv.lock")
```

:::

## Functions for Modular and Reusable Code 

As we saw in the previous episode, functions play a key role in creating modular and reusable code.
After extracting units of functionality into separate functions, the main part of our code became much simpler
and more readable, only invoking three functions, as follows:

```r

eva_tbl <- read_json_to_dataframe(input_file) |>
  write_dataframe_to_csv(output_file = output_file)

plot_cumulative_time_in_space(eva_tbl, graph_file)

```

Guidelines for writing functions include:

- Give each function a single, clear responsibility. This makes functions easier to understand, test, and reuse.
- Write functions that can be easily combined or reused with other functions to build more complex processes.
- Avoid hard-coding values inside functions. They should accept arguments to allow flexibility and reuse in different contexts.

At present, some of our functions combine multiple data processing steps. We can improve our code by breaking each step
into its own function. Specifically, we will convert the line of `plot_cumulative_time_in_space` calculating the variable
`duration_hours` into two new functions: one which converts the spacewalk duration from text into a value we can manipulate 
mathematically (`text_to_duraction`), and a second which appends the results to the dataset.

Remember to add roxygen2 comments to the new functions to explain their functionality. 

:::::::::: instructor

You will need to share the code below with the learners via copy-and-paste either in shared notes or chat in a virtual training.
Then you can highlight and describe the changes.

:::::::::::::::::::::

Our new code may look like the following:

```r

# EVA cumulative time pipeline (tidyverse-first, with reusable functions + roxygen-style docs)
library(tidyverse)
library(jsonlite)
library(lubridate)

# Files
input_file  <- "./eva-data.json"
output_file <- "./eva-data.csv"
graph_file  <- "./cumulative_eva_graph.png"

#' Read EVA data from a JSON file into a tibble
#'
#' Reads a JSON file containing an array of records (objects) and returns the
#' contents as a tibble for downstream analysis.
#'
#' @param input_file Path to a JSON file (character scalar). The file is expected
#'   to contain a JSON array of objects, e.g. `[{"eva":"1", ...}, {"eva":"2", ...}]`.
#' @return A tibble with one row per JSON record and one column per field.
#' @examples
#' eva_tbl <- read_json_to_dataframe("./eva-data.json")
#' dplyr::glimpse(eva_tbl)
read_json_to_dataframe <- function(input_file) {
  jsonlite::fromJSON(input_file) |>
    tibble::as_tibble()
}

#' Clean an EVA dataframe and write it to CSV
#'
#' Coerces key columns to the expected types (e.g., `eva` to numeric and `date`
#' to POSIXct), drops records missing a usable `duration` or `date`, writes the
#' result to a CSV file, and returns the cleaned dataframe.
#'
#' @param df A data frame or tibble containing EVA records. Expected columns
#'   include `eva`, `date`, and `duration`.
#' @param output_file Path to the output CSV file (character scalar).
#'
#' @return The cleaned dataframe (same class as `df` where practical), suitable
#'   for piping into downstream steps.
#'
#' @examples
#' eva_tbl <- read_json_to_dataframe("./eva-data.json")
#' eva_tbl <- write_dataframe_to_csv(eva_tbl, "./eva-data.csv")
write_dataframe_to_csv <- function(df, output_file) {
  df <- df |>
    dplyr::mutate(
      eva  = as.numeric(eva),
      date = lubridate::ymd_hms(date, quiet = TRUE)
    ) |>
    dplyr::filter(!is.na(duration), duration != "", !is.na(date))
  readr::write_csv(df, output_file)
  df
}

#' Convert a duration string to decimal hours
#'
#' Parses a duration string in `"H:MM"` or `"HH:MM"` format and returns the
#' equivalent number of hours as a numeric scalar.
#'
#' @param duration A character scalar in `"H:MM"` or `"HH:MM"` format,
#'   e.g. `"1:30"` or `"12:45"`.
#' @return A numeric scalar representing the duration in decimal hours.
#' @examples
#' text_to_duration("1:30")  # returns 1.5
#' text_to_duration("0:45")  # returns 0.75
text_to_duration <- function(duration) {
  parts <- stringr::str_split(duration, ":", n = 2, simplify = TRUE)
  as.numeric(parts[, 1]) + as.numeric(parts[, 2]) / 60
}

#' Add a numeric duration column to an EVA dataframe
#'
#' Applies `text_to_duration()` to the `duration` column and appends the result
#' as a new `duration_hours` column.
#'
#' @param df A data frame or tibble containing a `duration` column with values
#'   in `"H:MM"` or `"HH:MM"` format.
#' @return The input dataframe with an additional numeric `duration_hours` column.
#' @examples
#' eva_tbl <- read_json_to_dataframe("./eva-data.json") |>
#'   write_dataframe_to_csv("./eva-data.csv") |>
#'   add_duration_hours()
add_duration_hours <- function(df) {
  df |>
    dplyr::mutate(duration_hours = text_to_duration(duration))
}

#' Plot cumulative EVA time in space and save the figure
#'
#' Computes EVA duration in hours from a `duration` string column (expected format
#' like `"H:MM"` or `"HH:MM"`), calculates cumulative time over chronological
#' `date`, generates a ggplot line chart, saves it to disk, and prints it.
#'
#' @param df A data frame or tibble containing EVA records. Expected columns:
#'   `date` (POSIXct or parseable datetime) and `duration` (character `"H:MM"`).
#' @param graph_file Path to the output image file (character scalar), e.g.
#'   `"./cumulative_eva_graph.png"`.
#'
#' @return Invisibly returns the ggplot object.
#'
#' @examples
#' eva_tbl <- read_json_to_dataframe("./eva-data.json") |>
#'   write_dataframe_to_csv("./eva-data.csv")
#' plot_cumulative_time_in_space(eva_tbl, "./cumulative_eva_graph.png")
plot_cumulative_time_in_space <- function(df, graph_file) {
  df <- df |>
    dplyr::arrange(date) |>
    add_duration_hours() |>
    dplyr::mutate(cumulative_time = cumsum(duration_hours))

  p <- ggplot2::ggplot(df, ggplot2::aes(x = date, y = cumulative_time)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::labs(
      x = "Year",
      y = "Total time spent in space to date (hours)"
    ) +
    ggplot2::theme_minimal()

  ggplot2::ggsave(graph_file, plot = p, width = 9, height = 5, dpi = 300)
  print(p)
  invisible(p)
}

# --- main body of our script ---
# this is what gets run

eva_tbl <- read_json_to_dataframe(input_file) |>
  write_dataframe_to_csv(output_file = output_file)

plot_cumulative_time_in_space(eva_tbl, graph_file)

```

Although our code is bit longer than before, it is more readable. Also, the new functions can be reused elsewhere.


## Managing modularity with `source()`

You might have noticed that our code is now much longer thanks to the addition of the Roxygen comments.
Though useful, the Roxygen comments create a lot of visual clutter. One solution is to move the functions
to their own `.R` files. Then we rely on `source()` to make these functions available in the current R session.

Let's move the functions we wrote into their own `.R` files and place them into a folder labeled `R/`.

- Copy `read_json_to_dataframe()` into `R/read_json_to_dataframe.R`
- Copy `write_dataframe_to_csv()` into `R/write_dataframe_to_csv.R`
- Copy `plot_cumulative_time_in_space()` into `R/plot_cumulative_time_in_space.R`
- We'll place the rest of the functions into `R/helpers.R`

:::::::::: instructor

You will need to share the code below with the learners via copy-and-paste either in shared notes or chat in a virtual training. Then you can highlight and describe the changes.

:::::::::::::::::::::

After tucking away the functions, your code may look like this:

```r
# EVA cumulative time pipeline (tidyverse-first, with reusable functions + roxygen-style docs)

#########################
# load packages
library(tidyverse)
library(jsonlite)
library(lubridate)

##########################
# Files
input_file  <- "./eva-data.json"
output_file <- "./eva-data.csv"
graph_file  <- "./cumulative_eva_graph.png"

#########################
# source functions
source("R/read_json_to_dataframe.R")
source("R/write_dataframe_to_csv.R")
source("R/plot_cumulative_time_in_space.R")
source("R/helpers.R")

# --- main body of our script ---

eva_tbl <- read_json_to_dataframe(input_file) |>
  write_dataframe_to_csv(output_file = output_file)

plot_cumulative_time_in_space(eva_tbl, graph_file)
```

## Make your script available in the command line

We have been running our code *interactively*. The opposite of interactive is *non-interactive* or *batch mode*. This approach
has several benefits. For example, another script can produce our input data and be “chained” with our code in a more complex data
analysis pipeline. Another use case would be invoking our script in a loop to automatically analyse a number of input data 
files, an effective alternative to running the script manually over hundreds or thousands of files, which is slow, labor-intensive,
and error-prone. Non-interactive modes also allow code to run on a schedule (e.g., daily or weekly), or based on a trigger (e.g.,
every time a new file is added to a data folder). Finally, it is generally required when sending code for processing elsewhere,
such as a High-Throughput Computing (HTC) cluster. 

When working non-interactively, our code is accessed through the command line. Because the command line can interpret many
different coding languages, we need to start each line with the `Rscript` command, which lets the system know that the code we
are about to feed it should be interpreted as R. (This is parallel to the `git` at the start of a command such as `git add data.csv`.)

Let's say you want the code in `eva_data_analysis.R` to take `new_eva_data.json` as an argument and return a plot of cumulative
time in space. You might try entering `Rscript eva_data_analysis.R new_eva_data.json` into the command line. At the moment, however,
this will return an error. That's because by default the R code is expecting to recieve arguments directly (from someone working in the
open .R file). To run R in the command line, we have to modify our code to allow it to recieve arguments *positionally*—that is, from
an unlabeled list given in the command line, assigning each item to a specific object based on it's place (*position*) in the list.

Here is a minimal example of code we might add to a .R so that it can take arguments positionally:

```r
# load packages

# source calls

# accept arguments positionally
args <- commandArgs(trailingOnly = TRUE)
my_arg <- args[1]

# main block of code
```

:::::::::: instructor

You will need to share the code below with the learners via copy-and-paste either in shared notes or chat in a virtual training. Then you can highlight and describe the changes.

:::::::::::::::::::::

In the case of our current project, adding positional argumentation may look like this:

```r
# EVA cumulative time pipeline (tidyverse-first, with reusable functions + roxygen-style docs)
# Batch mode version

#########################
# load packages
library(tidyverse)
library(jsonlite)
library(lubridate)

##########################
# Files
args <- commandArgs(trailingOnly = TRUE)
input_file  <- args[1]
output_file <- args[2]
graph_file  <- args[3]

# This assumes that when we call our code the arguments are ordered:
# Rscript eva_data_analysis.R <input_file> <output_file> <graph_file>

#########################
# source functions
source("R/read_json_to_dataframe.R")
source("R/write_dataframe_to_csv.R")
source("R/plot_cumulative_time_in_space.R")
source("R/helpers.R")

# --- main body of our script ---

eva_tbl <- read_json_to_dataframe(input_file) |>
  write_dataframe_to_csv(output_file = output_file)

plot_cumulative_time_in_space(eva_tbl, graph_file)
```

We can now run our script from the command line, passing the JSON input data file, the CSV output file, and the plot file as positional arguments:

```bash
$ Rscript eva_data_analysis.R eva-data.json eva-data.csv cumulative_eva_graph.png
```

Remember to commit our changes.

```bash
$ git status
$ git add eva_data_analysis.R
$ git commit -m "Add command line functionality to script"
```

## Directory Structure for Software Projects

Following conventions on consistent and informative directory structure for your projects will ensure people immediately
know where to find things — especially helpful for long-term research projects or when working in teams. A good directory structure
for organizing your research software project should have a clear and logical layout for files and data.

Below are some good practices for setting up and maintaining a research project directory structure.

1. **Top-level directory**
    - Put all files related to a project into a single directory.
    - Choose a meaningful name that reflects the project's purpose or topic.

2. **Subdirectories** — organise the project into clear, well-labeled sub-directories based on the type of content. Common categories include:
    - `data/` — store raw and processed data in separate sub-directories to maintain clarity and avoid overwriting your raw data
    - `R/` or `scripts/` or `src/` — for storing your source code
    - `results/` — for storing analysis outputs, summary statistics, or any data generated after processing
    - `docs/` or `man/` — include a detailed project description and documentation on how the project is organised, methodologies, and file dependencies
    - `figures/` or `plots/` — store all visualizations like charts, graphs, and figures generated from the analysis (these can also go in the `results/` directory)
    - `references/` — a folder for research papers, articles, or any other literature cited or referenced in the project

3. **Naming conventions**
    - Avoid special characters or spaces, as they can cause errors when read by computers; use underscores (`_`) or hyphens (`-`) instead.
    - Name files to reflect their contents, version, or date, or use version control to track different versions.

4. **Use version control**
    - Code and data should be version controlled; you can also version control manuscripts, results, and more.
    - If data files are too large or contain sensitive information, untrack them using `.gitignore`.
    - Use tags and releases to mark specific versions of results (a version submitted to a journal, a dissertation version, a poster version, and so on), to avoid version numbers in file names and the proliferation of near-duplicate files.

Below is an example of a project structure that follows these practices:

```output
project/
├── data/
│   ├── raw/        # untouched source data
│   └── processed/  # cleaned, derived outputs
├── R/              # reusable functions (sourced or packaged)
├── scripts/        # top-level scripts that run the analysis
├── results/        # figures, tables, reports
├── docs/           # documentation, manuscripts
├── project.Rproj
└── README.md
```

:::::: challenge

### Project restructuring (10 min)

Restructure your software project so that input `.json` data is stored in the `data/raw/` directory, processed output in `data/processed/`, and the `.png` plot file saved in `results/` off the project root.

Remove the current result files `eva-data.csv` and `cumulative_eva_graph.png` from the project root (if they exist), as they will be recreated by re-running the code.

Remember to create the `results/` and `data/processed/` directories before running the code, or your code will fail.

::: solution

Create `data/raw/`, `data/processed/`, and `results/`, then move the `.json` data file into the appropriate location.

```bash
mkdir -p data/raw data/processed
mv eva-data.json data/raw
mkdir results
```

Updated code:

```r
# EVA cumulative time pipeline (tidyverse-first, with reusable functions + roxygen-style docs)
# Interactive version

#########################
# load packages
library(tidyverse)
library(jsonlite)
library(lubridate)

##########################
# Files
input_file  <- "data/raw/eva-data.json"
output_file <- "data/processed/eva-data.csv"
graph_file  <- "results/cumulative_eva_graph.png"

#########################
# source functions
source("R/read_json_to_dataframe.R")
source("R/write_dataframe_to_csv.R")
source("R/plot_cumulative_time_in_space.R")
source("R/helpers.R")

# --- main body of our script ---

eva_tbl <- read_json_to_dataframe(input_file) |>
  write_dataframe_to_csv(output_file = output_file)

plot_cumulative_time_in_space(eva_tbl, graph_file)
```

:::

::::::

Remember to commit your latest changes:

```bash
$ git status
$ git add eva_data_analysis.R data/ results/
$ git commit -m "Update project's directory structure"
```

## Code drift

You might have noticed that we have coded ourselves into a corner. We have a version of the code that runs interactively
and another that runs from the command line. It is not uncommon tO add edits as the research work moves along, and having
two copies of the same analysis means remembering to make those edits in both files.

A simpler option would be to have code that is sensitive and responsive to the context in which it is being run. This can
be implemented with a conditional check that branches to hard-coded filenames when running interactively, or to positional
arguments when running in batch mode.

```r
# EVA cumulative time pipeline (tidyverse-first, with reusable functions + roxygen-style docs)
# Context-aware version

#########################
# load packages
library(tidyverse)
library(jsonlite)
library(lubridate)

##########################
# Input resolution

args <- commandArgs(trailingOnly = TRUE)

if (interactive()) {
    input_file  <- "data/raw/eva-data.json"
    output_file <- "data/processed/eva-data.csv"
    graph_file  <- "results/cumulative_eva_graph.png"
} else {
    input_file  <- args[1]
    output_file <- args[2]
    graph_file  <- args[3]
}

#########################
# source functions
source("R/read_json_to_dataframe.R")
source("R/write_dataframe_to_csv.R")
source("R/plot_cumulative_time_in_space.R")
source("R/helpers.R")

# --- main body of our script ---

eva_tbl <- read_json_to_dataframe(input_file) |>
  write_dataframe_to_csv(output_file = output_file)

plot_cumulative_time_in_space(eva_tbl, graph_file)
```

## Summary

A good directory structure helps keep a project organised, making it easier to navigate, understand, and maintain. It promotes a
clear separation of concerns—related files and components are grouped logically—which simplifies development and reduces the
chance of errors.

A well-structured project also supports collaboration, as new contributors can more easily find what they need, and it enables
smoother scaling, testing, and deployment as the codebase grows.

Remember: Passing arguments to a script on the command line requires retooling the code to accept positional arguments
via `commandArgs()`. Addding a simple `interactive()` check can allow a single script to work both interactively and in the 
command line.

:::::: spoiler

### Code state

At this point, the code in your local software project's directory should be as in:
<https://github.com/carpentries-incubator/bbrs-software-project/tree/06-code-correctness>

::::::

## Further Reading

We recommend the following resources for some additional reading on the topic of this episode:

- [Organizing your projects](https://coderefinery.github.io/reproducible-research/organizing-projects/) chapter from the [CodeRefinery's Reproducible Research tutorial](https://coderefinery.github.io/reproducible-research/intro/)
- [MIT Broad Research Communication Lab's "File Structure" guide](https://mitcommlab.mit.edu/broad/commkit/file-structure/)

Also check the [full reference set](learners/reference.md#litref) for the course.

::: keypoints

- Good practices for code and project structure are essential for creating readable, accessible, and reproducible projects.

:::

