#############################################################
#                                                           #
#             Begin Configuration                           #
#                                                           #
#############################################################

# directory containing the main latex files:

mainLatexFileDir = mainLatexFiles

# directory containing your agda files
mainAgdaDir = agda

# auxiliary directory containing generated lagda files
generatedLagdaDir = generatedLagda

# auxiliary directory containing intermediate latex-before-sed files
# NOTE: needs to be defined relative to the current directory

generatedAgdaLatexBeforeSedFileDir = agdaLatex-before-sed

# directory where the generated latex files will be moved
generatedAgdaLatexFileDir = agdaLatex

# This script allows to create the latex files from agda file
# and run latex on two different main latex file
# the default one is
# mainLatexFile1
#
# and to run the script you execute
#
# make
#
# The second main latex file is called
#
# mainLatexFile2
#
# and to run latex on it (including creation of latex from agda files)
# you execute
#
# make default2
#

# first main latex file

mainLatexFile1 = exampleMainLatexFile1

# second main latex file (the file is called main2.tex)

mainLatexFile2 = exampleMainLatexFile2

# whether to run bibtex on mainLatexFile1

bibtexMainLatexFile1 = true

# whether to run bibtex on mainLatexFile2

bibtexMainLatexFile2 = false

# normalLatexFiles
# defines all latex files not created from agda, which
# your current latex file depends on
#
# they are only needed to make sure that when any of those files
#   changes latex is rerun
#
# The example includes all .tex files in the current directory

normalLatexfiles = $(shell find $(mainLatexFileDir) -name '*.tex')
normalBibtexfiles = $(shell find $(mainLatexFileDir) -name '*.bib')


# neededAgdaFiles are those files in the directory agda
#  for which we want to generate a latex file which is used in
#  the main latex file
#
#  files where an agda file depends on which is not used for latex
#  don't need to be included
#

neededAgdaFiles= example.agda \
        example2.agda

#############################################################
#                                                           #
#             End of Configuration                          #
#                                                           #
#############################################################

# File name Convention
# agdaFiles            refers to files in directory agda
# lagdaFiles           refers to files in directory lagda
# latexBeforeSedFiles  refers to files in directory latex-before-sed
# agdaLatexFiles       refers to files in directory latex
#                      (note not: latexFiles, in order to avoid with general
#                       latex files)
# existing..           are files which existed already
# normalLatexFiles     are files which are non-generated latex files

neededAgdaStyle = $(generatedAgdaLatexFileDir)/agda.sty

generatedAgdaStyle = $(generatedAgdaLatexBeforeSedFileDir)/agda.sty

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2)

current_dir = $(shell pwd)

existingLibraryFiles := $(shell find $(mainAgdaDir) -name '*.agda-lib')

existingAgdaFiles := $(shell find $(mainAgdaDir) -name '*.agda')

existingLagdaFiles := $(shell find $(generatedLagdaDir) -name '*.lagda')

existingLatexBeforeSedFiles := $(shell find $(generatedAgdaLatexBeforeSedFileDir) -name '*.tex')

existingAgdaLatexFiles := $(shell find $(generatedAgdaLatexFileDir) -name '*.tex')

existingAgdaiFiles = $(shell find $(mainAgdaDir) -name '*.agdai')  $(shell find $(generatedLagdaDir) -name '*.agdai')


# normalLatexfiles  are the latex files which are not generated from agda files
#  used for latex the main document



# directories needed for make process:
#
# directories where there was agda code
#     including subdirectories
# directories with generated latex files
#     including subdirectories
# latex-before-sed
#     including subdirectories
# files where we put the lagda files
#   (e.g. lagda\AgdaCode
#     including subdirectories


directories=    $(generatedAgdaLatexFileDir) \
        $(generatedAgdaLatexBeforeSedFileDir) \
        $(generatedLagdaDir)

#   (including the subdirectories of
#    latex   latex-before-sed lagda
#   and add as well the directories manually




#  neededLagdaFiles we take all existing, since easy to generate
#     and they might be needed since the really needed ones depend on
#     the not really needed one when running agda.

neededLagdaLibraryFiles = $(patsubst $(mainAgdaDir)/%,$(generatedLagdaDir)/%,$(existingLibraryFiles))

neededLagdaFiles= \
  $(patsubst $(mainAgdaDir)/%.agda,$(generatedLagdaDir)/%.lagda,$(existingAgdaFiles))


#  the needed latexBeforeSedFiles are only the needed ones
#   since these are the ones where we run agda on
#   and which once transferred into latex/*.tex files are
#   then called by latex

neededLatexBeforeSedFiles= \
  $(patsubst %.agda,$(generatedAgdaLatexBeforeSedFileDir)/%.tex,$(neededAgdaFiles)) \

