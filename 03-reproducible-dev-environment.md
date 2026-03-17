---
title: Reproducible software environments
teaching: 30
exercises: 0
---

:::::::::::::::::::::::::::::::::::::: questions

-   What are virtual environments in software development and why use them?
-   How are virtual environments implemented in R? What packages are required?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

-   Set up the infrastructure to run R code in a self-contained execution environment using {renv}.

::::::::::::::::::::::::::::::::::::::::::::::::

So far we have created a local git repository to track changes in our software project and pushed it to GitHub
to enable others to see and contribute to it. We now want to start developing the code further.

:::::: spoiler

### Code state

<!-- TODO: This reference must be updated to R-version of project: #20 -->
At this point, the code in your local software project's directory should be as in:
<https://github.com/carpentries-incubator/bbrs-software-project/tree/03-reproducible-dev-environment>

::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Some learners may encounter issues when installing packages or trying to restore recorded environments. To assist with troubleshooting during workshops, we have compiled a list of common issues that instructors have observed in the past.

If you run into problems not mentioned here, please open an [issue in the lesson repository](https://github.com/carpentries-incubator/better-research-software-r/issues/) so we can track them and update the lesson material accordingly.

#### Troubleshooting package installation issues

- Try using `install.packages('some.pkg', dependencies = TRUE)`

- Use `.libPaths()` and verify that it includes at least one folder for which the user has write permisisons.
  If that’s not the case, try setting `R_LIBS_USER="some/writable/path"` via either `Sys.setenv()` or through an `.Renviron` file.

- [{pak}](https://github.com/r-lib/pak) often does a better job of figuring out and installing (system) dependencies:
  ```R
  install.packages('pak')
  pak::pkg_deps_tree('some.pkg')
  pak::pkg_sysreqs('some.pkg')
  ```
  You can tell {renv} to use {pak} by default by setting `RENV_CONFIG_PAK_ENABLED=TRUE` 


####  General recommendations on using {renv}

- Often it's easier to start with a fresh environment rather than trying to fix an existing one.
  You can do this by deleting the `renv` folder and `renv.lock` file, then calling `renv::init()` again.

::::::::::::::::::::::::::::::::::::::::::::::::

## Software dependencies

If we have a look at our script, we may notice a few library calls such as `library("tidyverse")` throughout the code.

This means that our code depends on or requires several **non-base R packages.** (also called third-party libraries or **dependencies**) to function - namely `read_csv()`, `hour()`, `as_date()` and `ggplot2`.

R code often relies on packages that are not part of the base R distribution.
This means you’ll need to use a package management tool such as `install.packages()` or a dependency manager like {renv} to install and manage them.

Many R projects also depend on specific _versions_ of external packages (for example, because the code was written to use a function or behavior that has since changed), or even a specific version of the R interpreter itself.
As a result, each R project you work on may require a different setup and set of dependencies.

To prevent conflicts and maintain reproducibility across projects, it’s helpful to keep these configurations isolated.
The typical solution is to create a project-specific environment using tools like {renv}, which maintains its own library of packages and records exact versions in a lockfile—ensuring that the project always runs with the same package set it was developed with.

## What are virtual software environments?

So what exactly are virtual software environments, and why use them?

A virtual environment is a self-contained execution context that isolates a program’s dependencies (libraries, configurations, and sometimes even interpreters) from the rest of the system.
A virtual environment provides:

1.  Isolation — Your project uses its own set of libraries without conflicting with global or other project dependencies.\
2.  Reproducibility — You can recreate the same environment later (on another machine, by another user, or at another time).\
3.  Portability — The environment can travel with your project, ensuring the code runs the same way anywhere.\
4.  Control — You decide exactly which versions of dependencies are used.

You can think of it as a sandbox for your code’s ecosystem: the code inside the environment “sees” only the libraries and settings that belong to it.

R doesn’t have Python-style “venvs” baked into the interpreter.
Instead, isolation is done by a per-project library tree plus a lockfile, most commonly via the {renv} package.
Under the hood it’s mostly library path manipulation.

We can still implement this concept, even if implemented differently than Python’s venv or Conda.
We can do this using these abstract concepts and implementations in R.

| Abstract Concept | R implementation |
|------------------------------------|------------------------------------|
| Isolated dependency space | A project-specific library path (e.g. `renv/library`) that overrides global `.libPaths()` |
| Environment definition | A lockfile (`renv.lock`) describing exact package version and sources. |
| Reproducibility | Functions like `renv::snapshot()` and `renv::restore()` that captures and regenerates the environment |
| Environment activation | Automatically handled by an autoload script `.Rprofile` when the project opens |
| Interpreter scope | Typically the same R executable, but you can use containerization (Docker, Podman, Apptainer) to isolate R binaries and OS layers. |

: How virtual environments get implemented in R

:::::::::::::::::::::: callout

## Truly reproducible environments are difficult to attain

Creating and managing isolated environments for each of your software projects and sharing descriptions of those environments alongside the relevant code is a great way to make your software and analyses much more reproducible.
However, "true" computational reproducibility is very difficult to achieve.
For example, the tools we will use in this lesson only track the dependencies of our software, remaining unaware of other aspects of the software's environment such as the operating system and hardware of the system it is running on.
These properties of the environment can influence the running of the software and the results it produces and should be accounted for if a workflow is to be truly reproducible.

Although there is more that we can do to maximize the reproducibility of our software/workflows, the steps described in this episode are an excellent place to start.
We should not let the difficulty of attaining "perfect" reproducibility prevent us from implementing "good enough" practices that make our lives easier and are _much_ better than doing nothing.

::::::::::::::::::::::::::::::

## Managing virtual environments R-style

Instantiating virtual environments in R is multi-step, multi-tool process.

### 1. RStudio's Projects to isolate code and 

The first step is to rely on RStudio's R Project feature, which begins the process of creating an isolated dependency space.
In order to use a package in an RScript, we have to make sure the package code is available locally.
By default, packages downloaded from the web via `install.packages("my_package")` are installed in a platform specific predefined location, e.g:

-   macOS / Linux: \~/Library/R/x.y/library or \~/R/x.y/library
-   Windows: C:/Users/<username>/Documents/R/win-library/x.y/

The specific paths in your machine can be found by running `.libPaths()` in an R console.
R will attempt to install to and load packages from these directories (in order).
If you point that vector to a project-specific library, you have effectively created an "environment".

To have a _reproducible_ environment, we need to be able to recreate the library later. We can do this by
by keeping a detailed record (a _lock file_) of the specific package versions we installed.

### 2. `renv` to manage dependencies 

{renv} is an R package designed to take care of the complete process - creating a project-specific library (`renv::init`), installing new dependencies (`renv::install`), keeping track of the packages installed in it (`renv::snapshot`), and restoring environments from a recorded lock file (`renv::restore`).

Calling `renv::init()` captures packages and dependencies inside an RStudio project and lists them in a file called `renv.lock`.
To use `renv` effectively, once you’ve run `renv::init()`, install additional packages using `renv::install()` instead of `install.packages()`. Doing so will update the lock file with the relevant package dependencies.


### Creating virtual environments

To create a new R virtual environment for our project, make sure that the {renv} package is installed and the current Rstudio project is active. Then run:

```r
renv::init()
```

If you list the contents of the project directory, you should see something like:

```bash
$ tree -a -L 5
```

```output
.
├── .Rprofile
├── renv
│   ├── .gitignore
│   ├── activate.R
│   ├── library
│   │   └── PLATFORM
│   │       └── R-X.Y
│   |           └── ARCHITECTURE
│   └── settings.json
└── renv.lock
```

The `renv::init()` command should have created a few files and directories:

- `.Rprofile` is a file that executes when R is started in the project directory (e.g. when you open the RStudio project), and should now have a call to `source("renv/activate.R")` (see below)
- `renv/.gitignore` tells git to ignore the `library` subdirectory (it can get quite large, and can always be recreated from the lock file)
- `renv/activate.R` script that sets up the project to use the virtual environment (sets `.libPaths()` to use the project-specific library)
- `renv/library/PLATFORM/X.Y/ARCHITECTURE` subdirectory with (hard-links to) the installed packages.
- `renv/settings.json` configuration settings for {renv} (see the caution box below for some important settings to consider)
- `renv.lock` lock file that records the exact package versions and sources for the environment

Note that, since our software project is being tracked by git, most of these files will show up in version control - we will see how to handle them using git in one of the subsequent episodes.


:::::::::::::::::::::::::::::::::::::::::: spoiler

1. Make sure to use `renv::init(bioconductor=TRUE)` if using any packages from {Bioconductor}.

2. **{renv} will track, but not control, the R version** used in the project. That means that if you open the project with a different R version than the one used to create it, {renv} will throw a warning, but still try to use the package versions in the lock file, which may not be compatible with the R version in use.

There are a few ways to handle this:

- Install multiple R versions on your machine and switch between them as needed. In Rstudio, you can set the R version for a project via `Tools -> Project Options... -> General -> R version`. You might also want to look at the [{rig}](https://github.com/r-lib/rig) package.

- Specify the R version in the `renv.lock` file manually. Minor version variations will usually not be a problem when trying to restore an environment, but they will be a headache when working on a collaborative version-controlled project, as everyone's `renv.lock` file will look slightly different. Agree-on and set a shared `"r.version": "X.Y.Z"` in the `renv/settings.json` file.

- If you are working on a package, or want to specify a hand-curated list of "looser" dependencies, you can set `"snapshot.type"="explicit"))`. This allows you to define dependencies in a [`DESCRIPTION`](https://r-pkgs.org/description.html) file, which can improve cross-platform / cross-version compatibility. 

::::::::::::::::::::::::::::::::::::::::::::::::::


### Activating and deactivating virtual environments

You will have to restart the R session (in Rstudio: Session -> Restart R) to activate the virtual environment created by {renv}.
To verify that the environment is active, you can run:

```r
renv::status()
```

Ideally, you should see:

```output
No issues found -- the project is in a consistent state.
```

::::::::::::::::::::::: spoiler

If, for any reason, you want to deactivate the virtual environment and go back to using the global R library paths, you can run:

```r
renv::deactivate()
```

This will remove the `source("renv/activate.R")` line from `.Rprofile`, but leave the rest of the environment intact.

To reactivate we can run:
```r
renv::activate()
```

Make sure to restart the R session after deactivating or activating the environment.

:::::::::::::::::::::::::


### Installing new packages

If you want to install a new package `my_package`, make sure this new package is tracked by `renv`. The easiest way to do so is by running 

```r
renv::install("my_package")
```
Let's install the packages we need for this script. At this time, we need `jsonlite`, `lubridate` and `ggplot2`. 

```r
renv::install("jsonlite", "lubridate", "ggplot2"), 
```

I can also install packages in any of the usual ways, i.e., `install.packages()` or `pak::pkg_install("ggplot2")`, but you'll have to complete an additional step to update the `lock` file enumerating packages and dependencies. A call to `renv::snapshot()` should suffice. 

Now we can open the `renv.lock` file and see that it stores a lot of machine-readable information in plain text. However, you could also <kbd>COMMAND</kbd>+<kbd>F</kbd> (MacOS) or <kbd>CTRL</kbd>+<kbd>F</kbd> (Windows) to double check that the packages installed are now listed. 

### Sharing virtual environments

A collaborator can reconstruct your project libraries with just the `renv.lock` and knowing your version of R, because the version of R is not recorded in the lockfile. 

Let's delete the packages we just installed and then restore them using the existing `renv.lock` file.

```r
remove.packages(c("jsonlite", "lubridate", "ggplot2"))
```

If you attempt to load these packages now, your get an error

```r
library("jsonlite)
```

```output
Error in library(jsonlite) : there is no package called ‘jsonlite’
```

To restore the packages from the `renv.lock`, 
```r
renv::restore("renv.lock")
```

If you attempt to load these packages now, it will work!

```r
library("jsonlite)
```

### Ignoring files

Note that you only need to share the small `renv.lock` file with your collaborators - and not the entire `venv_spacewalks` directory with packages contained in your virtual environment.
We need to tell git to ignore that directory, so it is not tracked and shared - we do this by adding `venv_spacewalks` to the `.gitignore` in the root directory of our project.

```bash
(venv_spacewalks) $ echo "venv_spacewalks/" >> .gitignore
```
If you are a MacOS user, remember the `.DS_Store` hidden file which is also not necessary to share with our project?
We can tell git to ignore it by adding it on a new line in `.gitignore` as pattern `**/.DS_Store` (so it will be ignored in any sub-folder of our project).
That way it can safely reside in local projects of macOS users and can be ignored by the rest.
This can be useful for Windows users as well, if they have or plan to have collaborators or users with MacOS.
Let's add it to our `.gitignore`.

```bash
echo "**/.DS_Store" >> .gitignore 
```



Let's add and commit our updated `.gitignore` to our repository.

```bash
(venv_spacewalks) $ git add .gitignore
(venv_spacewalks) $ git commit -m "Ignore venv folder and DS_Store file"
```

The same method can be applied to ignore various other files that you do not want git to track.


:::::::::::::::::::::: callout

### Another challenge in (long-term) reproducibility

For people (including your future self) to be able to reproduce software environments described in this way, the listed dependencies need to remain available to download and possible to install on the user's system.
These are reasonably safe assumptions for widely-used, actively maintained tools on commonly-used operating systems in the short- to medium-term.
However, it becomes less likely that we will be able to recreate such environments as system architectures evolve over time and maintainers stop supporting older versions of software.
To achieve this kind of long-term reproducibility, you will need to explore options to provide the actual environment -- with dependencies already included -- alongside your software, e.g. via a [containerised environment](https://carpentries-incubator.github.io/docker-introduction/).

::::::::::::::::::::::::::::::

As your project grows - you may need to update your environment for a variety of reasons, e.g.:

- one of your project's dependencies has just released a new version (dependency version number update),
- you need an additional package for data analysis (adding a new dependency), or
- you have found a better package and no longer need the older package
(adding a new and removing an old dependency).

What you need to do in this case (apart from installing the new and removing the packages that are no longer needed
from your virtual environment) is update the contents of the `renv.lock` file accordingly
by rerunning `renv::snapshot()` command and share the updated `renv.lock` file to your collaborators
via your code sharing platform.

:::::::::::::::::::::: callout

### Environment management can be troublesome

Software environment management is a difficult thing to get right, which one reason why new tools and strategies continue to evolve and replace existing ones. 
Unfortunately, even if you try to follow good practices and keep your environments isolated it is possible -- perhaps even likely -- that you will face difficulties with installing and updating dependencies on your projects in the coming years.
Such issues are particularly likely to appear when you upgrade your computer hardware, operating system, and/or interpreter/compiler.
As before, this is not a reason to avoid managing your software environments altogether -- or to avoid upgrading your hardware, operating system, etc! 
If you have descriptions of your environments it will always be easier to reproduce them and keep working with your software than if you need to start from scratch.
Furthermore, your expertise will develop as you get more practice with managing your software environments, which will equip you well to troubleshoot problems if and when they arise.

::::::::::::::::::::::::::::::

## Running the code and reproducing results

We are now setup to run our code from the newly created R project 

```bash

(venv_spacewalks) $ **Rscript eva_data_analysis.R**

```

You should get a pop up window with a graph. However, some (but not all) Windows users will not. You might instead see an error like:

```bash
Error in file(con, "r") : cannot open the connection
In addition: Warning message:
In file(con, "r") : cannot open file 'eva-data.json': No such file or directory
```

This is not what we were expecting!
The problem is _character encoding_.
'Standard' Latin characters are encoded using ASCII,
but the expanded Unicode character set covers many more.
In this case, the data contains Unicode characters that are represented in the ASCII input file with shortcuts (`Â` as `\u00c2` and `’` as `\u0092`).

When we read the file, R converts those into the Unicode characters.
Then by default Windows tries to write out eva-data.csv using a system-dependent default encoding (often a Windows code page such as CP1252), unless you specify otherwise.
This saves space compared to the standard UTF-8,
but it doesn’t include all of the characters.
It automatically converts \u0092 into the shorter \x92,
then discovers that doesn’t exist in the target encoding.

The fact that different systems have different defaults,
which can change or even break your code's behaviour,
shows why it is so important to make our code's requirements explicit!

We can fix this by explicitly telling R what encoding to use when reading and writing our files
(and you should do this even if you have not had the encoding error when running the code - it is good practice
and otherwise it may catch you the next time you run the code on a different platform):

```r
...
data <- jsonlite::fromJSON("./eva-data.json", encoding = "UTF-8")
readLines("./eva-data.json", encoding = "UTF-8")  # (alternative when you need raw text control)
write.csv(data, "./eva-data.csv", fileEncoding = "UTF-8", row.names = FALSE)
...
```

Remember to commit these latest changes.

```bash
(venv_spacewalks) $ git add eva_data_analysis.R
(venv_spacewalks) $ git commit -m "Specify data encoding"
(venv_spacewalks) $ git push origin main
```

Do not forget to commit any files that have been changed.

## Summary

We now have our code running in its own project-local R environment (typically managed with renv).

Project-local R environments provide significant benefits for software development by allowing developers to isolate project dependencies and configurations, preventing conflicts between projects.
They support reproducibility, making it much easier to recreate the same setup across different machines or for other team members, which helps with collaboration and consistency.
They allow us to share or deploy our environment setup easily, often as a single configuration file (e.g., renv.lock).
They promote a “cleaner” way of working and avoid polluting the global system environment with project-specific tools and packages (by keeping package versions scoped to the project library rather than your user/system library).

In the next episode we will inspect our software in more detail and see how we can improve it further.

:::::: spoiler

### Code state

At this point, the code in your local software project's directory should be as in:
<https://github.com/carpentries-incubator/better-research-software-r/tree/04-code-readability>

::::::

## Further reading

We recommend the following resources for some additional reading on the topic of this episode:

- [R renv Documentation: Introduction / Getting Started](https://rstudio.github.io/renv/)
- [CRAN: renv package reference](https://cran.r-project.org/package=renv)
- [Posit (RStudio) article: Reproducible Environments with renv](https://posit.co/blog/renv-project-environments/)


:::::: keypoints

- Virtual environments keep R package versions and dependencies required by different projects separate (without needing separate R installations in most workflows).
- An R project environment is itself a project directory plus a project-local package library (folder) and a lockfile.
- You can use renv to create and manage R project environments, and install packages with install.packages() (or renv::install()) to manage external dependencies your code relies on.
- By convention, you can save and export your R project environment in an renv.lock file in your project’s root directory, which can then be shared with collaborators/users and used to replicate your environment elsewhere.
::::::
