---
title: "Code correctness"
teaching: 60
exercises: 30
---

::: questions

- How can we verify that our code is correct?
- How can we automate our software tests?
- What makes a "good" test?
- Which parts of our code should we prioritise for testing?

:::

::: objectives

After completing this episode, participants should be able to:

- Explain why code testing is important and how this improves software quality.
- Describe the different types of software tests (unit tests, integration tests, regression tests).
- Implement unit tests to verify that function behave as expected using the Python testing framework `pytest`.
- Interpret the output from `pytest` to identify which functions are not behaving as expected.
- Write tests using typical values, edge cases and invalid inputs to ensure that the code can handle extreme values and invalid inputs appropriately.
- Evaluate code coverage to identify how much of the codebase is being tested and identify areas that need further tests.

:::

Now that we have improved the structure and readability of our code - it is much easier to 
test its functionality and improve it further. 
The goal of software testing is to check that the actual results
produced by a piece of code meet our expectations, i.e. are correct.

:::::: spoiler

### Code state

At this point, the code in your local software project's directory should be as in:
<https://github.com/carpentries-incubator/better-research-software-r/tree/main/learners/06-spacewalks>

::::::

## Why use software testing?

Including testing in our research workflow helps us to produce **better software** and conduct **better research**:

- Software testing can help us be more productive as it helps us to identify and fix problems with our code early and
  quickly and allows us to demonstrate to ourselves and others that our
  code does what we claim. More importantly, we can share our tests
  alongside our code, allowing others to verify our software for themselves.
- The act of writing tests encourages to structure our code as individual functions and often results in a more
  **readable**, modular and maintainable codebase that is easier to extend or repurpose.
- Software testing improves the **accessibility** and **reusability** of our code - well-written software tests
  capture the expected behaviour of our code and can be used alongside documentation to help other developers
  quickly make sense of our code. In addition, a well tested codebase allows developers to experiment with new
  features safe in the knowledge that tests will reveal if their changes have broken any existing functionality.
- By demonstrating that our code works as expected and produces accurate results, software testing can give us the confidence to share our code with others.
  Software testing brings peace of mind by providing a
  step-by-step approach that we can apply to verify that our code is
  correct.

## Types of software tests

There are many different types of software tests, including:

- **Unit tests** focus on testing individual functions in
    isolation. They ensure that each small part of the software performs
    as intended. By verifying the correctness of these individual units,
    we can catch errors early in the development process.

- **Integration tests** check how different parts
    of the code e.g. functions work together.

- **Regression tests** are used to ensure that new
    changes or updates to the codebase do not adversely affect the
    existing functionality. They involve checking whether a program or
    part of a program still generates the same results after changes
    have been made.

- **End-to-end** tests are a special type of integration testing which
    checks that a program as a whole behaves as expected.

In this course, our primary focus will be on unit testing. However, the
concepts and techniques we cover will provide a solid foundation
applicable to other types of testing.

::: challenge

### Types of software tests

Fill in the blanks in the sentences below:

- \_\_\_\_\_\_\_\_\_\_ tests compare the \_\_\_\_\_\_ output of a
    program to its \_\_\_\_\_\_\_\_ output to demonstrate correctness.
- Unit tests compare the actual output of a \_\_\_\_\_\_
    \_\_\_\_\_\_\_\_ to the expected output to demonstrate correctness.
- \_\_\_\_\_\_\_\_\_\_ tests check that results have not changed since
    the previous test run.
- \_\_\_\_\_\_\_\_\_\_ tests check that two or more parts of a program
    are working together correctly.

::: solution

- End-to-end tests compare the actual output of a program to the expected output to demonstrate correctness.
- Unit tests compare the actual output of a single function to the expected output to demonstrate correctness.
- Regression tests check that results have not changed since the
    previous test run.
- Integration tests check that two or more parts of a program are
    working together correctly.
:::
:::

## Informal testing

