# Denver R User Group Meetup: 23 April 2019

Slides and Examples for:

**knitr::spin -- A more dynamic approach to dynamic documents**

Building dynamic documents via literate programming is a critical part of
responsible and reproducible science. Built on a literature programming
framework, authoring .Rmd, .Rnw, .Rhtml, or other files, uses a markup language
(markdown, LaTeX, html, ...) as the primary language for the file and the
analysis/programming language (R, C++, SAS, ...) is a guest language. This
paradigm has been extremely useful and durable since its formal introduction in
the book "Literate Programming" Donald Knuth in 1984. R users should be at least
aware of Sweave and knitr::knit, two R focused literate programming tools.

However, the common method of literate programming is, from the perspective of
an analysis, backwards. As an analysis my primary language is the analysis
language and the human readable report is nothing more than detailed code
comments about the analysis script(s). knitr::spin is the tool needed to use
literate programming paradigms where the analysis language is the primary
language for the file(s) and the markup language is the guest language.

This talk will cover the following:

1. Introduction to knitr::spin -- concept and syntax
2. Simple reports -- that is analysis.R --> analysis.(docx|html|pdf)
3. Non-trivial reports -- child documents and conditional code evaluation

https://www.meetup.com/DenverRUG/events/260632409/


## Cloning this repo

The package structure relies on symbolic links.  If you are working on Linux or
Mac the you should have not problem cloning and working with this repo.  If,
however, you are working on a Windows machine there are a few additional steps
you will need to take.

1. Windows Vista or newer with NTFS file system, not FAT.
2. You need administrator rights or at least `SeCreateSymbolicLinkPrivilege`
   privilege
3. git bash version 2.10.2 or later.  It will be helpful to install with
   `core.symlinks` option turned on.

In the git bash shell clone the repo.  (The example below uses SSH, change the
URL as needed for https.)

    git clone -c core.symlinks=true git@github.com:dewittpe/ensr.git
