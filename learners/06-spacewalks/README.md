## Building better research software - example project

This repository provides an example software project designed as a companion for the ["Building better research software" lesson](https://github.com/carpentries-incubator/better-research-software).
The software project is packaged in the [spacewalks.zip archive](./spacewalks.zip) and serves as the starter bundle for learners to download at the beginning of the course. 

The software project contains a Python script that uses the [NASA data on human space walks (Extravehicular activities - EVAs)](https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn/data_preview), 
exported/downloaded in JSON format, does some analysis over this data, plots a few graphs and saves the data in CSV format. 
This example project is intentionally constructed to illustrate [some common mistakes in research software development](#improving-project-using-good-software-development-practices).

Throughout the lesson, course attendees learn and apply better research software practices — including elements of [FAIR](https://www.nature.com/articles/s41597-022-01710-x) — as they work to improve the software project.

### Branches

Different branches of this repository reflect the state of the software project at the start of each episode in the ["Building better research software" lesson](https://github.com/carpentries-incubator/better-research-software):

- Episode ["1. Course introduction"](https://carpentries-incubator.github.io/better-research-software/01-introduction.html) is not making changes to the software.
- Episode ["2. Better start with a software project"](https://carpentries-incubator.github.io/better-research-software/02-better-start-version-control.html) is starting from the [spacewalks.zip](./spacewalks.zip) archive.
- [Branch 03-reproducible-dev-environment](https://github.com/carpentries-incubator/bbrs-software-project/tree/03-reproducible-dev-environment/spacewalks) matches the code at the start of episode ["3. Reproducible software environments"](https://carpentries-incubator.github.io/better-research-software/03-reproducible-dev-environment.html)
- [Branch 04-code-readability](https://github.com/carpentries-incubator/bbrs-software-project/tree/04-code-readability/spacewalks) matches the code at the start of episode ["4. Code readability"](https://carpentries-incubator.github.io/better-research-software/04-code-readability.html)
- [Branch 05-code-structure](https://github.com/carpentries-incubator/bbrs-software-project/tree/05-code-structure/spacewalks) matches the code at the start of episode ["5. Code structure"](https://carpentries-incubator.github.io/better-research-software/05-code-structure.html)
- [Branch 06-code-correctness](https://github.com/carpentries-incubator/bbrs-software-project/tree/06-code-correctness/spacewalks) matches the code at the start of episode ["6. Code correctness"](https://carpentries-incubator.github.io/better-research-software/06-code-correctness.html)
- [Branch 07-software-documentation](https://github.com/carpentries-incubator/bbrs-software-project/tree/07-software-documentation/spacewalks) matches the code at the start of episode ["7. Software documentation"](https://carpentries-incubator.github.io/v-research-software/07-software-documentation)
- [Branch 08-open-collaboration](https://github.com/carpentries-incubator/bbrs-software-project/tree/08-open-collaboration/spacewalks) matches the code at the start of episode ["8. Open collaboration"](https://carpentries-incubator.github.io/better-research-software/08-open-collaboration.html)

**Finally, the better and improved code version of the software project as it is at the end of the lesson can be found in [the "final" branch](https://github.com/carpentries-incubator/bbrs-software-project/tree/final/spacewalks).**

### Improving project using good software development practices

There is a number of things that can be improved with the starter [software project](./spacewalks.zip). 
The practices we cover for building better research software fall into the following three areas:

1. **Steps you can take in your own computing environment to improve the software**
    - The project is missing a `requirements.txt` (or equivalent) file to document dependencies
    - Instructions for running the code are buried within the code rather than provided explicitly
    - Version control is not used; instead, versioning is handled by embedding versions in filenames (e.g. `my code_v2.py`) or directories (e.g. `astronaut-data-analyses-old`).
    - The project's folder structure could be improved — grouping data files, analysis results, plots and tests into clearly named directories
2. **Steps you can take to improve the source code and organisation of the project**
    - Avoid non-descriptive file names like `data.json` or `my_code_v2.py` — use names that reflect the content or purpose of the file
    - Do not use blank spaces or special characters in file names as they can cause errors or be misinterpreted when running scripts from command line
    - Group all import statements at the top of `my_code_v2.py` for clarity and readability, rather than scattering them throughout the code
    - Avoid hard-coding assumptions, such as fixing the loop count to 374 data entries in `my_code_v2.py` — this makes the code fragile and non-reusable with other data files
    - Use descriptive variable names instead of single letters like `w` to make the code easier to understand and maintain
    - Relying on commenting and uncommenting code to control execution or select analyses is impractical and error-prone; consider using functions or configuration files instead
    - Ensure scripts can be run multiple times without failure — for example, `my_code_v2.py` fails on a second run because it tries to save a result to an existing file that cannot be overwritten, and the code does not check for this
    - Add comments, documentation, and explanations in the code to make it easier for others (and your future self) to follow
    - Refactor the code to use functions rather than keeping everything in one large, monolithic block
    - Remove unused variables like `fieldnames`, which was intended for saving data to a CSV file but is not used and clutters the code making it less readable and understandable
    - Avoid spaces in column names within data files, as they can cause errors when reading or processing data
    - When reading data in - do not guess but specify the encoding to prevent errors (this should match the encoding that was used when saving the original data) 
    - Add tests to verify that the code and its outputs are correct; without tests, subtle bugs can easily go unnoticed
3. **Steps you can take to make the software easier for others to use**
    - Missing a README (or similar documentation) to explain the purpose of the project, its dependencies, and how to use it on a high level
    - There are no installation or usage instructions to guide users in more depth
    - Missing a LICENSE file to specify how the code can be reused — without it, reuse is not permitted by default
    - The code should be shared through collaborative software development platforms rather than distributing it via email or messaging apps

This is a non-exhaustive list - there are possibly other things that can be improved upon. 

### Improved software project version

At the end of the lesson, we finish with an [improved version of the software project](https://github.com/carpentries-incubator/bbrs-software-project/tree/final) that people should strive to achieve 
when writing their research software.

### Authors

The authors of this fabricated example software project are:

- [Sarah Jaffa](https://github.com/SJaffa)
- [Kamilla Kopec-Harding](https://github.com/kkh451)
- [Aleks Nenadic](https://github.com/anenadic/)
- [Colin Sauze](https://github.com/colinsauze)

### License

Copyright of code in this project remains with the [authors](#authors) or their organisations and is licensed under the [MIT licence](LICENSE). 
For the data used in this project - see [data section](#data).

### Acknowledgements

#### Data

The data used on in this project is open data provided by NASA and obtained as follows.

Data source: https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn/about_data.

Either export data from the above page using the `Export` button or download in JSON format from command line as: 

`curl https://data.nasa.gov/resource/eva.json --output eva-data.json`

**Note: the original data has been modified for the purposes of this tutorial by inserting a semicolon separator after each name in the `crew` field.**

#### HIFIS 

The idea for this software has been borrowed from the ["Astronaut analysis" workshop material](https://gitlab.com/hifis/hifis-workshops/make-your-code-ready-for-publication/astronaut-analysis) 
by [Helmholtz Federated IT Services (HIFIS)](https://gitlab.com/hifis).

#### Software Sustainability Institute and UKRN

This work has been supported by the [UK's Software Sustainability Institute](https://software.ac.uk) via the [EPSRC, BBSRC, ESRC, NERC, AHRC, STFC and MRC grant EP/S021779/1](https://gow.epsrc.ukri.org/NGBOViewGrant.aspx?GrantRef=EP/S021779/1)
and [UK Reproducibility Network (UKRN)](https://www.ukrn.org/).