How should we test our code? One approach is to copy/paste the code or a function into a Python terminal - *different from a command line terminal* - which allows you to interact with the Python interpreter more directly.
From the Python terminal we can then run one function or a piece of code at a time and check that they behave as expected.
As input to our code/function we are testing, we typically use some input values for which we know what the correct return value should be.

Let's do this for our `text_to_duration` function.
Recall that the `text_to_duration` function converts a spacewalk duration stored as a string
in format "HH:MM" to a duration in hours - e.g. duration `01:15` (1 hour and 15 minutes) should return a numerical value of `1.25`.

```r
#' Convert a text format duration "HH:MM" to duration in hours
#'
#' @param duration (str): The text format duration
#' @return duration_hours (float): The duration in hours
text_to_duration <- function(duration) {
  hours_minutes <- strsplit(duration, ":") # results in list of length 2 vectors
  duration_hours <- vapply(
    hours_minutes,
    \(hour_minute) as.numeric(hour_minute[1]) + as.numeric(hour_minute[2])/6,
    # ^ there is an intentional bug on this line (should divide by 60 not 6)
    numeric(1)
  )
  duration_hours
}
```

You can type your R code into the Console tab in RStudio.
It will interactively run your code and return and print results.
We could copy and paste the code of our `text_to_duration` function.
Another way to pull in our function definitions is to `source` the file.

```r
> source("eva_data_analysis.R")
> text_to_duration("10:00")
[1] 10
```

So, we have invoked our function with the value "10:00" and it returned the value "10" as expected.

We can then further explore the behaviour of our function by running:

```python
>>> text_to_duration("00:00")
0.0
```

This all seems correct so far.

Testing code in this "informal" way in an important process to go through as we draft our code for the first time.

However, there are some serious drawbacks to this approach if used as our only form of testing.

:::::: challenge

### What are the limitations of informally testing code? (5 minutes)

Think about the questions below. Your instructors may ask you to share
your answers in a shared notes document and/or discuss them with other
participants.

- Why might we choose to test our code informally?
- What are the limitations of relying solely on informal tests to
  verify that a piece of code is behaving as expected?

::: solution

It can be tempting to test our code informally because this approach:

- is quick and easy
- provides immediate feedback

However, there are limitations to this approach:

- Working interactively is error prone
- We must reload our function in Python terminal each time we change our code
- We must repeat our tests every time we update our code which is time consuming
- We must rely on memory to keep track of how we have tested our code, e.g. what input values we tried
- We must rely on memory to keep track of which functions have been tested and which have not 
(informal testing may work well on smaller pieces of code but it becomes unpractical for a large codebase)
- Once we close the Python terminal, we lose all the test scenarios we have tried
:::
::::::

## Formal testing

We can overcome some of these limitations by formalising our testing process. 
A formal approach to testing our code is to write dedicated test functions to check it. 
These test functions:

- Run the function we want to test - the target function with known inputs
- Compare the output to known, valid results
- Raise an error if the function’s actual output does not match the expected output
- Are recorded in a test script that can be re-run on demand.

Let’s explore this process by writing some formal tests for our `text_to_duration` function. 

Create a new R file `test_code.R` in the root of our project directory to store our tests.

Like before in the Python terminal, we need to import `text_to_duration` into our test script. 
Then, we add our first test function:

```r
source("eva_data_analysis.R")
test_text_to_duration_integer <- function() {
  input_value <- "10:00"
  test_result <- text_to_duration("10:00") == 10
  print(paste("text_to_duration('10:00') == 10?", test_result))
}

test_text_to_duration_integer()
```

We can run this code from the command line terminal as:

```bash
$ Rscript test_code.R 
```

This test checks that when we apply `text_to_duration` to input value `10:00`, the output matches the expected value
of `10`.

In this example, we use a print statement to report whether the actual output from `text_to_duration` meets our 
expectations.

However, this does not meet our requirement to “Raise an error if the function’s output does not match the expected 
output” and means that we must carefully read our test function’s output to identify whether it has failed.

To ensure that our code raises an error if the function’s output does not match the expected output, we use R's `stopifnot` statement. This function does nothing if passed in `TRUE` and raises an error if passed in `FALSE`.

