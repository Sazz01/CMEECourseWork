#/bin/bash

#author: Sarah Dobson sld21@ic.ac.uk
#Script compiles latex files with bibtex files and then removes excess files
#Arguments: 1 > is the file that you want to compile into Latex
#Date 7 Oct 2021

pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
evince $1.pdf &

##Now to cleanup incompelete files 
rm *.aux
rm *.log
rm *.bbl
rm *.blg
