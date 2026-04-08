---
title: Code readability
teaching: 60
exercises: 30
---

::: questions

- Why does code readability matter?
- How can I organize my code to be more readable?
- What types of documentation can I include to improve the readability of my code?

:::

::: objectives

After completing this episode, participants should be able to:

- Import third-party libraries at the top of a script
- Choose function and variable names that help explain the purpose of the function or variable
- Organize code into reusable functions that achieve a singular purpose
- Write informative, `roxygen2` comments to provide more detail about what the code is doing

:::

In this episode, we will introduce the concept of readable code and consider how it can help create reusable scientific software and empower collaboration between researchers.

While all developers hope their code will be stable long term, software often has to change due to changes in the real world. As requirements change, so must the relevant code. When code needs to be changed, the developer that created it or more likely a different developer needs to understand that code before they can implement the new requirements. 

Readable code facilitates the reading and understanding of the abstraction phases and, as a result, facilitates the evolution of the codebase. Readable code saves future developers' time and effort.

In order to develop readable code, we should ask ourselves: "If I re-read this piece of code in fifteen days or one year, will I be able to understand what I have done and why?"  Or even better: "If a new person who just joined the project reads my software, will they be able to understand what I have written here?"

In this episode, we will learn a few specific software best practices we can follow to help create more readable code. 

:::::: spoiler

### Code state

At this point, the code in your local software project's directory should be as in:
<https://github.com/carpentries-incubator/bbrs-software-project/tree/04-code-readability>

:::

::: spoiler

### Make sure your packages and dependencies are up to date

In the previous section we discussed using the package renv.lock to track packages and their dependencies. At this time, you should have a current renv.lock files and you should have restored the packages library. 

You can check that the project is up-to-date with 

```r
renv::status() #you can run this any time
```

If you haven't, you can restore the packages and their dependencies by running

```r
renv::restore()
```

:::

## Place `library` functions at the top

Let’s look at our code again. One thing that stands out is that we’re calling library() in multiple places throughout the script. By convention, all libraries should be loaded at the top so dependencies are easy to see and not buried in the code. This improves readability and makes the code easier to reuse and maintain.

Our code after the modification should look like the following.

```r
# https://data.nasa.gov/resource/eva.json (with modifications)
data_f_file = 'eva-data.json'
data_t_file = 'eva-data.csv'
g_file = 'cumulative_eva_graph.png'
fieldnames <- c("EVA #", "Country", "Crew    ", "Vehicle", "Date", "Duration", "Purpose")

library(jsonlite)

j_l <- read_json(data_f_file)
data=as.data.frame(j_l[[1]])

for( i in 2:374){
  r = j_l[[i]]
    print(r)
    data =merge(data, as.data.frame(r),  all=TRUE)
}
#data.pop(0)
## Comment out this bit if you don't want the spreadsheet
write.csv(data_t_file)



time <- c()
library(lubridate)
date = Date()


j=1
for (i in rownames(data)){
    print(data[j, ])
    # and this bit
    # w.writerow(data[j].values())
    if (!is.na(data[j,]$duration)){
        tt=data[j,]$duration
        if(tt == ''){
          #do nothing
        }else{
            t=as.POSIXlt(tt,format='%H:%M')
            ttt <- as.numeric(as.difftime(hour(t), units = 'hours')+as.difftime(minute(t), units='mins')+as.difftime(second(t), units='secs'))/(60*60)
            print(t,ttt)
            time <- c(time, ttt)
            if(!is.na(data[j,]$date)){
                date= c(date, as.Date(substr(data[j,'date'], 1, 10), format = '%Y-%m-%d'))
                #date.append(data[j]['date'][0:10])

            }else{
              time <- time[1:length(time) -1]
                }
            }
        }
    j = j+1
}

t=0
for(i in time)
    t <- c(t, t[length(t)]+i)


df <- data.frame(
date, time
)[order(date, time), ]

date <- df$date
time <- df$time


png(g_file)
plot(date,t[2:length(t)],
xlab = 'Year', ylab= 'Total time spent in space to date (hours)'
)
dev.off()
plot(date,t[2:length(t)],
xlab = 'Year', ylab= 'Total time spent in space to date (hours)'
)

```

Let's make sure we commit our changes.

```bash
 $ git add eva_data_analysis.R
 $ git commit -m "Move library calls to the top of the script"
```
## Rules for variable names in R

 $ git add eva_data_analysis.R
 $ git commit -m "Move library calls to the top of the script"