neededAgdaLatexFiles= \
  $(patsubst %.agda,$(generatedAgdaLatexFileDir)/%.tex,$(neededAgdaFiles)) #\

generatedLatexFiles = $(mainLatexFileDir)/$(mainLatexFile1).out \
        $(mainLatexFileDir)/$(mainLatexFile1)x.pdf \
        $(mainLatexFileDir)/$(mainLatexFile1).pdf \
        $(mainLatexFileDir)/$(mainLatexFile1).log  \
        $(mainLatexFileDir)/$(mainLatexFile1).aux \
        $(mainLatexFileDir)/$(mainLatexFile1).aux.bak \
        $(mainLatexFileDir)/$(mainLatexFile1).bbl \
        $(mainLatexFileDir)/$(mainLatexFile1).blg \
        $(mainLatexFileDir)/$(mainLatexFile1).ptb \
        $(mainLatexFileDir)/$(mainLatexFile1)_aux \
        $(mainLatexFileDir)/$(mainLatexFile2).out \
        $(mainLatexFileDir)/$(mainLatexFile2)x.pdf \
        $(mainLatexFileDir)/$(mainLatexFile2).pdf \
        $(mainLatexFileDir)/$(mainLatexFile2).log  \
        $(mainLatexFileDir)/$(mainLatexFile2).aux \
        $(mainLatexFileDir)/$(mainLatexFile2).aux.bak \
        $(mainLatexFileDir)/$(mainLatexFile2).bbl\
        $(mainLatexFileDir)/$(mainLatexFile2).blg \
        $(mainLatexFileDir)/$(mainLatexFile2).ptb \
        $(mainLatexFileDir)/$(mainLatexFile2)_aux


pdflatex=pdflatex -shell-escape -halt-on-error
bibtex=bibtex


sedfile=postprocess.sed


mainlatexfiles=$(wildcard $(mainLatexFileDir)/$(mainLatexFile1)*.tex)

files=postprocess.sed postprocessAuxFile.sed \
        $(normalLatexfiles) $(neededAgdaLatexFiles) $(normalBibtexfiles)

# allfiles=$(mainLatexFileDir)/$(mainLatexFile1).tex $(files)

default : $(directories) $(neededLagdaFiles) $(neededLatexBeforeSedFiles) $(neededAgdaLatexFiles)\
        $(mainLatexFileDir)/$(mainLatexFile1).pdf \
        $(mainLatexFileDir)/$(mainLatexFile1)x.pdf \
#       evince $(mainLatexFile1)x.pdf &


default2 : $(directories) $(neededLagdaFiles) $(neededLatexBeforeSedFiles) $(neededAgdaLatexFiles)\
        $(mainLatexFileDir)/$(mainLatexFile2).pdf \
        $(mainLatexFileDir)/$(mainLatexFile2)x.pdf \


all : $(directories) $(neededLagdaFiles) $(neededLatexBeforeSedFiles)  $(neededAgdaLatexFiles) \
        $(mainLatexFileDir)/$(mainLatexFile1).pdf \
        $(mainLatexFileDir)/$(mainLatexFile1)x.pdf

mainLatexFile2: $(directories) $(neededLagdaFiles) $(neededLatexBeforeSedFiles)  $(neededAgdaLatexFiles)\
        $(mainLatexFileDir)/$(mainLatexFile2).pdf \
        $(mainLatexFileDir)/$(mainLatexFile2)x.pdf


#################################################################
#
# $(mainLatexFile1)
#
#
##################################################################

# initially, run latex once to create an .aux file
# mark .aux file as fresh by creating a stamp _aux
# note: -shell-escape essential for minted syntax highlighting




# $(generatedAgdaLatexFileDir)/%.tex : %.lagda
#	agda -i. -i$(agda_stdlib) --latex --latex-dir=$(generatedAgdaLatexFileDir) $
#	sed -i.bak --file=$(sedfile) $@



# Phase 1.1: Create directories

$(directories) : % :
	echo "Phase 1.1 : create Directories"
	mkdir -p $*


# Phase 1.2: Create .lagda files from .agda files

