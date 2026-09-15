---
title: Installation instructions
---

To go through the course material on your own or at a workshop, you will need the following software installed and working correctly on your system:

- [Command line terminal (shell)](#command-line-terminal) (such as **Bash**, **Zsh** or **Git Bash**)  
- [Git version control tool](#git-version-control-tool)
- [R](#r)
- [RStudio](#rstudio) integrated development environment (IDE)

You will also need to [create a GitHub account](#github-account) if you do not have one already, make sure that you are able to log into it, and download the [Spacewalks data and analysis code](#spacewalks) which we will be used for exercises in the course.

We also provide ["all in one setup check"](./installation-instructions.html#setup-check) to test everything works as expected.

## Command line terminal

You will need a unix command line terminal (also referred to as a shell)
in order to run some of the code in this workshop including various commands from tools such as Git and tools that interact with your filesystem.

::: tab

### Windows

Windows users *will have to* install **Git Bash**
(which is included in [Git For Windows package](https://gitforwindows.org/)).
This will install the Bash command line terminal emulation and Git command line tool together
(which will behave in the same way as in Linux environments).

Note that the use of Windows command line terminals **Powershell** or `cmd` is not suitable for the course.
We also advise against using [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/)
for this course as we do not provide instructions for troubleshooting any potential issues between WSL and
RStudio.

### macOS & Linux

MacOS and Linux users will already have a command line terminal available on their systems.
You can use a command line terminal such as [Bash](https://www.gnu.org/software/bash/),
or any other [command line terminal that has similar syntax to Bash](https://en.wikipedia.org/wiki/Comparison_of_command_shells),
since none of the content of this course is specific to Bash. Note that starting with macOS Catalina,
Macs will use [Zsh (Z shell)](https://www.zsh.org/) as the default command line terminal instead of Bash.

:::


### Testing command line terminal

To test your command line terminal, start it up and type:

```bash
$ date
```

If your command line terminal is working - it should return the current date and time similar to:

```output
Wed 21 Apr 2021 11:38:19 BST
```

## Git Version Control Tool

Git is a command line program that is run from within a command line terminal to provide version control for your work.
Git is also used to interact with online code and project sharing platform GitHub.

Follow the installation instructions below, then proceed to test and configure Git on your machine in
additional steps.

::: tab

### Windows

Windows users *will have to* use **Git Bash** - as explained in the
[command line terminal installation section](index.html#command-line-terminal).

### macOS & Linux

On macOS, Git is included as part of Apple's [Xcode tools](https://en.wikipedia.org/wiki/Xcode)
and should be available from the command line as long as you have Xcode. If you do not have Xcode installed, you can download it from
[Apple's App Store](https://apps.apple.com/us/app/xcode/id497799835?mt=12) or you can
[install Git using alternative methods](https://git-scm.com/download/mac).

On Linux, Git can be installed using your favourite package manager.

:::


### Testing Git

To test your Git installation, start your command line terminal and type:

```bash
$ git help
```

If your Git installation is working you should see something like:

```output
usage: git [-v | --version] [-h | --help] [-C <path>] [-c <name>=<value>]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           [--config-env=<name>=<envvar>] <command> [<args>]

These are common Git commands used in various situations:

start a working area (see also: git help tutorial)
   clone     Clone a repository into a new directory
   init      Create an empty Git repository or reinitialize an existing one

work on the current change (see also: git help everyday)
   add       Add file contents to the index
   mv        Move or rename a file, a directory, or a symlink
   restore   Restore working tree files
   rm        Remove files from the working tree and from the index

examine the history and state (see also: git help revisions)
   bisect    Use binary search to find the commit that introduced a bug
   diff      Show changes between commits, commit and working tree, etc
   grep      Print lines matching a pattern
   log       Show commit logs
   show      Show various types of objects
   status    Show the working tree status

grow, mark and tweak your common history
   branch    List, create, or delete branches
   commit    Record changes to the repository
   merge     Join two or more development histories together
   rebase    Reapply commits on top of another base tip
   reset     Reset current HEAD to the specified state
   switch    Switch branches
   tag       Create, list, delete or verify a tag object signed with GPG

collaborate (see also: git help workflows)
   fetch     Download objects and refs from another repository
   pull      Fetch from and integrate with another repository or a local branch
   push      Update remote refs along with associated objects

'git help -a' and 'git help -g' list available subcommands and some
concept guides. See 'git help <command>' or 'git help <concept>'
to read about a specific subcommand or concept.
See 'git help git' for an overview of the system.
```

### Configuring Git
When you use Git on a machine for the first time, you also need to configure a few additional things:

* your name,
* your email address (the one you used to open [your GitHub account](../index.html#github-account) with,
  which will be used to identify your commits),
* preferred text editor for Git to use (e.g. **Nano** or another text editor of your choice),
* the default branch name to be `main` (instead of `master`)
* whether you want to use these settings globally (i.e. for every Git project on your machine) by using the `--global` option.

This can be done from a command line terminal as follows:

```bash
$ git config --global user.name "Your Name"
$ git config --global user.email "name@example.com"
$ git config --global core.editor "nano -w"
$ git config --global init.defaultBranch main
```

## GitHub account

GitHub is a free, online host for Git repositories that you will use during the course to store your work in so
you will need to open a free [GitHub](https://github.com/) account unless you do not already have one.

### Configuring GitHub account

In order to access GitHub using Git from your machine securely, you need to set up a way of authenticating yourself with GitHub through Git.
The recommended way to do that for this course is to set up [**SSH authentication**](https://www.ssh.com/academy/ssh/public-key-authentication) which requires a pair of keys - one public that you upload to your GitHub account, and one private that remains on your machine.

GitHub provides full documentation and guides on how to:

- [generate an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent), and
- [add an SSH key to a GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

If you have already configured your SSH key with GitHub - you can skip this step (but make sure to test your setup by running `ssh -T git@github.com` command from the terminal).

A short summary of the commands you need to perform is shown below.

To generate an SSH key pair, you will need to run the `ssh-keygen` command line tool (included with your command line terminal) and provide **your identity for the key pair** (e.g. the email address you used to register with GitHub) via the `-C` parameter as shown below.

You will then be prompted to answer a few questions - e.g. where to save the keys on your machine and a passphrase to use to protect your private key.
Pressing 'Enter' on these prompts will get `ssh-keygen` to use the default key location (within `.ssh` folder in your home directory) and set the passphrase to empty.

```bash
$ ssh-keygen -t ed25519 -C "your-github-email@example.com"
```

```output
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/<YOUR_USERNAME>/.ssh/id_ed25519): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /Users/<YOUR_USERNAME>/.ssh/id_ed25519
Your public key has been saved in /Users/<YOUR_USERNAME>/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:qjhN/iO42nnYmlpink2UTzaJpP8084yx6L2iQkVKdHk your-github-email@example.com
The key's randomart image is:
+--[ED25519 256]--+
|.. ..            |
| ..o A           |
|. o..            |
| .o.o .          |
| ..+ =  B        |
| .o = ..         |
|o..X *.          |
|++B=@.X          |
|+*XOoOo+         |
+----[SHA256]-----+
```

Next, you need to copy your public key (**not your private key - this is important!**) over to
your GitHub account. The `ssh-keygen` command above will let you know where your public key is saved
(the file should have the extension ".pub"), and you can get its contents from a command line terminal as follows:

```bash
$ cat /Users/<YOUR_USERNAME>/.ssh/id_ed25519.pub
```
```output
ssh-ed25519 AABAC3NzaC1lZDI1NTE5AAAAICWGVRsl/pZsxx85QHLwSgJWyfMB1L8RCkEvYNkP4mZC your-github-email@example.com
```

Copy the line of output that starts with "ssh-ed25519" and ends with your email address
(it may start with a different algorithm name based on which one you used to generate the key pair
and it may have gone over multiple lines if your command line terminal window is not wide enough).

Finally, go to your [GitHub Settings -> SSH and GPG keys -> Add New](https://github.com/settings/ssh/new) page
to add a new SSH public key.
Give your key a memorable name (e.g. the name of the computer you are working on that contains the
private key counterpart), paste the public key
from your clipboard into the box labelled "Key" (making sure it does not contain any line breaks),
then click the "Add SSH key" button.

To test if you can successfully authenticate to GitHub using your new key pair, do:

```bash
$ ssh -T git@github.com
```

You may be asked to add GitHub to the list of trusted hosts on your machine (say 'yes' to that) and then you should see a line similar to:

```output
Hi anenadic! You've successfully authenticated, but GitHub does not provide shell access.
```

## R

You will need the statistical programming language R for this course.
You may already have R installed on your system, in which case you do not have to do anything.

To download the latest R distribution for your operating system,
please head to [cran](https://cran.rstudio.com/).

### Testing R

You can check that you have R installed correctly from the command line terminal using the command below.

```bash
$ Rscript --version # on macOS/Linux
```

You should see something like the output below.

```output
Rscript (R) version 4.5.2 (2025-10-31)
```


## RStudio

We will use Posit's [RStudio](https://posit.co/download/rstudio-desktop/) as an Integrated Development Environment (IDE) to type and execute R code and run command line terminal and Git commands.

Please make sure to [download RStudio](https://posit.co/download/rstudio-desktop/) for your platform.

### Windows - Set RStudio to use gitBash Terminal

1. Open RStudio once it has been installed.
1.	Click on the `Tools` menu and choose `Global Options…`. Then choose the `Terminal` tab.
3.	Under “New terminals open with”, choose Git Bash.  
4.	Click OK.
5.	Open a new terminal: Tools → Terminal → New Terminal (or use the Terminal tab). If you already have a Terminal session open, close it and open a new one—some terminal options only apply to new sessions.


## Spacewalks data and analysis code {#spacewalks}

You can download the [`spacewalks.zip` archive](https://github.com/carpentries-incubator/better-research-software-r/raw/refs/heads/main/learners/spacewalks.zip) from GitHub.

The archive contains [NASA's open data on spacewalks](https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn/data_preview)
(i.e. extravehicular activities - EVAs) undertaken by astronauts and cosmonauts from 1965 to 2013 and a Python script to analyse and plot this data.

Save the `spacewalks.zip` archive to your home directory and extract it - you should get a directory called `spacewalks`.


## Setup check (all in one) {#setup-check}

Let's check your setup now to make sure you are ready for the rest of this course.

::::::  challenge

### Check your setup (5 min)

From a command line terminal on your operating system or within RStudio run the following commands to check you have
installed all the tools listed in [the Setup page](./installation-instructions.html) and that are functioning correctly.

From the the terminal within RStudio try the following commands.

Checking the command line terminal:

1. `$ date`
2. `$ echo $SHELL`
3. `$ pwd`
4. `$ whoami`

Checking R:

5. `$ R --version`
7. `$ which R`

Checking Git and GitHub:

9. `$ git --help`
10. `$ git config --list`
11. `$ ssh -T git@github.com`

Checking R and RStudio:

12. Open RStudio and confirm it opens correctly.
13. View the R version printed in the console pane


::: solution

The expected out put of each command is:

1. Today's date
2. `bash` or `zsh` - this tells you what shell language you are using. In this course we show examples in Bash.
3. Your "present working directory" or the folder where your shell is running
4. Your username
5. Something like `Rscript (R) version 4.5.2 (2025-10-31)`, it might be a slightly different version but as long as it is 4.X.X+ it should be okay. It will also print a little bit more descriptive message after this.
7. The file path to where the R version you are calling is installed.
9. The help message explaining how to use the `git` command.
10. You should have `user.name`, `user.email` and `core.editor` set in your Git configuration. Check that the editor listed is one you know how to use.
11. This checks if you have set up your connection to GitHub correctly. If is says `permission denied` you may need to look at the instructions for setting up SSH keys again on the Setup page.
12. RStudio should open and show no errors.
13. (the version should be 4.X.X, if it starts with 3 or earlier then you will need to follow the directions above to [update R and likely RStudio)](./installation-instructions.html#r).

:::

::::::
