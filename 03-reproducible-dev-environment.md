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

So far we have created a local Git repository to track changes in our software project and pushed it to GitHub
to enable others to see and contribute to it. We now want to start developing the code further.

:::::: spoiler

### Code state

<!-- TODO: This reference must be updated to R-version of project: #20 -->
At this point, the code in your local software project's directory should be as in:
<https://github.com/carpentries-incubator/bbrs-software-project/tree/03-reproducible-dev-environment>

::::::::::::::

::::::::::::::::::::::::::::::::::::: instructor

Some learners may encounter issues when installing packages or trying to restore recorded environments. To assist with troubleshooting during workshops, we have compiled a list of common issues that instructors have observed in the past.

If you run into problems not mentioned here, please open an [issue in the lesson repository](https://github.com/carpentries-incubator/better-research-software/issues/) so we can track them and update the lesson material accordingly.

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

This means that our code depends on or requires several **non base R packages.** (also called third-party libraries or **dependencies**) to function - namely `read_csv()`, `hour()`, `as_date()` and `ggplot2`.

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
Instead, isolation is done by per-project library trees plus a lockfile, most commonly via the {renv} package.
Under the hood it’s mostly library path manipulation.

We can still implement this concept, even if implemented differently than Python’s venv or Conda.
This is how

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

Although there is more that we can do to maximise the reproducibility of our software/workflows, the steps described in this episode are an excellent place to start.
We should not let the difficulty of attaining "perfect" reproducibility prevent us from implementing "good enough" practices that make our lives easier and are _much_ better than doing nothing.

::::::::::::::::::::::::::::::

## Managing virtual environments R-style

Instantiating virtual environments in R is multi-step, multi-tool process.
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

{renv} is an R package designed to take care of the complete process - creating a project-specific library (`renv::init`), keeping track of the packages installed in it (`renv::snapshot`), and restoring environments from a recorded lock file (`renv::restore`).
Calling `renv::init()` captures packages and dependencies inside an RStudio project and lists them in a file called `renv.lock`.
A point of information relevant to using `renv` effectively, after `renv::init()`, installing additional packages should be done with `renv::install()` rather than `install.packages()`.
Doing so will update the lock file with the relevant package dependencies.




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
- `renv/.gitignore` tells Git to ignore the `library` subdirectory (it can get quite large, and can always be recreated from the lock file)
- `renv/activate.R` script that sets up the project to use the virtual environment (sets `.libPaths()` to use the project-specific library)
- `library/PLATFORM/X.Y/ARCHITECTURE` subdirectory with (hard-links to) the installed packages.
- `renv/settings.json` configuration settings for {renv} (see the caution box below for some important settings to consider)
- `renv.lock` lock file that records the exact package versions and sources for the environment

Note that, since our software project is being tracked by Git, most of these files will show up in version control - we will see how to handle them using Git in one of the subsequent episodes.


:::::::::::::::::::::::::::::::::::::::::: callout

1. Make sure to use `renv::init(bioconductor=TRUE)` if using any packges from {Bioconductor}.

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

If, for any reason, you want to deactivate the virtual environment and go back to using the global R library paths, you can run:

```r
renv::deactivate()
```

This will remove the `source("renv/activate.R")` line from `.Rprofile`, but leave the rest of the environment intact, so you can reactivate it later with `renv::activate()`. Make sure to restart the R session after deactivating or activating the environment.


### Installing new packages

A point of information relevant to using {renv} effectively, after `renv::init()`, installing additional packages should be done with `renv::install()` rather than `install.packages()`.
Doing so will update the lock file with the relevant package dependencies.


<!-- Got this far -->


We noticed earlier that our code depends on four **external packages/libraries** -
`json`, `csv`, `datetime` and `matplotlib`.
As of Python 3.5, Python comes with in-built JSON and CSV libraries - this means there is no need to install these
additional packages (if you are using a fairly recent version of Python), but you still need to import them in any
script that uses them.
However, we still need to install packages such as `matplotlib` and `pandas` as they do not come as standard with Python distribution.

To install the latest version of `matplotlib` package with `pip` you use pip's `install` command and specify the package’s name, e.g.:

```bash
(venv_spacewalks) $ python3 -m pip install matplotlib
```

You can install multiple packages at once by listing them all at once.

The above command has installed package `matplotlib` in our currently active `venv_spacewalks` environment and will not affect any other Python projects we may have on our machines.

If you run the `python3 -m pip install` command on a package that is already installed, `pip` will notice this and do nothing.

To install a specific version of a Python package give the package name followed by `==` and the version number, e.g. `python3 -m pip install matplotlib==3.5.3`.

To specify a minimum version of a Python package, you can do `python3 -m pip install matplotlib>=3.5.1`.

To upgrade a package to the latest version, e.g. `python3 -m pip install --upgrade matplotlib`.

To display information about a particular installed package do:

```bash
(venv_spacewalks) $ python3 -m pip show matplotlib
```

```output
Name: matplotlib
Version: 3.9.0
Summary: Python plotting package
Home-page:
Author: John D. Hunter, Michael Droettboom
Author-email: Unknown <matplotlib-users@python.org>
License: License agreement for matplotlib versions 1.3.0 and later
=========================================================
...
Location: /opt/homebrew/lib/python3.11/site-packages
Requires: contourpy, cycler, fonttools, kiwisolver, numpy, packaging, pillow, pyparsing, python-dateutil
Required-by:
```

To list all packages installed with `pip` (in your current virtual environment):

```bash
(venv_spacewalks) $ python3 -m pip list
```

```output
Package         Version
--------------- -----------
contourpy       1.3.3
cycler          0.12.1
fonttools       4.60.1
kiwisolver      1.4.9
matplotlib      3.10.7
numpy           2.3.5
packaging       25.0
pillow          12.0.0
pip             25.2
pyparsing       3.2.5
python-dateutil 2.9.0.post0
pytz            2025.2
six             1.17.0
tzdata          2025.2
```

To uninstall a package installed in the virtual environment do: `python3 -m pip uninstall <package-name>`.
You can also supply a list of packages to uninstall at the same time.


:::::::::::::::::::::::::::::::::::::::::  callout

### Why not use `pip3 install <package-name>`?

You may have seen or used the `pip3 install <package-name>` command in the past, which is shorter and perhaps more intuitive than `python3 -m pip install <package-name>`. 

What is the difference?
`python3 -m pip install` uses Python to run the Pip module that comes with the Python distribution using the Python interpreter.
So `/usr/bin/python3.12 -m pip` means you are executing Pip for your Python interpreter located at `/usr/bin/python3.12`.

`pip3 install` runs the Pip module as an executable program with the same name - it may pick up whatever `pip3` your PATH settings tell it to. 
And it may not be for the same Python version your expect - especially if you have several Python distributions (and Pips) installed (which is very common).
There are [edge cases](https://snarky.ca/why-you-should-use-python-m-pip/) when the two commands may produce different results, so be warned.

The [official Pip documentation](https://pip.pypa.io/en/stable/user_guide/#running-pip) recommends `python3 -m pip install` and that is what we will be using too.

::::::::::::::::::::::::::::::::::::::::::::::::::

### Sharing virtual environments

You are collaborating on a project with a team so, naturally, you will want to share your environment with your collaborators so they can easily 'clone' your software project with all of its dependencies and everyone can replicate equivalent virtual environments on their machines.
`pip` has a handy way of exporting, saving and sharing virtual environments.

To export your active environment - use `python3 -m pip freeze` command to produce a list of packages installed in the virtual environment.
A common convention is to put this list in a `requirements.txt` file in your project's root directory:

```bash
(venv_spacewalks) $ python3 -m pip freeze > requirements.txt
(venv_spacewalks) $ cat requirements.txt
```

```output
contourpy==1.2.1
cycler==0.12.1
DateTime==5.5
fonttools==4.53.1
kiwisolver==1.4.5
matplotlib==3.9.2
numpy==2.0.1
packaging==24.1
pillow==10.4.0
pyparsing==3.1.2
python-dateutil==2.9.0.post0
pytz==2024.1
six==1.16.0
zope.interface==7.0.1
```

The first of the above commands will create a `requirements.txt` file in your current directory.
Yours may look a little different, depending on the version of the packages you have installed, as well as any differences in the packages that they themselves use.

The `requirements.txt` file can then be committed to a version control system (we will see how to do this using Git in a moment) and get shipped as part of your software and shared with collaborators and/or users.

### Ignoring files

Note that you only need to share the small `requirements.txt` file with your collaborators - and not the entire `venv_spacewalks` directory with packages contained in your virtual environment.
We need to tell Git to ignore that directory, so it is not tracked and shared - we do this by creating a file `.gitignore` in the root directory of our project and adding a line `venv_spacewalks` to it.

```bash
(venv_spacewalks) $ echo "venv_spacewalks/" >> .gitignore
```
Remember the `.DS_Store` hidden file which is also not necessary to share with our project?
We can tell Git to ignore it by adding it on a new line in `.gitignore` as pattern `**/.DS_Store` (so it will be ignored in any sub-folder of our project).
That way it can safely reside in local projects of macOS users and can be ignored by the rest.

Let's add and commit `.gitignore` to our repository (this file we do want to track and share).

```bash
(venv_spacewalks) $ git add .gitignore
(venv_spacewalks) $ git commit -m "Ignore venv folder and DS_Store file"
```

The same method can be applied to ignore various other files that you do not want Git to track.

Let's now put `requirements.txt` under version control too and share it along with our code.

```bash
(venv_spacewalks) $ git add requirements.txt
(venv_spacewalks) $ git commit -m "Initial commit of requirements.txt"
(venv_spacewalks) $ git push origin main
```

Your collaborators or users of your software can now download your software's source code and replicate the same
virtual software environment for running your code on their machines using `requirements.txt` to install all
the necessary depending packages.

To recreate a virtual environment from `requirements.txt`, from the project root one can do the following:

```bash
(venv_spacewalks) $ python3 -m pip install -r requirements.txt
```

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
from your virtual environment) is update the contents of the `requirements.txt` file accordingly
by re-issuing `pip freeze` command and propagate the updated `requirements.txt` file to your collaborators
via your code sharing platform.

:::::::::::::::::::::: callout

### Environment management can be troublesome

Software environment management is a difficult thing to get right, which is one reason why [the Python community has come up with so many different ways of doing it over the years](https://xkcd.com/1987). 
(That webcomic is several years old at the time of writing and the Python environment management ecosystem has only become _more_ complicated since.)
Unfortunately, even if you try to follow good practices and keep your environments isolated it is possible -- perhaps even likely -- that you will face difficulties with installing and updating dependencies on your projects in the coming years.
Such issues are particularly likely to appear when you upgrade your computer hardware, operating system, and/or interpreter/compiler.
As before, this is not a reason to avoid managing your software environments altogether -- or to avoid upgrading your hardware, operating system, etc! 
If you have descriptions of your environments it will always be easier to reproduce them and keep working with your software than if you need to start from scratch.
Furthermore, your expertise will develop as you get more practice with managing your software environments, which will equip you well to troubleshoot problems if and when they arise.

::::::::::::::::::::::::::::::

## Running the code and reproducing results

We are now setup to run our code from the newly created virtual environment:

```bash
(venv_spacewalks) $ python3 eva_data_analysis.py
```

You should get a pop up window with a graph.
However, some (but not all) Windows users will not.
You might instead see an error like:

```bash
Traceback (most recent call last):
  File "C:\Users\Toaster\Desktop\spacewalks\eva_data_analysis.py", line 30, in <module>
    w.writerow(data[j].values())
  File "C:\Program Files\WindowsApps\PythonSoftwareFoundation.Python.3.12_3.12.2544.0_x64__qbz5n2kfra8p0\Lib\encodings\cp1252.py", line 19, in encode
    return codecs.charmap_encode(input,self.errors,encoding_table)[0]
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
UnicodeEncodeError: 'charmap' codec can't encode character '\x92' in position 101: character maps to <undefined>
(spacewalks) (spacewalks)
```

This is not what we were expecting!
The problem is _character encoding_.
'Standard' Latin characters are encoded using ASCII,
but the expanded Unicode character set covers many more.
In this case, the data contains Unicode characters that are represented in the ASCII input file with shortcuts (`Â` as `\u00c2` and `’` as `\u0092`).

When we read the file, Python converts those into the Unicode characters.
Then by default Windows tries to write out `eva-data.csv` using UTF-7.
This saves space compared to the standard UTF-8,
but it doesn't include all of the characters.
It automatically converts `\u0092` into the shorter `\x92`,
then discovers that doesn't exist in UTF-7.

The fact that different systems have different defaults,
which can change or even break your code's behaviour,
shows why it is so important to make our code's requirements explicit!

We can fix this by explicitly telling Python what encoding to use when reading and writing our files 
(and you should do this even if you have not had the encoding error when running the code - it is good practice 
and otherwise it may catch you the next time you run the code on a different platform):

```python
...
data_f = open('./eva-data.json', 'r', encoding='ascii')
data_t = open('./eva-data.csv','w', encoding='utf-8')
...
```

Remember to commit these latest changes.

```bash
(venv_spacewalks) $ git add eva_data_analysis.py
(venv_spacewalks) $ git commit -m "Specify data encoding"
(venv_spacewalks) $ git push origin main
```

Do not forget to commit any files that have been changed.

## Summary

We now have our code running in its own virtual environment.

Virtual development environments provide significant benefits for software development by allowing developers to isolate project dependencies and configurations, preventing conflicts between projects.
They support reproducibility, making it much easier to recreate the same setup across different machines or for other team members, which helps with collaboration and consistency.
They allow us to share or deploy our environment setup easily, often as a single configuration file.
They promote a "cleaner" way of working and avoid polluting the global system environment with project-specific tools and packages.

In the next episode we will inspect our software in more detail and see how we can improve it further.

:::::: spoiler

### Code state

At this point, the code in your local software project's directory should be as in:
<https://github.com/carpentries-incubator/bbrs-software-project/tree/04-code-readability>

::::::

## Further reading

We recommend the following resources for some additional reading on the topic of this episode:

- [Official Python Documentation: Virtual Environments and Packages](https://docs.python.org/3/tutorial/venv.html)

Also check the [full reference set](learners/reference.md#litref) for the course.

:::::: keypoints

- Virtual environments keep Python versions and dependencies required by different projects separate.
- A Python virtual environment is itself a directory structure.
- You can use `venv` to create and manage Python virtual environments, and `pip` to install and manage external dependencies your code relies on.
- By convention, you can save and export your Python virtual environment in `requirements.txt` file in your project's root
directory, which can then be shared with collaborators/users and used to replicate your virtual environment elsewhere.

::::::