Some highlights:
Some highlights:
- Only alphanumeric characters, dot, and underscores are permitted in variable names.  
- Must start with a letter or a dot (.); if it starts with a dot, the next character cannot be a digit.
- After the first character, you can use letters, digits, dots, and underscores.  
Check the [official  R documentation](https://cran.r-project.org/doc/manuals/r-release/R-intro.html#R-commands_002c-case-sensitivity_002c-etc_002e). You may also find the [Tidyverse Style Guide](https://style.tidyverse.org/) useful.
- Cannot be a reserved word (keywords) such as if, else, repeat, while, function, for, in, next, break, TRUE, FALSE, NULL, NA, NaN, Inf, etc.  
Some highlights:
- Only alphanumeric characters, dot, and underscores are permitted in variable names.  
- Must start with a letter or a dot (.); if it starts with a dot, the next character cannot be a digit.

### Useful things to consider when naming variables

Variables are the most common thing you will assign when coding, and it's really important that it is clear what each variable means in order to understand what the code is doing.

If you return to your code after a long time doing something else, or share your code with a colleague, it should be easy enough to understand what variables are involved in your code from their names.

Therefore we need to give them clear names, but we also want to keep them concise so the code stays readable. There are no "hard and fast rules" here, and it's often a case of using your best judgment.

:::::::::::::::::::::::: callout

“There are only two hard things in Computer Science: cache invalidation and naming things.”  
\- Phil Karlton
Some useful tips for naming variables:
:::::::::::::::::::::::::::::::::

This guidance does not necessarily apply if your variable is a well-known constant in your domain - for example, *c* represents the speed of light in physics.  Though `c` in R often refers to the `c()` function which might be something to consider as well.

Some useful tips for naming variables:

- Short words are better than single character names. For example, if we were creating a variable to store the speed to read a file, `s` (for 'speed') is not descriptive enough but `MBReadPerSecondAverageAfterLastFlushToLog` is too long to read and prone to misspellings. `ReadSpeed` (or `read_speed`) would suffice.  
- If you are finding it difficult to come up with a variable name that is both short and descriptive, go with the short version and use an inline comment to describe it further (more on those in the next section).  
This guidance does not necessarily apply if your variable is a well-known constant in your domain - for example, *c* represents the speed of light in physics.  Though `c` in R often refers to the `c()` function which might be something to consider as well.
- Try to be descriptive where possible and avoid meaningless or funny names like `foo`, `bar`, `var`, `thing`, etc.  
- Programming languages often have global pre-built functions, such as `input`, which you may accidentally overwrite if you assign a variable with the same name and no longer be able to access the original `input` function. In this case, opting for something like `input_data` would be preferable. 
Let's apply this to `eva_data_analysis.R`.

:::::: challenge

### Rename our variables to be more descriptive (5 min)

Let's apply this to `eva_data_analysis.R`.

a. Edit the code as follows to use descriptive (and consistent) variable names:

    - Change `data_f` to `input_file`
    - Change data_t to output_file
    - Change g_file to graph_file
    
*Be sure to change all the occurrences of each variable name.*

b. What other variable names in our code would benefit from renaming? Rename these too. Hint: variables w, t, tt and ttt could also be renamed to be more descriptive.

c. Commit your changes to your repository. Remember to use an informative commit message.



:::::::::::::::::: hint

Variables `t`, `tt` and `ttt` could also be renamed to be more descriptive.
  - **Change `tt` to `duration_str`**: represents a string form of the duration, indicated by "_str".
  - **Change `t` to `duration_dt`**: a datetime object parsed from the string, indicated by "_dt".
  - **Change `ttt` to `duration_hours`**: the duration converted into (decimal) hours.

::::::::::::::::::::::::
Rename these too. 
:::::::::::::::::: hint

Variables `t`, `tt` and `ttt` could also be renamed to be more descriptive.
  - **Change `tt` to `duration_str`**: represents a string form of the duration, indicated by "_str".
  - **Change `t` to `duration_dt`**: a datetime object parsed from the string, indicated by "_dt".
  - **Change `ttt` to `duration_hours`**: the duration converted into (decimal) hours.

::::::::::::::::::::::::
c. Commit your changes to your repository. Remember to use an informative commit message.

:::::::: solution

Updated code after renaming `data_f`, `data_t` and `g_file` as well as variables `t`, `tt` and `ttt` to be more descriptive. 
      
      
```r

# https://data.nasa.gov/resource/eva.json (with modifications)
input_file = 'eva-data.json'
output_file = 'eva-data.csv'
graph_file = 'cumulative_eva_graph.png'
fieldnames <- c("EVA #", "Country", "Crew    ", "Vehicle", "Date", "Duration", "Purpose")
library(jsonlite)
j_l <- read_json(input_file)
data=as.data.frame(j_l[[1]])
for( i in 2:374){
  r = j_l[[i]]
    print(r)
    data =merge(data, as.data.frame(r),  all=TRUE)
}
#data.pop(0)
## Comment out this bit if you don't want the spreadsheet
write.csv(output_file)
time <- c()
library(lubridate)
date = Date()
j=1
for (i in rownames(data)){
    print(data[j, ])
    # and this bit
    # csv_writer.writerow(data[j].values())
    if (!is.na(data[j,]$duration)){
        duration_dt=data[j,]$duration
        if(duration_dt == ''){
          #do nothing
        }else{
            duration_dt=as.POSIXlt(duration_dt,format='%H:%M')
            duration_hours <- as.numeric(as.difftime(hour(duration_dt), units = 'hours')+as.difftime(minute(duration_dt), units='mins')+as.difftime(second(duration_dt), units='secs'))/(60*60)
            print(duration_dt,duration_hours)
            time <- c(time, duration_hours)
            if(!is.na(data[j,]$date)){
                date= c(date, as.Date(substr(data[j,'date'], 1, 10), format = '%Y-%m-%d'))
                #date.append(data[j]['date'][0:10])
            }else{
              time <- time[1:length(time) -1]
                }
            }
        }
    j = j+1
}
t=0
for(i in time)
    t <- c(t, t[length(t)]+i)
df <- data.frame(
date, time
)[order(date, time), ]
date <- df$date
time <- df$time
png(graph_file)
plot(date,t[2:length(t)],
xlab = 'Year', ylab= 'Total time spent in space to date (hours)'
)
dev.off()
plot(date,t[2:length(t)],
xlab = 'Year', ylab= 'Total time spent in space to date (hours)'
)

```
c. Let's commit our latest changes:

```bash
 $ git add eva_data_analysis.R
 $ git commit -m "Use descriptive variable names"
 $ git push origin main
```

:::
::::::

As we have now updated all the variable names to be more descriptive, we can now go and close the issue on GitHub we created earlier.
To do so, we open our repository in GitHub, switch to the Issues tab, find the issue to "improve variable names" we created earlier.
There are more automated ways to close issues based on a commit/pull request that we will learn later, for now we will click the "Close issue" button at the bottom of the discussion.

## Remove unused variables and imports

Unused variables or import statements can cause confusion about what the code is doing, making it harder to read and easier to introduce mistakes. Such things may seem harmless as they do not cause immediate syntax errors - but they can potentially lead to subtle program logic errors, unexpected behavior, wrong results and issues later on making them especially tricky to detect and fix. Over time, this makes the codebase more fragile and harder to maintain and extend.

:::::: challenge

### Remove an unused variable (2 min)

Find and remove an unused variable in our code. Then, commit the updated code to the git repo.

::: solution

Variable `fieldnames` (containing column names for CSV data file) is defined but never used in the code - it should be deleted.

Updated code:

```r

# https://data.nasa.gov/resource/eva.json (with modifications)
input_file = 'eva-data.json'
output_file = 'eva-data.csv'
graph_file = 'cumulative_eva_graph.png'
library(jsonlite)
j_l <- read_json(input_file)
data=as.data.frame(j_l[[1]])
for( i in 2:374){
  r = j_l[[i]]
    print(r)
    data =merge(data, as.data.frame(r),  all=TRUE)
}
#data.pop(0)
## Comment out this bit if you don't want the spreadsheet
write.csv(output_file)
time <- c()
library(lubridate)
date = Date()
j=1
for (i in rownames(data)){
    print(data[j, ])
    # and this bit
    # csv_writer.writerow(data[j].values())
    if (!is.na(data[j,]$duration)){
        duration_dt=data[j,]$duration
        if(duration_dt == ''){
          #do nothing
        }else{
            duration_dt=as.POSIXlt(duration_dt,format='%H:%M')
            duration_hours <- as.numeric(as.difftime(hour(duration_dt), units = 'hours')+as.difftime(minute(duration_dt), units='mins')+as.difftime(second(duration_dt), units='secs'))/(60*60)
            print(duration_dt,duration_hours)
            time <- c(time, duration_hours)
            if(!is.na(data[j,]$date)){
                date= c(date, as.Date(substr(data[j,'date'], 1, 10), format = '%Y-%m-%d'))
                #date.append(data[j]['date'][0:10])
            }else{
              time <- time[1:length(time) -1]
                }
            }
        }
    j = j+1
}
t=0
for(i in time)
    t <- c(t, t[length(t)]+i)
df <- data.frame(
date, time
)[order(date, time), ]
date <- df$date
time <- df$time
png(graph_file)
plot(date,t[2:length(t)],
xlab = 'Year', ylab= 'Total time spent in space to date (hours)'
)
dev.off()
plot(date,t[2:length(t)],
xlab = 'Year', ylab= 'Total time spent in space to date (hours)'
)


```

:::::::
:::::::::::::

Commit changes:

```bash
 $ git add eva_data_analysis.R
 $ git commit -m "Remove unused variable fieldname"
 $ git push origin main
```

:::::::::::::::::::::::::::::::: callout

A linter is a tool that automatically checks your source code for problems without running it.

Linters usually produce warnings/errors with line numbers and (often) suggested fixes.

For R, 	lintr, the standard R linter does static code analysis for style issues and potential problems, supports many editors (including RStudio/VS Code), and is configurable via a .lintr file. Alongside lintr, R programmers commonly use styler which auto-formats R code so you eliminate many lint issues by formatting consistently.

:::::::::::::::::::::::::

:::::::::::::::::::::::::::::::: callout

IDEs can significantly help developers enhance code readability.
They use built-in linters that automatically identify and flag issues in real-time as you write code. 
This process improves readability in several ways:

- **enforcing coding standards**: check for consistent style, formatting, and conventions, e.g. flagging inconsistent indentation, incorrect naming conventions, and excessive line length violations, which helps ensure a consistent look and feel across the entire codebase, making it easier for any developer to read and understand.
- **syntax highlighting and error detection**: use different colors and font styles for different parts of the code (keywords, variables, comments, etc.), providing visual cues that make the code easier to parse and read. 
For example, flagging syntax errors (e.g., missing brackets, semicolons, or misspelled keywords) with visual indicators like wavy red underlines ("squigglies"), allowing for immediate correction and preventing errors from becoming entrenched.
- **highlighting "code smells" and inefficiencies**: beyond simple syntax, advanced IDEs and their extensions can identify "code smells" and potential inefficiencies, such as unused variables, overly complex functions, or duplicate code blocks. 
This encourages developers to refactor the code into smaller, more meaningful functions and classes, which improves clarity and maintainability.
- **providing contextual guidance**: many IDEs provide rich, contextual help and suggestions on how to fix an issue and why it is a problem, helping developers learn and apply best practices for writing high-quality, readable code.
- **facilitating code navigation and refactoring**: features like intelligent code completion, symbol resolution, and automated refactoring support (e.g., renaming variables or extracting methods) allow developers to restructure code to be more efficient and readable without changing its core functionality. 
The IDE understands the underlying structure of the code, which makes these complex operations simple and safe.
::::::::::::::::::::::::::::::::::::::::



## Use existing packages from known developers

Our script currently reads the data line-by-line from the JSON data file and uses custom code to manipulate the data. Variables of interest are stored in lists but there are more suitable data structures (e.g. dataframes or tibbles) to store data in our case.


By choosing custom code over popular and well-tested libraries, we are making our code less readable and understandable and more error-prone. The main functionality of our code can be rewritten as follows using data frames from base R or tibbles from the `tidyverse` package to load and manipulate the data in data frames.
We will also edit our code to use `ggplot2` for plotting so that it consistently uses the `tidyverse`.

First, we need to install the `tidyverse` as a dependency into our virtual environment.

```r
renv::install("tidyverse")
renv::snapshot()
```

Then we will edit the code to use `tibble`. For the sake of time in the workshop, we will give you the updated code. The code should now look like:

```r
library(tidyverse) #tidyverse "contains" ggplot2
library(jsonlite)
library(lubridate)


input_file  <- "./eva-data.json"
output_file <- "./eva-data.csv"
graph_file  <- "./cumulative_eva_graph.png"


eva_tbl <- jsonlite::fromJSON(input_file) |>
  as_tibble()

subset=['duration','date'])
eva_tbl <- eva_tbl |>
  mutate(
    eva  = as.numeric(eva),
    date = ymd_hms(date, quiet = TRUE)
  ) |>
  filter(!is.na(duration), duration != "", !is.na(date))


readr::write_csv(eva_tbl, output_file)


eva_tbl <- eva_tbl |>
  arrange(date)


eva_tbl <- eva_tbl |>
  mutate(
    duration_hours = {
      parts <- str_split(duration, ":", n = 2, simplify = TRUE)
      as.numeric(parts[, 1]) + as.numeric(parts[, 2]) / 60
    },
    cumulative_time = cumsum(duration_hours)
  )


p <- ggplot(eva_tbl, aes(x = date, y = cumulative_time)) +
  geom_point() +
  geom_line() +
  labs(
    x = "Year",
    y = "Total time spent in space to date (hours)"
  ) +
  theme_minimal()

ggsave(graph_file, plot = p, width = 9, height = 5, dpi = 300)
print(p)

```

```r
> renv::status() 
```

```bash
 $ git add eva_data_analysis.R renv.lock
 $ git commit -m "Refactor code and add tidyverse to lockfile"
 $ git push origin main
```

We have committed the code and the environment changes together since they are related and form one logical unit of change.

## Use comments to explain functionality

Commenting is a very useful practice to help convey the context of the code. It can be helpful as a reminder for your future self or your collaborators as to why code is written in a certain way, how it is achieving a specific task, or the real-world implications of your code.


From the official [R documentation](https://cran.r-project.org/doc/manuals/r-patched/R-lang.html?utm_source=chatgpt.com#Comments-1): 

> Comments in R are ignored by the parser. Any text from a # character to the end of the line is taken to be a comment, unless the # character is inside a quoted string. For example,
> x <- 1  # This is a comment...
> y <- "  #... but this is not."

The [Tidyverse Style Guide](https://style.tidyverse.org/functions.html#comments): 

> In code, use comments to explain the “why” not the “what” or “how”. Each line of a comment should begin with the comment symbol and a single space: #.

```r
x <- 5  # In R, "inline comments"" begin with the `#` symbol and at least one space

# this is a single-line comment
y <- x + 10
z <- y*2 + x

# This is a multiline comment in R.
# In reality, it's just a group of one-line comments
# together  
```

Here are a few things to keep in mind when commenting your code:

- Focus on the **why** and the **how** of your code - avoid using comments to explain **what** your code does. 
If your code is too complex for other programmers to understand, consider rewriting it for clarity rather than adding comments to explain it.
- Make sure you are not reiterating something that your code already conveys on its own. Comments should not echo your code.
- Keep comments short and concise. Large blocks of text quickly become unreadable and difficult to maintain.
- Comments that contradict the code are worse than no comments. Always make a priority of keeping comments up-to-date when code changes.

### Examples of unhelpful comments

```r
statetax <- 1.0625  # Assigns the float 1.0625 to the variable 'statetax'
citytax <- 1.01  # Assigns the float 1.01 to the variable 'citytax'
specialtax <- 1.01  # Assigns the float 1.01 to the variable 'specialtax'
```

The comments in this code simply tell us what the code does, which is easy enough to figure out without the inline comments.

### Examples of helpful comments

```r
statetax <- 1.0625  # State sales tax rate is 6.25% through Jan. 1
citytax <- 1.01  # City sales tax rate is 1% through Jan. 1
specialtax <- 1.01  # Special sales tax rate is 1% through Jan. 1
```

In this case, it might not be immediately obvious what each variable represents, so the comments offer helpful, real-world context.
The date in the comment also indicates when the code might need to be updated.

::: challenge

### Add comments to our code (10 min)

a. Examine `eva_data_analysis.R`.
Add as many comments as you think is required to help yourself and others understand what that code is doing.
b. Commit your changes to your repository. Remember to use an informative commit message.

::: solution

### Solution

Some good comments may look like the example below.

```r

library(tidyverse)
library(jsonlite)
library(lubridate)

# Files
input_file  <- "./eva-data.json"
output_file <- "./eva-data.csv"
graph_file  <- "./cumulative_eva_graph.png"

# 1) Read JSON array into a tibble
eva_tbl <- jsonlite::fromJSON(input_file) |>
  as_tibble()

# 2) Convert types + drop missing duration/date
eva_tbl <- eva_tbl |>
  mutate(
    eva  = as.numeric(eva),
    date = ymd_hms(date, quiet = TRUE)
  ) |>
  filter(!is.na(duration), duration != "", !is.na(date))

# 3) Write CSV (index=False equivalent)
readr::write_csv(eva_tbl, output_file)

# 4) Sort by date
eva_tbl <- eva_tbl |>
  arrange(date)

# 5) duration_hours + cumulative_time
eva_tbl <- eva_tbl |>
  mutate(
    duration_hours = {
      parts <- str_split(duration, ":", n = 2, simplify = TRUE)
      as.numeric(parts[, 1]) + as.numeric(parts[, 2]) / 60
    },
    cumulative_time = cumsum(duration_hours)
  )

# 6) Plot + save
p <- ggplot(eva_tbl, aes(x = date, y = cumulative_time)) +
  geom_point() +
  geom_line() +
  labs(
    x = "Year",
    y = "Total time spent in space to date (hours)"
  ) +
  theme_minimal()

ggsave(graph_file, plot = p, width = 9, height = 5, dpi = 300)
print(p)

```
:::::::::::::::::::::::::
::::::::::::::::::::::::::::::::

Commit changes:

```bash
 $ git add eva_data_analysis.R
 $ git commit -m "Add comments to the code"
 $ git push origin main
```

## Separate units of functionality

Functions are a fundamental concept in writing software and are one of the core ways you can organize your code to improve its readability. A function is an isolated section of code that performs a single, *specific* task that can be simple or complex.

A function can then be called multiple times with different inputs throughout a codebase, but its definition only needs to appear once. Breaking up code into functions in this manner benefits readability since the smaller sections are easier to read 
and understand.

Because functions are reusable, they naturally encourage the [Don’t Repeat Yourself (DRY) principle](https://glosario.carpentries.org/en/#dry): instead of copying the same logic throughout a codebase, you define it once and call it as needed. This keeps software from becoming unnecessarily long and confusing. It also improves maintainability—when the behavior in a function needs to change, you update it in one place rather than chasing down multiple copies.

As we will learn in a future episode, testing code also becomes simpler when code is written in functions. Each function can be individually checked to ensure it is doing what is intended, which improves confidence in the software as a whole.

::: callout
Decomposing code into functions helps with reusability of blocks of code and eliminating repetition, 
but, equally importantly, it helps with code readability and testing.
:::

Looking at our code, you may notice it contains different pieces of functionality:

1. reading the data from a JSON file
2. converting and saving the data in the CSV format
3. processing/cleaning the data and preparing it for analysis 
4. data analysis and visualising the results

Let's refactor our code so that reading the data in JSON format into a dataframe (step 1) and converting it and saving 
to the CSV format (step 2) are extracted into separate functions.
Let's name those functions `read_json_to_dataframe` and `write_dataframe_to_csv` respectively. 
The main part of the script should then be simplified to invoke these new functions, while the functions themselves 
contain the complexity of each of these two steps. We will continue to work on steps 3 and 4 above later on.

:::::::::: instructor

You will need to share the code below with the learners via copy-and-paste either in shared notes or chat in a virtual training. Then you can highlight and describe the changes.

:::::::::::::::::::::

After the initial refactoring, our code may look something like the following.

```r

library(tidyverse)
library(jsonlite)
library(lubridate)

# Files
input_file  <- "./eva-data.json"
output_file <- "./eva-data.csv"
graph_file  <- "./cumulative_eva_graph.png"

# 1) Read JSON array into a tibble
read_json_to_dataframe <- function(input_file) {
  jsonlite::fromJSON(input_file) |>
    tibble::as_tibble()
}

# 2) Convert + write to CSV
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

# --- Pipeline ---
eva_tbl <- read_json_to_dataframe(input_file)
eva_tbl <- write_dataframe_to_csv(eva_tbl, output_file)

# 4) Sort by date
eva_tbl <- eva_tbl |>
  arrange(date)

# 5) duration_hours + cumulative_time
eva_tbl <- eva_tbl |>
  mutate(
    duration_hours = {
      parts <- str_split(duration, ":", n = 2, simplify = TRUE)
      as.numeric(parts[, 1]) + as.numeric(parts[, 2]) / 60
    },
    cumulative_time = cumsum(duration_hours)
  )

# 6) Plot + save
p <- ggplot(eva_tbl, aes(x = date, y = cumulative_time)) +
  geom_point() +
  geom_line() +
  labs(
    x = "Year",
    y = "Total time spent in space to date (hours)"
  ) +
  theme_minimal()

ggsave(graph_file, plot = p, width = 9, height = 5, dpi = 300)
print(p)

```

We have chosen to create functions for reading in and writing out data files since this is a very common task within research software.
While these functions do not contain that many lines of code because they rely on the `jsonlite` and `readr` packages that do all the complex data reading, converting and writing operations, it can be useful to package these steps together into reusable functions if you need to read in or write out a lot of similarly structured files and process them in the same way.

We can further simplify the main part of our code by extracting the code to plot a graph into a separate function `plot_cumulative_time_in_space`.
Let's do that as an exercise.

::: challenge

### Extract functionality into a function (5 min)

Extract the code to plot a graph into a separate function `plot_cumulative_time_in_space(df, graph_file)`.
The function should take the following two arguments: 

1. a dataframe `df`, and 
2. a file object or a file path string `graph_file` where to save the plot.

Make sure to commit and push your changes.

::: solution

After extracting the code to plot a graph into a separate function, our code may look something like the following:

```r

library(tidyverse)
library(jsonlite)
library(lubridate)

# Files
input_file  <- "./eva-data.json"
output_file <- "./eva-data.csv"
graph_file  <- "./cumulative_eva_graph.png"

# 1) Read JSON array into a tibble
read_json_to_dataframe <- function(input_file) {
  jsonlite::fromJSON(input_file) |>
    tibble::as_tibble()
}

# 2) Convert + write to CSV (returns the cleaned df invisibly for chaining)
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

# 3) Plot cumulative time in space and save the figure
plot_cumulative_time_in_space <- function(df, graph_file) {
  df <- df |>
    dplyr::arrange(date) |>
    dplyr::mutate(
      duration_hours = {
        parts <- stringr::str_split(duration, ":", n = 2, simplify = TRUE)
        as.numeric(parts[, 1]) + as.numeric(parts[, 2]) / 60
      },
      cumulative_time = cumsum(duration_hours)
    )

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
  # Return p silently: print(p) above already rendered the plot,
  # so invisible() prevents a second auto-print at the top level
  # while still allowing callers to capture the plot object if needed
}

# --- Main (now simplified) ---
eva_tbl <- read_json_to_dataframe(input_file) |>
  write_dataframe_to_csv(output_file = output_file)

plot_cumulative_time_in_space(eva_tbl, graph_file)

```
:::

:::

## Use `roxygen2` comments to document functions

Now that we’ve written a few functions, it’s time to document them so we can quickly remember what they do. That way, someone reading this code later can understand the intent without having to reverse-engineer the implementation.

In scripts, the usual approach is to write clear comments directly above a function. For R packages, the standard is to use [`roxygen2`](https://`roxygen2`.r-lib.org/): a structured comment block, also known as a Roxygen skeleton, is composed of lines starting with #'. This comment block describes what the function does, what inputs it expects, what it returns, and any important edge cases.

Good function documentation improves readability by making the purpose of the code explicit. It also makes functions easier to reuse: when the documentation clearly spells out inputs and outputs, you can call the function elsewhere with confidence—without re-reading the whole body to figure out what it needs and what it produces.

With `roxygen2`, documentation is written immediately above the function definition using` #'` comments. Structured tags such as `@param`, `@return`, and `@examples` are what give the comment block its meaning — `@param` documents each function argument, `@return` describes what the function gives back, and `@examples` provides runnable usage examples. Tooling can turn these structured comments into the help text you see via `?function_name`.

When building a formal R package, `roxygen2` processes these `#'` blocks and auto-generates `.Rd` files — R's native documentation format, stored in the `man/` directory of a package. These `.Rd` files are what power the built-in help system: `?`, `help()`, and the RStudio help pane all read from them.

That said, you can still use roxygen-style comments even if you're not building a formal package. In a regular project, this means adopting` #'` blocks as a consistent convention in your .R scripts, using the same tags (`@param`, `@return`, `@examples`) to standardize what you record. You won't automatically get `?my_function` help pages without a package build, but you still gain a structured, readable, and machine-friendly format that's easy to search and maintain — and if the project ever does become a package, most of the documentation work is already done.

We will learn to generate the `.Rd` files later, but go ahead and start adding comments now.

### Example of a single-line comment

```r

add <- function(x, y) {
  # Add two numbers together
  x + y
}

```

### Example of a multi-line `roxygen2` comment

```r

#' Add two numbers together
#'
#' @param x A numeric value.
#' @param y A numeric value.
#' @return A single numeric value equal to `x + y`.
#' @examples
#' add(1, 2)
#' add(3.5, 4)
add <- function(x, y) {
  x + y
}

```

Some projects may have their own guidelines on how to write `roxygen2` comments, such as [The Tidyverse Style Guide ](https://style.tidyverse.org/documentation.html). If you are contributing code to a wider project or community, try to follow the guidelines and standards they provide 
for code style.

As your code grows and becomes more complex, the `roxygen2` comments can form the content of a reference guide allowing developers to quickly look up how to use the APIs, functions, and classes defined in your codebase.
In R, it’s common to use tooling that extracts function documentation from your source and publishes it as a browsable website, so people can learn how to use your code without cloning the repo or reading the raw files. For package-style documentation written with `roxygen2`, a typical workflow is to generate reference pages from your #' comments and build a site with pkgdown, which produces a documentation website from your package and its help files. We will do this in a later episode that focuses on documentation.

Let's write `roxygen2` comments for the function `read_json_to_dataframe` we introduced in the previous exercise. Remember, questions we want to answer when writing the `roxygen2` comments include:

- What the function does?
- What kind of inputs does the function take? Are they required or optional? Do they have default values?
- What output will the function produce?
- What exceptions/errors, if any, it can produce?

Our `read_json_to_dataframe` function fully described by the `roxygen2` comments may look like:

```r

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

```

:::::: callout

In RStudio, you can add `roxygen2` documentation blocks quickly using built-in helpers. After installing and loading `roxygen2`, place your cursor inside (or immediately above) a function and use Code → Insert Roxygen Skeleton to generate a template comment block with #' lines and common tags like @param and @return. RStudio will pre-populate the parameter list based on the function signature, so you can focus on filling in descriptions and examples. Many people also bind a keyboard shortcut to “Insert Roxygen Skeleton” so documenting functions becomes part of the normal edit cycle, and then run Document (commonly via devtools) to regenerate the help files when working in a package.

::::::

:::::: challenge

### Writing `roxygen2` comments (5 min)

Write `roxygen2` comments for the functions `write_dataframe_to_csv` and `plot_cumulative_time_in_space` we introduced earlier.

::: solution

### Solution

Our `write_dataframe_to_csv` function fully described by its `roxygen2` comments may look like:

```r

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
#' @return The cleaned dataframe (same class as `df` where practical), invisibly
#'   suitable for piping into downstream steps.
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

```

Our `plot_cumulative_time_in_space` function fully described by its `roxygen2` comments may look like:

```r


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
#' plot_cumulative_time_in_space(eva_tbl, "./cumulative_eva_graph.png"
plot_cumulative_time_in_space <- function(df, graph_file) {
  df <- df |>
    dplyr::arrange(date) |>
    dplyr::mutate(
      duration_hours = {
        parts <- stringr::str_split(duration, ":", n = 2, simplify = TRUE)
        as.numeric(parts[, 1]) + as.numeric(parts[, 2]) / 60
      },
      cumulative_time = cumsum(duration_hours)
    )

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

```

:::

::::::

Finally, our code may look something like the following:

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
    dplyr::mutate(
      duration_hours = {
        parts <- stringr::str_split(duration, ":", n = 2, simplify = TRUE)
        as.numeric(parts[, 1]) + as.numeric(parts[, 2]) / 60
      },
      cumulative_time = cumsum(duration_hours)
    )

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

# --- Main ---
eva_tbl <- read_json_to_dataframe(input_file) |>
  write_dataframe_to_csv(output_file = output_file)

plot_cumulative_time_in_space(eva_tbl, graph_file)

```

Do not forget to commit any uncommitted changes you may have and then push your work to GitHub.

```bash
 $ git add <your_changed_files>
 $ git commit -m "Your commit message"
 $ git push origin main
```





## Summary

Good code readability brings many benefits to software development. It makes code easier to understand, maintain, and debug—helping collaborators and future developers as well as the original author. Readable code reduces the risk of errors, speeds up onboarding for new team members, and simplifies code reviews. It also supports long-term sustainability: clear code is easier to extend, adapt, and refactor over time.

Integrated development environments (IDEs) can further improve readability by surfacing issues early through built-in or integrated static analysis tools (linters). Linters flag common problems and style violations as you write code, which helps you address issues immediately rather than discovering them later in the development cycle.

Comments are really important. Roxygen2 can help you insert comment in a structed way that later be used to automate documentation. 

:::::: spoiler

### Code state

At this point, the code in your local software project's directory should be as in:
<https://github.com/carpentries-incubator/bbrs-software-project/tree/05-code-structure>

:::

## Further reading

We recommend the following resources for some additional reading on the topic of this episode:

- [7 tell-tale signs of unreadable code](https://www.index.dev/blog/7-tell-tale-signs-of-unreadable-code-how-to-identify-and-fix-the-problem)
- ['Code Readability Matters' from the Guardian's engineering blog][guardian-code-readability]

Also check the [full reference set](learners/reference.md#litref) for the course.

::: keypoints

	-	Readable code is easier to understand, maintain, debug, and extend (reuse), which saves time and effort.
	-	Choosing descriptive variable and function names communicates intent more clearly.
	-	Using `roxygen2` comments adds context and helps others understand why the code exists, not just what it does.
	-	Use packages for common functionality to avoid duplicating work.
		Refactor repeated logic into small, reusable functions. This improves readability by making responsibilities clear, compartmentalizing what each section does, and isolating code that can be reused elsewhere.

:::
