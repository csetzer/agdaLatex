#!/usr/bin/env -S gawk -f

# Script to generate .lagda files from .agda files.
# Expects --@PREFIX@<pref> at the beginning of (or at least early in) the .agda file.
# Parts of the .agda file between --@BEGIN@<x>\n and --@END are put into a
# \newcommand{\<prefix><x>}
# command. The rest is put into a \AgdaHide command.

# Usage:
# mkLagda.awk infile.agda > outfile.lagda


# Beginning of file: print header, start an \AgdaHide and a code environment

BEGIN { print "%% This file has been generated automatically by mkLagda.awk\n%% DO NOT EDIT! ALL YOUR CHANGES WILL BE LOST!\n\n\\AgdaHide{\n\\begin{code}" }

# --@PREFIX : Set the prefix

match($0, /^--@PREFIX@([^@\n]*)@?/, group) { prefix = group[1] }

# --@BEGIN  : end the code and \AgdaHide, produce \newcommand, start code

match($0, /^--@BEGIN@([^@\n]*)@?/, group) { print "\\end{code}\n} % END AgdaHide\n\n\\newcommand{\\" prefix group[1] "}{\n\\begin{code}" }

match($0, /^--@BEGIN-inline@([^@\n]*)@?/, group) { print "\\end{code}\n} % END AgdaHide\n\n\\newcommand{\\" prefix group[1] "}{\n\\begin{code}[inline]" }

# --@END    : end the code and \newcommand, start \AgdaHide and code

match($0, /^--@END@?/, group) { print "\\end{code}\n} % END newcommand\n\n\\AgdaHide{\n\\begin{code}" }

# If line starts with @HIDE-END print the line

/^--@HIDE-END/ { print $0 }
/^--@HIDE-BEG/ { print $0 }

# Otherwise: output the line as is

!/^--@/ { print $0 }

# REDUNDANT:
# # --@C  : omit the line
# match($0, /^--@C/, group) {}

# End of file: close the last code environment and the \AgdaHide

END { print "\\end{code}\n} % END AgdaHide" }

# TRASH
# EMPTY, WHY? # BEGIN { print $ARGC, $ARGV[0], $ARGV[1] }