Let's rewrite our test with `stopifnot`:

```r

source("eva_data_analysis.R")
test_text_to_duration_integer <- function() {
  stopifnot(text_to_duration("10:00") == 10)
}
test_text_to_duration_integer(
```

Notice that when we run `test_text_to_duration_integer()`, nothing
happens - there is no output. That is because our function is working
correctly and returning the expected value of 10.

Let's add another test to check what happens when duration is not an integer number and if our function can handle 
durations with a non-zero minute component, and rerun our test code.

```python
source("eva_data_analysis.R")
test_text_to_duration_fraction <- function() {
  stopifnot(text_to_duration("10:15") == 10.25)
}
test_text_to_duration_integer <- function() {
  stopifnot(text_to_duration("10:00") == 10)
}
test_text_to_duration_fraction()
test_text_to_duration_integer()
```

``` error
 $ Rscript test_code_02.R

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:

    filter, lag

The following objects are masked from ‘package:base’:

    intersect, setdiff, setequal, union

Error in test_text_to_duration_fraction() : 
  text_to_duration("10:15") == 10.25 is not TRUE
Calls: test_text_to_duration_fraction -> stopifnot
Execution haltedr
```

Notice that this time, our test `test_text_to_duration_fraction` fails.
Our `stopifnot` function has raised an error - a clear signal that there is a problem in our code that we
need to fix.

We know that duration `10:15` should be converted to number `10.25`.
What is wrong with our code?
If we look at our `text_to_duration` function, we may identify the following line of our code as problematic:

```r
text_to_duration <- function(duration) {
    ...
    \(hour_minute) as.numeric(hour_minute[1]) + as.numeric(hour_minute[2])/6,
    ...
}
```

You may notice that we have introduced a bug in one of the earlier episodes when we refactored the code - the minutes component should have been divided by 60 and not 6.

This is quite *critical* - our code was running (seemingly) OK (i.e. it did not fail) and was producing the graph which we 
could not tell was wrong just by looking at it as this was a subtle bug.
We were only able to uncover this bug **by properly testing our code**.

Let's fix the problematic line and rerun out tests. 

```r
...
\(hour_minute) as.numeric(hour_minute[1]) + as.numeric(hour_minute[2])/60,
...
```

This time our tests run without problem. 

Should we add more tests or the tests we have so far are enough? 
What happens if our duration value is `10:20` (ten hours and 20 minutes) and our result is not a rational floating 
point number (like `10.25`) but an irrational number such as `10.333333333`? 
Let's tests for this.

```python
from eva_data_analysis import text_to_duration

def test_text_to_duration_float():
    assert text_to_duration("10:20") == 10.333333

def test_text_to_duration_integer():
    assert text_to_duration("10:00") == 10

test_text_to_duration_float()
test_text_to_duration_integer()

```

```error
$ Rscript test_code.R
...

Error in test_text_to_duration_fraction() : 
  text_to_duration("10:20") == 10.333333 is not TRUE
Calls: test_text_to_duration_fraction -> stopifnot
Execution halted
```

Our test is failing again - what is wrong now?

On computer systems, representation of irrational numbers is typically not exact as they do not have an exact binary 
representation.
For this reason, we cannot use a simple double equals sign (`==`) to compare the equality of floating point numbers. 
Instead, we check that our floating point numbers are equal within a very small tolerance (e.g. 1e-5).
Hence, our code should look like:

```r
...
test_text_to_duration_fraction <- function() {
  stopifnot(abs(text_to_duration("10:20") - 10.333333) < 1e-5)
}
...
```

You may have noticed that we have to repeat a lot of code to add each individual test for each test case. 
You may also have noticed that our test script stopped after the first test failure and none of the tests after that 
were run.
To run our remaining tests we would have to manually comment out our failing test and re-run the test script. 
As our code base grows, testing in this way becomes cumbersome and error-prone. 
These limitations can be overcome by automating our tests using a **testing framework**.

## Testing frameworks

Testing frameworks can automatically find all the tests in our code base, run all of them (so we do not have to invoke 
them explicitly or, even worse, forget to invoke them), and present the test results as a readable summary.

