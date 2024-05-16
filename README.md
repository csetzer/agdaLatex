# Integrating Agda Files into Latex

The code in this directory is based on files created by
  Andreas Abel, Stephan Adelsberger, Anton Setzer

This directory contains a Makefile with some additional script and example latex, bibtex, and agda files which allows to integrate agda files into Latex files,   by using normal agda files (no need to use lagda).
The script will generated from tagged Agda files LaTeX  macros which generate the latex code from agda files.

## Slides

slidesCodesprintProposal-AgdaMeetingXXXVIII-SwanseaMay2024.pdf

contains the original proposal for a code sprint
from the Agda Implementors Meeting XXXVIII Swansea 13 May 2024


## Running the example

Download the repository and execute

`make`


## Example

*Preliminaries* The paths `mainLatexFiles`, `agda`, `_generatedLagda`,
`_agdaLatex-before-sed`, `_agdaLatex` used in the following
can be customized in the Makefile.

The main  example is

`mainLatexFiles/exampleMainLatexFile1.tex`

which refers to the Agda file
`agda/example.agda`

After running
`make`
a generated agdaLatex file
`latex/example.tex`
is created which defines LaTeX macros which, when used in a LaTeX file, adds the Agda code to LaTeX.
The `make` command will as well run pdflatex and bibtex
on the file
`mainLatexFiles/exampleMainLatexFile1.tex`

### Example Agda file with tags

The file `example.agda`

starts with
`--@PREFIX@example`

which sets the prefix to "example"

This prefix will be added in front of all LaTeX macros.
We recommend to use for prefix a name which indicate which Agda file you are referring to so that you can find the Agda file easily, where your code and the LaTex macros are defined.

*Note* LaTeX only allows in macros normal character, especially no digits, as often used for names of agda files. A workaround is to use e.g. "one" for "1", "two" for "2", etc.


The file `example.agda` then  tags  the Agda code defining the natural numbers with name "N" using

`--@BEGIN@N`
`--@END`

From this name "N" and the prefix "example" a LaTeX macro

`\exampleN`

is generated
(where "exampleN"  =  "example" ++ "N" )

Furthermore, the agda file has tags introducing a macro

`\exampleU`

and tags introducing a macro  for inline code:

\exampleT

The file
`mainLatexFiles/exampleMainLatexFile1.tex`
then gives example uses for these macros
from which a LaTeX file is generated when running
`make`


## Required Software

You need to have
awk, sed, GNU make, pdflatex, bibtex, agda
installed.

If using Windows you might need to install Ubuntu as a Windows subsystem WSL (supported from the Microsoft store).

## Main commands for creating generated latex files (called agdaLatex files) and running LaTeX

The command

`make`

will create the generated latex files,
It will then execute pdflatex and bibtex on the file `mainLatexFiles/mainLatexFile1`


To do the same for `mainLatexFiles/mainLatexFile2` execute
`make default2`


## Precise Syntax for Agda files

This file generates from Agda files
latex file which contain definitions

\newcommand{\mymacro}{...}

where \mymacro adds Agda code from your Agda file into
any existing latex file.

Example files are
agda/example.agda
agda/example2.agda

The name of mymacro is formed from
- a global prefix which you define at the beginning of the agda file to indicate which agda file you are referring to
- a name you give to your definition

In your Agda file you add at the beginning a line

`--@PREFIX@myprefix`

which defines the prefix to be used for your current Agda file.

Then for Agda code to be included you add at the beginning

`--@BEGIN@name`
`some agda code`
`--@END`

Both myprefix and name should only contain normal letters and no digits, since a latex macro is generated from these.

The code will generate a LaTeX macro
\`newcommand{\mymacro}{...}`
where mymacro is the concatenation of  myprefix  and name

For instance in
`agda/example.agda`
the prefix  is given by

`--@PREFIX@example`

and an example is the code starting with

`--@BEGIN@N`

and ending with

`--@END`

which generates a macro

`\exampleN`

### inline code
In order to create inline code, use

`--@BEGIN-inline@name`
instead of
`--@BEGIN@name`

## Configuration

The configuration is
- `mainLatexFileDir1` is where your main latex files are located
  - The default is   `mainLatexFiles`

- `mainAgdaDir`is the root directory where the agda files from which you want to generated latex files are located.
  - the default is `agda`n

- `generatedLagdaDir` is a directory where generated lagda files are moved to.
   - The default is `_lagda`

- `generatedAgdaLatexBeforeSedFileDir` is where intermediate latex files generated from lagda files are placed.
  - The default is `_agdaLatex-before-sed`

- `generatedAgdaLatexFileDir` is the directory where the LaTeX files generated from the agda files, called "agdaLatex" files are placed.
  - The default is `_agdaLatex`

- `mainLatexFile1` and `mainLatexFile2` define the two main Latex Files on which pdflatex and bibtex is executed

- `bibtexMainLatexFile1`,  `bibtexMainLatexFile2`   determine whether to run bibtex on mainLatexFile1,   mainLatexFile2 respectively


**NOTE:** You should not use
`generatedLagdaDir`, `generatedAgdaLatexBeforeSedFileDir`, `generatedAgdaLatexFileDir`
for other purposes since the files there might be overwritten or
  deleted
