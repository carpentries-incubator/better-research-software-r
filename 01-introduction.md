---
title: "Course introduction"
teaching: 10
exercises: 10
---

:::::::::::::::::::::::::::::::::::::: questions

- What is open and reproducible research?
- Why are these practices important, in particular in the context of software used to support such research?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Describe the principles of open and reproducible research and why they are of value in the research community
- Explain how the concept of reproducibility translates into practices for building better research software
- Setup machine with software and data used to teach this course

::::::::::::::::::::::::::::::::::::::::::::::::

Software is [fundamental to modern research][ssi-survey-2014] - some of it would even be impossible without software.
From short, thrown-together temporary scripts written to help with day-to-day research tasks, through an abundance of complex data analysis spreadsheets, to the hundreds of software engineers and millions of lines of code behind international efforts such as the Large Hadron Collider, there are few areas of research where software does not have a fundamental role.

This course teaches good practices and reproducible working methods that are agnostic of a programming language (although we will use R code in our examples).
It aims to provide researchers with the tools and knowledge to feel confident when writing **good quality and sustainable software** to support their research.
Although the discussion will often focus on software developed in the context of research, most of the good practices introduced here are beneficial to software development more generally.

The lesson is particularly focused on one aspect of good (scientific) software development practice: improving software to enhance reproducibility.
That is, enabling others to run our code and obtain the same results we did.

:::::::::::::::::::::: callout

## Why should I care about reproducibility?

Scientific transparency and rigor are key factors in research.
Scientific methodology and results need to be published openly and replicated and confirmed by several independent parties.
However, research papers often lack the full details required for independent reproduction or replication. 
Many attempts at reproducing or replicating the results of scientific studies have failed in a variety of disciplines ranging from psychology ([The Open Science Collaboration (2015)][replication-crisis-osc]) to cancer sciences ([Errington et al (2021)][replication-crisis-errington]).
These are called [**the reproducibility and replicability crises**][reproducibility-crisis] - ongoing methodological crises in which the results of many scientific studies are difficult or impossible to repeat.

Reproducible research is a practice that ensures that researchers can repeat the same analysis multiple times with the same results.
It offers many benefits to those who practice it:

* Reproducible research helps researchers remember how and why they performed specific tasks and analyses; this enables easier explanation of work to collaborators and reviewers.
* Reproducible research enables researchers to quickly modify analyses and figures - this is often required at all stages of research and automating this process saves loads of time.
* Reproducible research enables reusability of previously conducted tasks so that new projects that require the same or similar tasks become much easier and efficient by reusing or reconfiguring previous work.
* Reproducible research supports researchers' career development by facilitating the reuse and citation of all research outputs - including both code and data.
* Reproducible research is a strong indicator of rigor, trustworthiness, and transparency in scientific research.
  This can increase the quality and speed of peer review, because reviewers can directly access the analytical process described in a manuscript.
  It increases the probability that errors are caught early on - by collaborators or during the peer-review process, helping alleviate the reproducibility crisis.  

However, reproducible research often requires that researchers implement new practices and learn new tools.
This course aims to teach some of these practices and tools pertaining to the use of software to conduct reproducible research.

Review [the Reproducible Research Discussion](./reproducible-research-discussion.md) for a more in-depth discussion of this topic.

::::::::::::::::::::::::::::::

## Practices for building better research software

The practices we will cover for building better research software fall into three areas.

### 1. Things you can do with your own computing environment to enhance the software

* Using virtual development environments ensures your software can be developed and run consistently across different systems, making it easier for you and others to run, reuse, and extend your code.

### 2. Things you can do to improve the source code of the software itself

* Organising and structuring your code and project directory keeps your software clean, modular, and reusable, enhancing its readability, extensibility, and reusability.
* Following coding conventions for your programming language produces consistently formatted code that others find it easy to read, reuse or extend in their own examples and applications.
* Writing structured documentation strings and comments within your code will make it more understandable to others who wish to use or extend it. 
* Testing can save time spent on debugging and ensures that your code is correct and does what it is set out to do, giving you and others confidence in your code and the results it produces.

### 3. Things you can do to make the software easier for other people to use