We will use the Python testing framework `testthat` along with the coverage library `covr`.
To install these libraries into our virtual environment, from the command line terminal do:

``` R
> install.packages(c("testthat", "covr"))
```

Let’s set up our tests to work well with `testthat`

With `testthat`, we can label our tests by wrapping them in a `test_that` statement:

```r
library(testthat)
test_that(
  "text_to_duration returns expected values for durations with a non-zero minute component",
  stopifnot(abs(text_to_duration("10:20") - 10.333333) < 1e-5)
)
test_that(
  "text_to_duration returns expected values for typical whole hour durations",
  stopifnot(text_to_duration("10:00") == 10)
)
```

::::::::::::::::::::::::::::::::::::::::::::::::::: callout
### `testthat` vs `test_that`

The name of the R package is `testthat` (no underscore).
The function inside the library is `test_that` (with an understore).
Therefore, we use `testthat` for `install.packages` and `library`,
but `test_that(...)` when we're defining a testcase.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Then replace our base R `stopifnot` with `expect_true` which tells testthat
which errors are the result of the thing we are trying to test not working,
rather htan the result of other things not working.

```r
library(testthat)
test_that(
  "text_to_duration returns expected values for durations with a non-zero minute component",
  expect_true(abs(text_to_duration("10:20") - 10.333333) < 1e-5)
)
test_that(
  "text_to_duration returns expected values for typical whole hour durations",
  expect_true(text_to_duration("10:00") == 10)
)
```

Now, when we `source` our test script or run `$ Rscript test_code.R` in the terminal,
instead of the lack of an error indicating success, we see:

```output
Test passed 🌈
Test passed 😸
```

We can also run our script from the R Console with a utility `testthat` provides.

```r
> testthat::test_file('test_code.R')
```

```output
══ Testing test_code.R ══════════════════════════════════════════════════════════════════════════════════════════
[ FAIL 0 | WARN 0 | SKIP 0 | PASS 2 ] Done!
```

We can also simplify our `expect_` statements by using `expect_identical` (exact)
and `expect_equal` (approximate).

```R
source("eva_data_analysis.R")

library(testthat)
test_that(
  "duration calcalulation works off the hour",
  expect_equal(text_to_duration("10:20"), 10.3333333333)
)
test_that(
  "duration calcalulation works on the hour",
  expect_identical(text_to_duration("10:00"), 10)
)
```

Writing our tests this way highlights the key idea that each test should compare the actual results returned by our 
function with expected values.

Similarly, writing titles for our tests that complete the sentence "Test that ..." helps us to understand 
what each test is doing and why it is needed.
Rerunning our tests, they are still passing.

```r
> testthat::test_file('test_code.R')
```

```output
══ Testing test_code.R ══════════════════════════════════════════════════════════════════════════════════════════
[ FAIL 0 | WARN 0 | SKIP 0 | PASS 2 ] Done!
```

::::::::::::::::::::::::::::: instructor
### Expect equal failing with small diff

At this stage, an expectation like this:

```r
expect_equal(text_to_duration("10:20"), 10.333333) # only 6 trailing 3s in 10.333333
```

```error
── Failure (test_code_04.R:4:1): duration calcalulation works off the hour ─────────────────────────────────────────
text_to_duration("10:20") not equal to 10.333333.
1/1 mismatches
[1] 10.3 - 10.3 == 3.33e-07
```

This can be resolved in one of two ways:

1) Increase the tolerance in expect equal.
  ```r
  expect_equal(text_to_duration("10:20"), 10.333333, tolerance = 1e-5)
  ```

2) Add more trailing `3`s to the expected value. (There need to be at least 7.)
  ```r
  expect_equal(text_to_duration("10:20"), 10.3333333) # 7 trailing 3s in 10.333333
  ```
  
::::::::::::::::::::::::::::::::::::::::


Let's now reintroduce our old bug in function `text_to_duration` that affects 
the durations with a non-zero minute component like "10:20" but not those that are whole hours, e.g. "10:00":

