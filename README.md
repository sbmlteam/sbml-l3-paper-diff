SBML Level 3 paper latexdiff configuration<img width="14%" align="right" src=".graphics/sbml-badge.svg">
==========================================

This contains files used to run `latexdiff` to produce the list of differences between the final version of the SBML Level&nbsp;3 paper and the version submitted for review.

Here is the basic usage approach:

1. Clone this repository.

2. Copy a version of the original July 2019 paper into a new subdirectory, and a copy of the latest paper into another subdirectory, and edit the paths to those directories in [Makefile](Makefile).

3. Create symlinks for `*.cls`, `*.bib`, `*.bst`, and the `resources` directory of the latest version of the paper.  This is needed so that when you run `make latex` it can find these files.

4. Run `make diff`, which will run `latexdiff` and produce a file named `diff.tex`.

5. Run `make latex`, which will run `pdflatex` and create a PDF from `diff.tex`.

License
-------

Software produced by the SBML project is licensed under the [LGPL version 2.1 license](https://choosealicense.com/licenses/lgpl-2.1/).  Please see the [LICENSE](LICENSE) file for more information.

Acknowledgments
---------------

Funding for this and other SBML work has come from the [National Institute of General Medical Sciences](https://www.nigms.nih.gov) via grant NIH R01&nbsp;GM070923 (Principal Investigator: Michael Hucka).

<br>
<div align="center">
  <a href="https://www.nigms.nih.gov">
    <img valign="middle"  height="100" src=".graphics/US-NIH-NIGMS-Logo.svg">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://www.caltech.edu">
    <img valign="middle" height="130" src=".graphics/caltech-round.png">
  </a>
</div>
