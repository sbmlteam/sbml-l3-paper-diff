Michael Hucka
2019-12-30

How this was produced:

1. Create this directory.

2. Create symlinks for *.cls, *.bib, *.bst, resources to the current version
   of the paper.  This is needed so that when you run "make latex", latex
   can find these files.

3. Run "make diff", which will run latexdiff and produces diff.tex.

4. Run "make latex", which will run pdflatex and create a PDF of diff.tex.