```r
    ...
    \(hour_minute) as.numeric(hour_minute[1]) + as.numeric(hour_minute[2])/6
    ...
```

Let's re-run our tests with `pytest` from our project's root directory (not from the `tests` directory):

``` r
>testthat::test_file("test_code.R")
```

``` error
══ Testing test_code.R ══════════════════════════════════════════════════════════════════════════════════════════
[ FAIL 1 | WARN 0 | SKIP 0 | PASS 1 ]

── Failure (test_code.R:4:1): duration calcalulation works off the hour ─────────────────────────────────────────
text_to_duration("10:20") not equal to 10.3333333.
1/1 mismatches
[1] 13.3 - 10.3 == 3
[ FAIL 1 | WARN 0 | SKIP 0 | PASS 1 ]

```

From the above output from `execution`'s execution of out tests, we notice that: 

- For each testing file, there is a summary of how many successes, skips, and failures occurred in that file. (Since we currently only have one testing file, the file summary and the overall
summary contain identical info.)
- Lists the failures, with the file (`test_code.R`), line number (`4`), and character number (`1`) where the failure occurred.
- Gives an overall summary of the number of successes and failures a the end.

Let's fix our bug once again, and rerun our tests using `testthat`.

```output
══ Testing test_code.R ══════════════════════════════════════════════════════════════════════════════════════════
[ FAIL 0 | WARN 0 | SKIP 0 | PASS 2 ] Done!
```

This time, all out tests passed.

::: challenge

### Interpreting pytest output

A colleague has asked you to conduct a pre-publication review of their code which analyses time spent in 
space by various individual astronauts.

You tested their code using `testthat`, and got the following output.
Inspect it and answer the questions below.

#### Example `pytest` output

``` output
✔ | F W  S  OK | Context
✖ | 2        4 | analyse                                                                                            
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Failure (test_analyse.R:9:3): Test Total Duration
calculate_total_duration(c(10, 15, 20, 5)) (`actual`) not equal to 50/60 (`expected`).

  `actual`: 8.3
`expected`: 0.8

Error (test_analyse.R:12:3): Test Mean Duration
Error in `len(d)`: could not find function "len"
Backtrace:
    ▆
 1. ├─testthat::expect_equal(...) at test_analyse.R:12:3
 2. │ └─testthat::quasi_label(enquo(object), label, arg = "object")
 3. │   └─rlang::eval_bare(expr, quo_get_env(quo))
 4. └─calculate_mean_duration(c(10, 15, 20, 5))
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
✔ |      1   2 | prepare                                                                                            

══ Results ═════════════════════════════════════════════════════════════════════════════════════════════════════════
── Skipped tests (1) ───────────────────────────────────────────────────────────────────────────────────────────────
• Skipping (1): test_prepare.R:1:21

── Failed tests ────────────────────────────────────────────────────────────────────────────────────────────────────
Failure (test_analyse.R:9:3): Test Total Duration
calculate_total_duration(c(10, 15, 20, 5)) (`actual`) not equal to 50/60 (`expected`).

  `actual`: 8.3
`expected`: 0.8

Error (test_analyse.R:12:3): Test Mean Duration
Error in `len(d)`: could not find function "len"
Backtrace:
    ▆
 1. ├─testthat::expect_equal(...) at test_analyse.R:12:3
 2. │ └─testthat::quasi_label(enquo(object), label, arg = "object")
 3. │   └─rlang::eval_bare(expr, quo_get_env(quo))
 4. └─calculate_mean_duration(c(10, 15, 20, 5))

[ FAIL 2 | WARN 0 | SKIP 1 | PASS 6 ]
Error: Test failures
```

a.  How many tests has our colleague included in the test suite?
b.  The one of the tests in test_prepare.R (`Context`: `prepare`) is listed under the `S` column; what does this
    mean?
c.  How many tests failed?
d.  Why did "test_total_duration" fail?
e.  Why did "test_mean_duration" fail?