$(neededLagdaLibraryFiles) : $(generatedLagdaDir)/% : $(mainAgdaDir)/%
	echo "Phase 1.2 :  create $(generatedLagdaDir)/*.agda-lib files"
	cp $(mainAgdaDir)/*.agda-lib $(generatedLagdaDir)/

# Phase 1.3: Create .lagda files from .agda files

$(neededLagdaFiles) : $(generatedLagdaDir)/%.lagda : $(mainAgdaDir)/%.agda $(neededLagdaLibraryFiles) mkLagda.awk
	echo "Phase 1.3 :  create lagda files"
	./mkLagda.awk $< > $@




# Phase 1.4: Create latex-before-sed files from .lagda files

$(neededLatexBeforeSedFiles) : $(generatedAgdaLatexBeforeSedFileDir)/%.tex : $(generatedLagdaDir)/%.lagda
	echo "Phase 1.4 create latex-before-sed files"
	cd $(current_dir)
	cd $(mainAgdaDir)/; agda $(patsubst $(generatedLagdaDir)/%.lagda,./%.agda,$<)
	cd $(current_dir)
	cd $(generatedLagdaDir)/; agda --latex --only-scope-checking --latex-dir=$(current_dir)/$(generatedAgdaLatexBeforeSedFileDir)/ $(patsubst $(generatedLagdaDir)/%.lagda,./%.lagda,$<)


# Phase 1.5: Create .tex files from latex-before-sed files

$(neededAgdaLatexFiles) : $(generatedAgdaLatexFileDir)/%.tex : $(generatedAgdaLatexBeforeSedFileDir)/%.tex $(sedfile)
	echo "Phase 1.5 create agda latex files"
	sed --file=$(sedfile) < $< > $@

# Phase 1.6: Copy agda.sty file to normalLatexfiles
#            only done if non-existing since people
#            might want to stick to their own agda.sty filex
$(neededAgdaStyle) :
	echo "Phase 1.6 : Copy agda.sty file to normalLatexfiles"
	cp $(generatedAgdaStyle) $(neededAgdaStyle)


# Phase 2.1: update aux file then run pdflatex; this needs to be done
#          before running bibtex.
$(mainLatexFileDir)/$(mainLatexFile1)_aux : $(mainLatexFileDir)/$(mainLatexFile1).tex $(files) $(neededAgdaStyle)
	echo "Phase 2.1 : run latex before running bibtex"
	if [ -f $(mainLatexFileDir)/$(mainLatexFile1).aux ] ; then  sed -i.bak --file postprocessAuxFile.sed $(mainLatexFileDir)/$(mainLatexFile1).aux ; fi
	cd $(mainLatexFileDir); $(pdflatex) $(mainLatexFile1).tex
	sed -i.bak --file postprocessAuxFile.sed $(mainLatexFileDir)/$(mainLatexFile1).aux
	touch $@



# Phase 2.2
# finish by running latex twice again
# this will update .aux, but leave the stamp _aux intact
# (otherwise we would not converge and make would never
# return a "Nothing to do")


$(mainLatexFileDir)/$(mainLatexFile1).pdf : $(files) $(mainLatexFileDir)/$(mainLatexFile1)_aux
	echo "Phase 2.2 run bibtex then pdflatex twice"
	if $(bibtexMainLatexFile1); then cd $(mainLatexFileDir); $(bibtex) $(mainLatexFile1); fi
	cd $(mainLatexFileDir); if [ -f $(mainLatexFile1).aux ] ; then  sed -i.bak --file ../postprocessAuxFile.sed $(mainLatexFile1).aux ; fi
	cd $(mainLatexFileDir); $(pdflatex) $(mainLatexFile1).tex
	cd $(mainLatexFileDir); $(pdflatex) $(mainLatexFile1).tex
	cd $(mainLatexFileDir); sed -i.bak --file ../postprocessAuxFile.sed $(mainLatexFile1).aux

# Phase 2.3: Create $(mainLatexFileDir)/$(mainLatexFile1)x.pdf
$(mainLatexFileDir)/$(mainLatexFile1)x.pdf : $(mainLatexFileDir)/$(mainLatexFile1).pdf $(files)
	echo "Phase 2.3 copy $(mainLatexFileDir)/$(mainLatexFile1).pdf to $(mainLatexFileDir)/$(mainLatexFile1)x.pdf"
	cp $(mainLatexFileDir)/$(mainLatexFile1).pdf $(mainLatexFileDir)/$(mainLatexFile1)x.pdf

# Phase 2.1: update aux file then run pdflatex; this needs to be done
#          before running bibtex.
$(mainLatexFileDir)/$(mainLatexFile2)_aux : $(mainLatexFileDir)/$(mainLatexFile2).tex $(files)
	echo "Phase 2.1 : run latex before running bibtex"
	if [ -f $(mainLatexFileDir)/$(mainLatexFile2).aux ] ; then  sed -i.bak --file postprocessAuxFile.sed $(mainLatexFileDir)/$(mainLatexFile2).aux ; fi
	cd $(mainLatexFileDir); $(pdflatex) $(mainLatexFile2).tex
	sed -i.bak --file postprocessAuxFile.sed $(mainLatexFileDir)/$(mainLatexFile2).aux
	touch $@



# Phase 2.2
# finish by running latex twice again
# this will update .aux, but leave the stamp _aux intact
# (otherwise we would not converge and make would never
# return a "Nothing to do")


$(mainLatexFileDir)/$(mainLatexFile2).pdf : $(files) $(mainLatexFileDir)/$(mainLatexFile2)_aux
	echo "Phase 2.2 run bibtex then pdflatex twice"
	if $(bibtexMainLatexFile1); then cd $(mainLatexFileDir); $(bibtex) $(mainLatexFile1); fi
	cd $(mainLatexFileDir); if [ -f $(mainLatexFile2).aux ] ; then  sed -i.bak --file ../postprocessAuxFile.sed $(mainLatexFile2).aux ; fi
	cd $(mainLatexFileDir); $(pdflatex) $(mainLatexFile2).tex
	cd $(mainLatexFileDir); $(pdflatex) $(mainLatexFile2).tex
	cd $(mainLatexFileDir); sed -i.bak --file ../postprocessAuxFile.sed $(mainLatexFile2).aux

# Phase 2.3: Create $(mainLatexFileDir)/$(mainLatexFile2)x.pdf
$(mainLatexFileDir)/$(mainLatexFile2)x.pdf : $(mainLatexFileDir)/$(mainLatexFile2).pdf $(files)
	echo "Phase 2.3 copy $(mainLatexFileDir)/$(mainLatexFile2).pdf to $(mainLatexFileDir)/$(mainLatexFile2)x.pdf"
	cp $(mainLatexFileDir)/$(mainLatexFile2).pdf $(mainLatexFileDir)/$(mainLatexFile2)x.pdf








##########################################
##
##   Clean up
##
##########################################

softcleanmalonzo :
	/bin/rm -f $(mainAgdaDir)/MAlonzo/Code/*.hi $(mainAgdaDir)/MAlonzo/Code/*.hs $(mainAgdaDir)/MAlonzo/Code/*.o

softclean :
	rm -f $(existingLagdaFiles)
	rm -f $(existingLatexBeforeSedFiles)
	rm -f $(existingAgdaLatexFiles)
	rm -f $(existingAgdaiFiles)
	rm -f $(generatedLatexFiles)
	rm -f $(neededLagdaFiles)
	rm -f $(neededLagdaLibraryFiles)


clean : softclean

weakclean :
	rm -f $(mainLatexFileDir)/$(mainLatexFile1).pdf
	rm -f $(mainLatexFileDir)/$(mainLatexFile2).pdf




##########################################
#
# For testing the make file
#
###########################################
# test code which can be changed for exploring the Make file

forceLatexBeforeSedTest : $(generatedAgdaLatexBeforeSedFileDir)/test.tex

test:
	echo 'existingAgdaLatexFiles'
	echo $(existingAgdaLatexFiles)
	echo
	echo 'generatedLatexFiles'
	echo $(generatedLatexFiles)
	echo
	echo existingAgdaiFiles
	echo $(existingAgdaiFiles)
	echo
	echo
	echo mainlatexfiles
	echo $(mainlatexfiles)

##########################################
#
# Show functions
#
###########################################

showneededLagdaFiles :
	echo  $(neededLagdaFiles)

showneededLatexBeforeSedFiles :
	echo $(neededLatexBeforeSedFiles)

showcurrent_dir :
	echo $(current_dir)

shownormalLatexfiles :
	echo $(normalLatexfiles)

showexistingAgdaLatexFiles :
	echo $(existingAgdaLatexFiles)

showgeneratedLatexFiles :
	echo $(generatedLatexFiles)

showexistingAgdaiFiles :
	echo $(existingAgdaiFiles)

showneededAgdaFiles:
	echo $(neededAgdaFiles)


showexistingAgdaFiles :
	echo $(existingAgdaFiles)

showexistingLagdaFiles :
	echo $(existingLagdaFiles)

showdirectories :
	echo $(directories)
showfiles :
	echo $(files)
showexistingLatexBeforeSedFiles :
	echo $(existingLatexBeforeSedFiles)
showneededAgdaLatexFiles :
	echo $(neededAgdaLatexFiles)
showExistingLibraryFiles :
	echo $(existingLibraryFiles)
showNeededLagdaLibraryFiles :
	echo $(neededLagdaLibraryFiles)
showLatexFileaux :
	echo $(mainLatexFileDir)/$(mainLatexFile1)_aux
	echo $(mainLatexFileDir)/$(mainLatexFile2)_aux
showneededLagdaLibraryFiles :
	echo $(neededLagdaLibraryFiles)
# EOF
