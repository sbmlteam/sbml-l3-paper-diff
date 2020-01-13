# =============================================================================
# @file    Makefile
# @brief   Makefile for running latexdiff for SBML L3 paper
# @author  Michael Hucka
# @date    2019-12-30
# =============================================================================

# Configuration variables.
# .............................................................................

previous-main = ../old/sbml-l3-msb-paper-submission-2019/main.tex
latest-main   = ../sbml-l3-paper-final/main.tex

# The following naming pattern is what latexdiff-vc automatically uses (with
# no control over it).  This variable is only defined in this makefile so
# that we can run pdflatex one more time on the output of latexdiff-vc.
output-main   = $(latest-main:.tex=)-diff.tex

# Even though we don't use its git/version control features, it's still more
# convenient for us to use latexdiff-vc instead of latexdiff because the
# --pdf option causes latexdiff-vc to run pdflatex & bibtex to produce a PDF
# output --all in one go.
#
# Regarding the options used here to latexdiff-vc:
#
#   --flatten is necessary to get the bibliography to appear at the end.
#
#   --force is just a convenience, to keep latexdiff-vc from stopping and
#   asking about overwriting the output file.
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

latexdiff-flags := -c latexdiff.conf \
                   --type=CFONT \
		   --pdf \
		   --flatten \
		   --force \
		   --graphics-markup=2 \
		   --config SCALEDELGRAPHICS=0.3 \
		   --exclude-textcmd="author" \
		   --append-safecmd="bibitem" \
		   --packages=xcolor,geometry,wasysym,amssymb,fourier,microtype,array,booktabs,xspace,lineno,natbib,xhfill,enumitem,varwidth,fontenc,titlesec,caption,graphicx,hyperref,rotating,authblk,wrapfig

.PHONY: default test-symlinks diff


# Commands
# .............................................................................

default: | test-symlinks diff

test-symlinks:
ifeq (,$(wildcard ./sbml-paper.cls))
	$(error You must create symbolic links for sbml-paper.cls and other files)
endif

# Note #1: latexdiff-vc puts the output in the same directory as the "new"
# input file, with no way to control that.  Here we copy it manually to the
# local directory after it's done.
#
# Note #2: to change the style of the markup, we have to do some manual
# editing of the output file.
#
# Note #3: latexdiff-vc only runs pdflatex 2 times after running bibtex,
# whereas we need to run it 3 times so that line numbers get updated -- thus
# the extra pdflatex invocation below.
#
# Note #4: The weird sed bits involving DIFdell are to fix up the diff of the
# full-page multi-tabular box on p. 14, which otherwise spills over the
# right-hand and bottom of the page.  This code is hacky but it's not
# important enough to worry about doing it a better way.
diff:
	-rm -f *.aux
	latexdiff-vc $(latexdiff-flags) $(previous-main) $(latest-main)
	mv $(output-main) .
	sed -i.bak -e 's/RED/red/g' -e 's/BLUE/blue/g' \
		   -e 's/1,0,0/1,.4,.4/g' -e 's/0,0,1/.1,0,.7/g' \
		   -e 's/\\DIFdel{Programming libraries help to }\\DIFdelend//' \
		   -e 's/\\DIFdel{is a pure-Java based implementation/\\DIFdel{/' \
		   -e 's/\\sf //g' $(notdir $(output-main))
	pdflatex $(notdir $(output-main))