::: solution
a.  9 tests were detected in the test suite
b.  s - stands for "skipped",
c.  2 tests failed in test_analysis.R
    `test_analyse.py`
d.  `test_total_duration` failed because the calculated total duration
    differs from the expected value by a factor of 10 i.e. the assertion
    `actual == pytest.approx(expected)` evaluated to `False`
e.  `test_mean_duration` failed because there is a syntax error in
    `calculate_mean_duration`. Our colleague has used the command
    `len` (not an R command) instead of `length`.
    As a result, running the function raises an error rather than returning a calculated value causing the function to be interrupted prematurely and the test to fail.
:::
:::

## Test suite design

We now have the tools in place to automatically run tests. 
However, that alone is not enough to properly test code.
We will now look into what makes a good test suite and good practices for testing code.

Let’s start by considering the following scenario. 
A collaborator on our project has sent us the following code which adds a new column called `crew_size` 
to our data containing the number of astronauts participating in any given spacewalk. 
How do we know that it works as intended and that it will not break the rest of our code?
For this, we need to write a test suite with a comprehensive coverage of the new code.
 
```r
import matplotlib.pyplot as plt
import pandas as pd
import sys
import re # added this line

# https://data.nasa.gov/resource/eva.json (with modifications)

def main(input_file, output_file, graph_file):
    print("--START--")

    eva_data = read_json_to_dataframe(input_file)

    eva_data = add_crew_size_column(eva_data) # added this line

    write_dataframe_to_csv(eva_data, output_file)

    plot_cumulative_time_in_space(eva_data, graph_file)

    print("--END--")

... 

def calculate_crew_size(crew):
    """
    Calculate the size of the crew for a single crew entry

    Args:
        crew (str): The text entry in the crew column containing a list of crew member names

    Returns:
        (int): The crew size
    """
    if crew.split() == []:
        return None
    else:
        return len(re.split(r';', crew))-1

def add_crew_size_column(df):
    """
    Add crew_size column to the dataset containing the value of the crew size

    Args:
        df (pd.DataFrame): The input data frame.

    Returns:
        df_copy (pd.DataFrame): A copy of df with the new crew_size variable added
    """
    print('Adding crew size variable (crew_size) to dataset')
    df_copy = df.copy()
    df_copy["crew_size"] = df_copy["crew"].apply(
        calculate_crew_size
    )
    return df_copy
...
    
```

### Writing good tests

The aim of writing good tests is to verify that each of our functions behaves as expected with the full range of inputs 
that it might encounter.
It is helpful to consider each argument of a function in turn and identify the range of typical values it can take.
Once we have identified this typical range or ranges (where a function takes more than one argument), we should:

- Test all values at the edge of the range
- Test at least one interior point
- Test invalid values

Let's have a look at the `calculate_crew_size` function from our colleague's new code and write some tests for it.

:::::: challenge

### Unit tests for calculate_crew_size

Implement unit tests for the `calculate_crew_size` function. 
Cover typical cases and edge cases.

Hint - use the following template when writing tests:

```r
test_that("_______(function) returns _______" { 
  # Typical value 1
  actual_result <- _______________ 
  expected_result <- _______________ 
  expect________________(actual_result, expected_result) 

  # Typical value 2
  actual_result <- _______________
  expected_result <- _______________ 
  expect________________(actual_result, expected_result) 
})

::: solution

We can add the following test functions to out test suite.

```r
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

```

:: instructor
`1L`/`2L` is needed if using `expect_identical` because "identical" means same datatype as well as same value.
`length` returns an integer. `1`, `2`, etc. by default is numeric (float). `1L` indicates we want an integer.

```output
> str(1L)
 int 1

> str(1)
 num 1

> str(length('a'))
 int 1
