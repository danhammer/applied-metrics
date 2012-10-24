ARE213: Applied Econometrics - Section Notes
======

This is a repository for ARE213 section notes, taught by Michael
Anderson at UC Berkeley.  The project is equipped to deal with R and
Clojure code.  Clojure is a functional programming language that is
well-suited for multi-threaded processing.  However, for this class,
we will deal mainly with the R code, unless someone is particularly
interested in learning this exciting new language.  To find the text
and code for this project, you'll have to navigate to the `src/r`
directory.  Each section has its own subdirectory that contains at
least three core files:

1. An org-mode document `.org` that compiles to the `.pdf`, `.tex`,
and `.R` files.  In fact, the org-mode document _is_ the code; and you
can dynamically update all downstream documents from within Emacs'
org-mode.  You do not have to interact with the org-mode document
directly if you are not using Emacs, but rather just with the R code
or PDF write-up.  If you'd like to get set up with Emacs (highly
recommended) then please see the next section of this README.

2. A PDF of the section notes, which effectively documents the code.
If you are only interested in following along, rather than running the
code yourself, just browse to the `.pdf` file for the section
(e.g. [`sec-01.pdf`](https://github.com/danhammer/applied-metrics/blob/master/src/r/section-02/sec-02.pdf))
and click "view raw".  The PDF will begin downloading immediately.

3. An R script that compiles all of the code within the PDF.  Note
that there is no documentation within the code.  Instead, the code is
documented from the PDF description.

The sections are organized as follows:

[`section-01`](https://github.com/danhammer/applied-metrics/blob/master/src/r/section-01) Summary statistics in `R`

[`section-02`](https://github.com/danhammer/applied-metrics/blob/master/src/r/section-02) SUTVA and nonparametric regression

[`section-06`](https://github.com/danhammer/applied-metrics/blob/master/src/r/section-06) Propensity Score Matching

[`section-07`](https://github.com/danhammer/applied-metrics/blob/master/src/r/section-07) Random and Fixed Effects

[`section-08`](https://github.com/danhammer/applied-metrics/blob/master/src/r/section-08) Diff-n-Diff Estimation

[`section-10`](https://github.com/danhammer/applied-metrics/blob/master/src/r/section-10) Instrumental Variables

# Help me write this!  

This project can and _should_ be treated like any other open source,
collaborative coding project.  If you are interested in helping me
make this project better, [fork the
repo](https://help.github.com/articles/fork-a-repo), edit the screwy
files, and [send a pull
request](https://help.github.com/articles/using-pull-requests).  I
will review and merge the changes -- until someone else takes over!

# Org mode notes

If you are running [Emacs](http://www.gnu.org/software/emacs), then
you have access to [org-mode](http://orgmode.org), an open source
solution for interactive coding and reproducible research.  The code,
documentation, and results are all bundled into the same file.  The
`#+RESULTS` output is automatically generated from the immediately
preceding code block.

![](http://dl.dropbox.com/u/5365589/org-mode.png)

A few things to note.  When you try to compile the `.org` files to
a PDF document, you may have to compile it twice or reload the buffer
using `C-u M-x org-reload`.  To tangle the code within the org-mode
document to an `.R` script, you can use the key binding `C-c C-v t`.

You can highlight code by using the `minted` package in LaTeX.  For
this, from the command line, make sure that you invoke `pdflatex` with
the `-shell-escape` flag.  For example,

```bash
cd ~/Dropbox/github/danhamer/applied-metrics/src/r/section-02
pdflatex -shell-escape sec-02
```

Ensure that you have the proper
[`minted.sty`](http://www.ctan.org/pkg/minted) file by downloading the
zipfile, installing it, and then ensuring that LaTeX knows where
everything is:

```bash
unzip minted.zip
cd minted/
latex minted.ins
sudo texhash
```

Finally, you will have to add the following to your `.emacs.d/init.el`
file, and make sure it doesn't conflict with anything else in there:

```lisp
(require 'org-latex)
(setq org-export-latex-listings t)
(setq org-export-latex-listings 'minted)
(add-to-list 'org-export-latex-packages-alist '("" "minted"))
(add-to-list 'org-export-latex-packages-alist '("" "color"))
(add-to-list 'org-export-latex-minted-langs '(R "r"))
```