* Using version control and collaboration platforms like [GitHub](https://github.com), [GitLab](https://gitlab.com), and [CodeBerg](https://codeberg.org/) makes it easier to share code and work on it together.
* Fostering a community around your software and promoting collaboration helps to grow a user base for your software and contributes to its long-term sustainability.
* Providing clear and comprehensive documentation, including code comments, API specifications, setup guides, and usage instructions, ensures your software is easy to understand, use, and extend (by you and others).
* Accompanying your software with clear information about its licensing terms and how it should be cited ensures that others can reuse and adapt your code with confidence and that you receive credit when they do so.

:::::::::::::::::: challenge

### Tools and practices you use (5 min)

Individually,

- reflect on what practices or tools you are already using in your software development workflow,
- list some new practices or tools that you would like to start employing or using.

Write your reflections in the shared collaborative document.

::::::::::::::::::

## Our research software project

You are going to follow a fairly typical experience of a new researcher (e.g. a PhD student or a postdoc) joining a research group.
You were emailed some spacewalks data and analysis code bundled in the `spacewalks.zip` archive, written by another group 
member who worked on similar things but has since left. You need to be able to install and run this code on your 
machine, check you can understand it and then adapt it to your own project.

As part of the [setup for this course](./installation-instructions.html#spacewalks), you may have downloaded the `spacewalks.zip` archive. 
If not, you can [download it](https://github.com/carpentries-incubator/better-research-software-r/raw/refs/heads/main/learners/spacewalks.zip) now.
Save the `spacewalks.zip` archive to your home directory and extract it - you should get a directory called `spacewalks`.

The first thing you may want to do is inspect the content of the code and data you received. We will use RStudio for browsing, 
inspecting, modifying files and running our code.

RStudio is a very handy tool for software development and is used by many researchers worldwide. 
RStudio is an Integrated Development Environment (IDE).
IDEs are graphical application that provide a comprehensive workspace for writing, editing, testing, and debugging code - all in one place. 
While RStudio is seemingly the most popular, current IDE for working with R, there are other IDEs you can use (VS code, Positron, etc).
To open our directory `spacewalks` in RStudio, we first want to make this an R project.

Having our software development project folder as a project in R is helpful for reproduciblity as well.
We will discover in the next episode the issues with "hard coding" specific filesystem paths into our project and how using R projects will help us to create consistent file path references within our project.

To open our directory `spacewalks` in RStudio, we first want to make this an R project.
Having our software development project folder as a project in R is helpful for reproduciblity as well.
We will discover in the next episode the issues with "hard coding" specific filesystem paths into our project and R projects will help us to create consistent file path references within our project.

To create a new project – go to **File -> New Project** this will open the new project setup wizard.
Choose **Existing Directory**, then navigate to where you extracted your spacewalks folder in your home directory using the **Browse...** button and click **Open** once you have selected the `spacewalks` folder.
Then click **Create Project**. 
RStudio will then reopen into your project.  
Note, now it says `spacewalks` in the upper-right hand corner of RStudio since that project is open and the Files pane is showing the files from the `spacewalks` folder.
When you return to working on this project later, you can click on the `spackewalks.Rproj` file in your file explorer/finder window or you can use the Rproject menu in the upper-right hand side of RStudio to select which projct you would like to work in.

You may notice that the software project contains:

1. A JSON file called `data.json` - a snippet of which is shown below - with data on extra-vehicular activities 
(EVAs, i.e. spacewalks) undertaken by astronauts and cosmonauts from 1965 to 2013 (data provided by NASA via its [Open Data Portal](https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn/about_data)).

   ![JSON data file snippet showing EVA/spacewalk data including EVA ID, country, crew members, vehicle type, date of the spacewalk, duration, and purpose](fig/astronaut-data-json-single-line-snippet.png){alt='JSON data file snippet showing EVA/spacewalk data including EVA ID, country, crew members, vehicle type, date of the spacewalk, duration, and purpose'}
2. An R script called `my code v2.R` containing some analysis code.

3. `spacewalks.Rproj` the R project for this folder.

   <!--- screenshot replacement needed ![The first few lines of a Python script](fig/astronaut-analysis-bad-code-screenshot.png){alt='The first few lines of a Python script used as example code for the episode'} -->

   The code in the R script does some common research tasks:

  * Reads in the data from the JSON file
  * Changes the data from one data format to another and saves to a file in the new format (CSV)
  * Performs some calculations to generate summary statistics about the data
  * Makes a plot to visualise the data

3. A folder called `astronaut-data-analysis-old` - which presumably contains previous versions of the analysis acting as some sort of a backup.
4. A hidden file `.DS_Store` - Desktop Services Store is a hidden metadata file automatically created by macOS Finder in every folder, storing user-specific view settings like icon positions, window size, and background colors, acting much like Windows' `desktop.ini`.
This makes us think that the author was using macOS operating system but this file is not part of the project itself.


:::::: challenge

### Assess the software project (10 min)

Individually inspect the code and data.
Try and see if you can understand what the code is doing and how it is organised.

In the shared document, write down anything that you think is not "quite right", not clear, is missing, or could be done better.

::: hint

Below are some suggested questions to help you assess the code.
These are not the only criteria on which you could evaluate the code and you may find other aspects to comment on.

- If these files were emailed to you, or sent on a chat platform, or handed to you on a memory stick, how easy would it be to find them again in 6 months, or 3 years?
- Can you understand the code? Does it make sense to you?
- Could you run the code on your platform/operating system (is there documentation that covers installation instructions)? What programs or libraries do you need to install to make it work (and which versions)? Are these commonly used tools in your field?
- Are you allowed to reuse this code in your own work? If you did, would the owner expect credit in some form (paper authorship, citation or acknowledgement)? Are you allowed to modify the files or share them with others?
- Is the code written in a way that allows you to easily modify or extend it? How easy would it be to change its parameters to calculate a different statistic, or run the analysis on a different input file?

:::

::: solution

### Solution

What the code does:

- reads data in JSON format line by line and manually parses data from each line
- appends the parsed data to a list
- exports the list with data to a CSV file
- reads all spacewalks durations and adds a cumulative sum for all spacewalk durations up to that point in time
- plots the cumulative durations on a graph where x-axes are dates of spacewalks, and y-axis is the cumulative time spent in space up till then

This is a (non-exhaustive) list of things that could be fixed/improved with our code and data:

#### File and variable naming

- the data file (`data.json`) and the R script (`my code v2.R`) could have more descriptive names
- R script (`my code v2.R`) should not contain blank spaces as it may cause problems when running the code from command line
- variables (e.g. `t`, `tt`, `ttt`) should have more descriptive and meaningful names
- version control is embedded in file name (`my code v2.R`) - there are better ways of keeping track of changes to code and its different versions
- the project contains a hidden file `.DS_Store` which is local and personal config file that should not be shared and does not even make sense other than on macOS

#### Code organisation and style

- fixing inconsistent use of `=` vs `<-` in the code
- remove repeated code and use functions instead
- import statements should be grouped at the top
- commenting and uncommenting code should not be used to direct the flow of execution / type of analysis being done
- the code lacks comments, documentation and explanations
- code structure could be improved to be more modular and not one monolithic piece of code - e.g. use functions for reusable units of functionality
- unused variables (e.g. `fieldnames` meant to be used when saving data to CSV file) are polluting the code and confusing the person reading the code
- spaces should not be used in column names as it can lead to error when reading the data in

#### Code content and correctness

- fixing the loop to 374 data entries is not reusable on other data files and would likely break if the data file changed
- use `1:seq_len()` or `seq_along()` instead of `1:<length>` to avoid hard coding the length of the vector and to handle the 0 case better
- how can we be confident the data analysis and plot that is produced as a result are correct?

#### Documentation

- there is no README documentation to orient the user
- there is no licence information to say how the code can be reused (which then means it cannot be reused at all)
- it is not clear what software dependencies the code has
- there are no installation instructions or instructions on how to run the code

:::

::::::

As you have seen from the previous exercise - there are quite a few things that can be improved with this code.
We will try to make this research software project a "bit better" for future use.

### Running the code

Let's try to run the code and see if we can reproduce the results.

Open the script, `my code v2.R`,  in RStudio and run it all via source or by selecting all the code and running it.

You will get an error. We get this error because the paths to the data files have been hard coded as absolute paths for the original developer's machine.
Hard-coding paths is not very reproducible, as it means the paths need to be changed whenever the code is run on a new computer.
We will soon fix the code to use the relative paths within the project structure and eventually we will change the code to take in arguments from the command line when it is run too.

So, we cannot even run the code on our machines.
There is also a number of issues we identified with the software project that could do with improving.
For the rest of this course, we will work on fixing these issues and applying some good software engineering practices.

## Further reading

We recommend the following resources for some additional reading on reproducible research:

* [Reproducible research through reusable code][nesc-ttw-guide-reproducible-research] is a one day course by the [Netherlands eScience Center][nesc] which discusses similar themes to this course, but in a shorter format.
* [The Turing Way's "Guide for Reproducible Research"][ttw-guide-reproducible-research]
* [A Beginner's Guide to Conducting Reproducible Research][beginner-guide-reproducible-research], Jesse M. Alston, Jessica A. Rick, Bulletin of The Ecological Society of America 102 (2) (2021), https://doi.org/10.1002/bes2.1801
* ["Ten reproducible research things" tutorial][10-reproducible-research-things]
* [FORCE11's FAIR 4 Research Software (FAIR4RS) Working Group][fair4rs-working-group]
* ["Good Enough Practices in Scientific Computing" course][good-enough-practices]
* [Reproducibility for Everyone's (R4E) resources][repro4everyone], community-led education initiative to increase adoption of open research practices at scale
* [Training materials on different aspects of research software engineering][intersect-rse-training] (including open source, reproducibility, research software testing, engineering, design, continuous integration, collaboration, version control, packaging,  etc.), compiled by the [INTERSECT project](https://intersect-training.org/)
* [Curated resources][forrt-resources] by the [Framework for Open and Reproducible Research Training](https://forrt.org/) (FORRT)

## Acknowledgements and references

The content of this course borrows from or references [various work](learners/reference.md#litref), especially the [original version of this course with python examples][bbrs-py].