```


::

Let's run out tests:

```r
> testthat::test_file("test_code_06.R")
```

:::
::::::

### Just enough tests

In this episode, so far we have (only) written tests for two individual functions: `text_to_duration` and 
`calculate_crew_size`.

We can quantify the proportion of our code base that is run (also referred to as "exercised") by a given test suite 
using a metric called code coverage:

$$ \text{Line Coverage} = \left( \frac{\text{Number of Executed Lines}}{\text{Total Number of Executable Lines}} \right) \times 100 $$

We can calculate our test coverage using the `covr` library as follows.

```r
> covr::file_coverage(
  source_files = "eva_data_analysis.R",
  test_files = "test_code.R"
)
```

``` output
Test passed 🥳
Test passed 😀
Test passed 🎊
Test passed 🥳
Coverage: 20.41%
crew_size.R: 20.41%
```

To get an in-depth report about which parts of our code are tested and
which are not, we can send the output of `covr::file_coverage` to `covr::file_report`

``` r
> covr::file_coverage(covr::file_coverage(
  source_files = "eva_data_analysis.R",
  test_files = "test_code.R"
))
```

This option opens up a code coverage report in HTML format. 
The report shows your file in with covered lines in green and coverable lines that 
are not covered in red.

Ideally, all the lines of code in our code base should be exercised by at least one test. 
However, if we lack the time and resources to test every line of our code we should:

- avoid testing R's built-in functions
- focus on the the parts of our code that carry the greatest "reputational risk", i.e. that could affect the accuracy 
of our reported results.

::: callout

Test coverage of less than 100% indicates that more testing may be helpful.

Test coverage of 100% does not mean that our code is bug-free.

:::

::: challenge

### Evaluating code coverage

Generate the code coverage report for your software using the following command.

``` r
> covr::file_coverage(covr::file_coverage(
  source_files = "eva_data_analysis.R",
  test_files = "test_code.R"
))
```

Inspect the html report created by the above command in the root directory of your propject, then open the and extract the following information:

a.  What proportion of the code base is currently "not" exercised by the test suite?
b.  Which functions in our code base are currently untested?

::: solution

a.  The proportion of the code base NOT covered by our tests is 80% (100% - 20%) - this may differ for your 
version of the code.
b.  You can find this information by looking at which functions have red sections.
The following functions in our code base are currently untested:
    -   read_json_to_dataframe
    -   write_dataframe_to_csv
    -   add_duration_hours_variable
    -   plot_cumulative_time_in_space
    -   add_crew_size_variable
:::
:::

At this point, now is a good time to commit our test suite to our codebase and push the changes to GitHub.

``` bash
(venv_spacewalks) $ git add eva_data_analysis.py
(venv_spacewalks) $ git commit -m "Add additional analysis functions"
(venv_spacewalks) $ git add test_code.R
(venv_spacewalks) $ git commit -m "Add test suite"
(venv_spacewalks) $ git add env.lock
(venv_spacewalks) $ git commit -m "Added testthat and covr packages."
(venv_spacewalks) $ git push origin main
```


## Continuous Integration for automated testing

Continuous Integration (CI) services provide the infrastructure to automatically run every test function in 
the test code suite every time changes are pushed to a remote repository.
There is an [extra episode on configuring CI for automated tests on GitHub](../learners/ci-for-testing.md)
for some additional reading.

## Summary

During this episode, we have covered how to use software tests to verify
the correctness of our code. We have seen how to write a unit test, how
to manage and run our tests using the `testthat` framework and how identify
which parts of our code require additional testing using test coverage
reports.

These skills reduce the probability that there will be a mistake in our
code and support reproducible research by giving us the confidence to
engage in open research practices. 
Tests also document the intended behaviour of our code for other developers and mean that we can
experiment with changes to our code knowing that our tests will let us
know if we break any existing functionality. 
In other words, software testing supports the [FAIR software principles][fair-principles-research-software] by making our code more **accessible** and
**reusable**.

::: keypoints

1.  Code testing supports the FAIR principles by improving the
    accessibility and re-usability of research code.
2.  Unit testing is crucial as it ensures each functions works
    correctly.
3.  Using the `pytest` framework, you can write basic unit tests for
    Python functions to verify their correctness.
4.  Identifying and handling edge cases in unit tests is essential to
    ensure your code performs correctly under a variety of conditions.
5.  Test coverage can help you to identify parts of your code that
    require additional testing.

:::
