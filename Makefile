# =============================================================================
# @file    Makefile
# @brief   Makefile for running latexdiff for SBML L3 paper
# @author  Michael Hucka
# @date    2019-12-30
# =============================================================================

options = --type=UNDERLINE

previous-version = ../old/sbml-l3-msb-paper-submission-2019/main.tex
this-version = ../sbml-l3-paper-final/main.tex

output = diff

default: | test-symlinks diff

test-symlinks:
ifeq (,$(wildcard ./sbml-paper.cls))
	$(error You must create symbolic links for sbml-paper.cls and other files)
endif

diff:
	-rm -f *.aux
	latexdiff $(options) $(previous-version) $(this-version) > $(output).tex

latex pdf:
	-rm -f *.aux
	pdflatex $(output)
	-bibtex $(output)
	pdflatex $(output)
	pdflatex $(output)
	pdflatex $(output)

.PHONY: default test-symlinks diff latex pdf
