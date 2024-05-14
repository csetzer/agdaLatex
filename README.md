# Integrating Agda Files into Latex

The code in this directory is based on files created by
  Andreas Abel, Stephan Adelsberger, Anton Setzer

This directory contains a Makefile with some additional script
and example latex, bibtex, and agda files
which allows to integrate agda files into Latex, by using normal
agda files.


## Example

One example is the file
mainLatexFiles/exampleMainLatexFile1.tex

which refers to the agda file
agda/example.agda

where  the prefix used in that agda file is
example
which is added before the macros
and the generated latex file
which ends up in
latex/example.tex

defines macros

\exampleN
(formed from the prefix example and the name N)

\exampleU

and an inline agda macro

\exampleT


## Syntax for Agda files

This file generates from Agda files
latex file which contain definitions

\newcommand{\mymacro}{...}

where \mymacro adds agda code from your agda file into
any existing latex file.

Example files are
agda/example.agda
agda/example2.agda

The name of mymacro is formed from
- a global prefix which you define at the beginning of the agda file
  to indicate which agda file you are referring to
- a name you give to your definition

In your Agda file you add at the beginning a line

--@PREFIX@myprefix

which defines the prefix to be used for your current agda file.

Then for agda code to be included you add at the beginning

--@BEGIN@name
<some agda code>
--@END

Both myprefix and name should only contain normal letters
and no digits, since a latex macro is generated from these two.x

The code will generate a macro
newcommand{\mymacro}{...}
where mymacro is the concatenation of
myprefix  and name

For instane in agda/example.agda
the prefix  is given by

--@PREFIX@example

and an example is the code

--@BEGIN@N

ending with

--@END

which generates a macro

\exampleN

### inline code
In order to create inline code, use

--@BEGIN-inline@name
instead of
--@BEGIN@name

## Configuration

The configuration is
- mainLatexFileDir is where your main latex files are located
  the default is   mainLatexFiles
- mainAgdaDir is the root directory where your agda files are located
  the default is agda
- generatedLagdaDir is a directory where generated lagda files are
     moved to
  the default is lagda   
- generatedLatexBeforeSedFileDir
  is the directory where intermediate latex files (before running sed)
   are placed. Currently the agda.sty files will end up here
- generatedLatexFileDir-
  is the directory where the generated latex files are created
  these are the files to be imported into your latex file
  they will defines \newcommand  latex macros defining the latex ode

- NOTE:
  you should not use
  generatedLagdaDir
  generatedLatexBeforeSedFileDir
  generatedLatexFileDir

  for other purposes since the files there might be overwritten or
  deleted

  An exception is a file agda.sty  in
  generatedLatexBeforeSedFileDir

  where you can use your own version

  If it doesn't exist the script will put the agda generated agda.sty
  file there














