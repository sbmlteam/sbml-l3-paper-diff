SBML Level 3 paper latexdiff configuration
==========================================

This contains files used to run `latexdiff` to produce the list of differences between the final version of the SBML Level&nbsp;3 paper and the version submitted for review.

Here is the basic usage approach:

1. Clone this repository.

2. Copy a version of the original July 2019 paper into a new subdirectory, and a copy of the latest paper into another subdirectory, and edit the paths to those directories in [Makefile](Makefile).

3. Create symlinks for `*.cls`, `*.bib`, `*.bst`, and the `resources` directory of the latest version of the paper.  This is needed so that when you run `make latex` it can find these files.

4. Run `make diff`, which will run `latexdiff` and produce a file named `diff.tex`.

5. Run `make latex`, which will run `pdflatex` and create a PDF from `diff.tex`.
