# =============================================================================
# @file    Makefile
# @brief   Makefile for running latexdiff for SBML L3 paper
# @author  Michael Hucka
# @date    2019-12-30
#
# See the comments later below for an explanation of why various settings are
# used and why things are done the way they are.
#
# Note: when run with this makefile, the final output from pdflatex contains
# some warnings logged to the console.  They are like this:
#
#    l.1325 
#       pdfTeX warning (ext4): destination with the same identifier
#       (name{cite.Chaouiya2015sbml}) has been already used, duplicate ignored
#
#     \AtBegShi@Output ...ipout \box \AtBeginShipoutBox 
#                                                      \fi \fi
#
# I don't know why these warnings are generated, but they don't prevent
# pdflatex from finishing and producing output, and since this is just a diff
# and not the actual paper, I chose to ignore them.
# =============================================================================

# Configuration variables.
# .............................................................................

previous-main = ../old/sbml-l3-msb-paper-submission-2019/main.tex
latest-main   = ../sbml-l3-paper-final/main.tex
output-file   = diff.tex

# For the style of latexdiff differences, I actually prefer the UNDERLINE
# style of diffs (--type=UNDERLINE) and initially tried to make that work.
# Unfortunately, it turns out that latexdiff's UNDERLINE mode fails for
# citations and references: not only do you get a lot of overfull boxes due
# to citations spilling over the right margin, but in the reference section,
# you get a blob of text for the references instead of normally formatted
# references (i.e., you get a single run-on paragraph for the entire set of
# references in the paper).  Based on the documentation for latexdiff version
# 1.3.0 of October 2018, it seems there's an incompatibility between the way
# citations are generated and the way latexdiff does underlining.  So, in the
# end, I settled on using the CFONT style and adjusting the colors and font
# of the change markup.
#
# An additional thing done to make the change formatting look better is to
# use a custom sbml-paper.cls style file, and to change the hyperref
# parameters to turn off link highlighting in the text.  This avoids
# citations being colored green (which is the normal style for
# sbml-paper.cls) and IMHO makes the latexdiff output easier to read by
# reducing the number of colors on the page.  The custom sbml-paper.cls file
# is contained in this repository.
#
# Regarding the other options used here to latexdiff:
#
#   --flatten is necessary to get the bibliography to appear at the end.
# 
#   --graphics-markup=2 causes new graphics to be shown with a blue border
#   and old graphics to be shown smaller and with a red "x" through it.
#
#   The default scaling for the old graphics is 0.5.  That's too big for one
#   of our figures.  (It's a full-page figure.)  I adjusted SCALEDELGRAPHICS
#   by trial and error so that the full page figure is mostly still visible
#   even with the scaled old version of the figure above it.  Unfortunately
#   it's a global setting so it affects other figures too.  C'est la vie.
#
#   --exclude-textcmd="author" is to prevent latexdiff from putting
#   \DIFdelend (or other markup) in the middle of the arguments to \author.
#   This does not change the fact that latexdiff can't show differences in
#   the author list, but it prevents me from seeing the broken markup in the
#   main-diff.tex output file and thinking it's a source of problems.  (Turns
#   out it makes no difference in the end, but I'm leaving this here to save
#   future readers the time to figure that out.)
#
#   --append-safecmd="bibitem" is needed to prevent the appearance of "?" for
#   citations that were in the old version of the manuscript but not in the
#   new one.  Using this command causes the text to show both old and new
#   citations, with old ones cross out and new ones underlined.  Without it,
#   the old ones are shown as a crossed-out "?", which is not as helpful.
#
#   --packages is because we use a custom style (sbml-paper.cls), and it's
#   not clear to me that latexdiff scans the style file to look for other
#   package inclusions.  (It doesn't seem to make a difference after all,
#   but I'm leaving it to show that it's been tried.)

latexdiff-flags := --type=CFONT \
		   --flatten \
		   --graphics-markup=2 \
		   --config SCALEDELGRAPHICS=0.3 \
		   --exclude-textcmd="author" \
		   --append-safecmd="bibitem" \
		   --packages=xcolor,geometry,wasysym,amssymb,fourier,microtype,array,booktabs,xspace,lineno,natbib,xhfill,enumitem,varwidth,fontenc,titlesec,caption,graphicx,hyperref,rotating,authblk,wrapfig

.PHONY: default test-symlinks diff


# Commands
# .............................................................................

default: | symlinks diff

symlinks: literature.bib packages-table.tex sbml-msb.bst resources

literature.bib:
	ln -s $(dir $(latest-main))literature.bib .

packages-table.tex:
	ln -s $(dir $(latest-main))packages-table.tex .

sbml-msb.bst:
	ln -s $(dir $(latest-main))sbml-msb.bst .

resources:
	ln -s $(dir $(latest-main))resources .

# Note #1: to change the style of the markup, we have to do some manual
# editing of the output file.  Those are the sed commands below.
#
# Note #2: The weird sed bits involving DIFdell are to fix up the diff of the
# full-page multi-tabular box on p. 14, which otherwise spills over the
# right-hand and bottom of the page.  This code is hacky but it's not
# important enough to worry about doing it a better way.
diff:
	-rm -f *.aux
	latexdiff $(latexdiff-flags) $(previous-main) $(latest-main) > $(output-file)
	sed -i.bak -e 's/RED/red/g' -e 's/BLUE/blue/g' \
		   -e 's/1,0,0/1,.5,.5/g' -e 's/0,0,1/.1,0,.8/g' \
		   -e 's/\\DIFdel{Programming libraries help to }\\DIFdelend//' \
		   -e 's/\\DIFdel{is a pure-Java based implementation/\\DIFdel{/' \
		   -e 's/\\sf //g' $(output-file)
	pdflatex $(output-file)
	-bibtex $(basename $(output-file))
	pdflatex $(output-file)
	pdflatex $(output-file)
	pdflatex $(output-file)

clean:
	-rm -f $(output-file)
