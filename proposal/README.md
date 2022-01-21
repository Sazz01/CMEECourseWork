# Project Title: CMEE Coursework Proposal Repository 

## Brief Description:

This repository is where scripts to make a pdf version of my research project proposal is kept.

### Languages used within the directory: 

**bash version 5.0.17(1)**


## Installation

### **LaTeX**: 

type the following into the linux terminal:

    sudo apt-get install texlive-full texlive-fonts-
    recommended texlive-pictures texlive-latex-extra imagemagick
    
### **R studio**

open linux terminal and make sure prequisittes are installed:

    sudo apt update
    sudo apt -y install r-base gdebi-core
    

## Usage:
Brief Explanations for what each file within the directory does:

**CompileLaTeX.sh** - a file that compiles the proposal.tex and Ref.bib files together into a pdf and gets rid of any extra files which were made in the process (.log and .au files)

**Gantt.png** - image of a Gantt diagram to be used in the proposal.tex

**proposal.pdf** - pdf version of the written proposal compiled from ***proposal.tex*** and ***Ref.bib***

**proposal.tex** - text file of the written proposal

**Ref.bib** - list of references proposal.tex

######**Author and Email**: Sarah Dobson  sld21@ic.ac.uk

