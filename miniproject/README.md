# Project Title: CMEE Coursework Repository Miniproject

### Brief Description: 
A compilation of files needed to create a miniproject report to be assessed as part of our final grade of CMEE Mres at Imperial College London. Guidelines for the miniproject can be found at  https://mhasoba.github.io/TheMulQuaBio/intro.html in chapter 'The Computing Miniproject'. Tutorials on how data should be analysed can be found in 'Model fitting using non-linear least squares. For my project I chose dataset 1. The project title: How well do different linear and nonlinear growth models fit to bacterial growth curves?

  


### Languages used within the project: 
**Python 3.8.10**

**R 3.6.3**

**bash version 5.0.17(1)**

**TeX 3.14159265**

### Dependencies used within the project: 
**Visual Studio Code 1.60.2**

**R Studio 2021.09.0+351**



**R package tidyverse 1.3.0**

**R package broom 0.7.10**

**R package MuMIn 1.43.17**

**R package minpack 1.2.1**


## Installation:

#### Visual Studio Code: 

Manually download .deb file from https://code.visualstudio.com/download
   
Once completed, enter the following into the terminal:
   
       cd ../path/to/the file
       install sudo dpkg -i <file>.deb 
       
#### Python:
In the bash terminal type:
       
       python3
       
You will get a new command prompt that looks like this:
  
        >>>
Now type:
  
      import this
  
#### Git: 
  
       sudo apt-get install git 
       
       
#### R: 
type the following into the linux terminal:

      sudo apt install r-base r-base-dev


#### R studio:

open the linux terminal and make sure pprerequisites are installed:

      sudo apt update
      sudo apt -y install r-base gdebi-core
      
      
download the .deb file from the offical R studio webiste https://www.rstudio.com/products/rstudio/download/#download


Use the gdebi command to install the previously downloaded package. The gdebi command will ensure that all additional prerequisites are also downloaded to fulfill the RStudio requirements: 

      sudo gdebi rstudio-1.2.5019-amd64.deb
      
launch rstudio once completed

      rstudio
      
### **R packages**

to install packages in R type the following into the R terminal:
    
    install.packages("insert_package_name_here")
    
if you want to check the package version installed, type the following into the R terminal:

    packageVersion("insert_package_name_here")
      
      

### LaTeX: 

type the following into the linux terminal:

      $sudo apt-get install texlive-full texlive-fonts-
      $recommended texlive-pictures texlive-latex-extra imagemagick
      
## Usage

Folder Composition 

**Code**: contains the scripts neccessary for the manipulation, analysing and plotting of the data

**Results**: contains tables and plots of model outputs

**Report**: contains the written report and the files neccessary to compile it into a pdf file.

**Data**: contains both all of the raw and manipulated data used wihtin the project


Brief Explanations for what each file within Code directory does:

**main.sh** - runs all the scripts in order to produce the pdf.

**Wrangle.R**: - manipulates the data ready for analysis

**model_fitting.R** - analyses the models

**Plots.R** - plots the models predicted outputs of particular datasets and plots the model diagnostics for every model in every data set.


Brief Explanations for what each file within report directory does:

**CompileLaTeX.sh** - a file that compiles the miniproject.tex and Ref.bib files together and gets rid of any extra files which were made in the process (.log and .au files)

**growthcurve.jpeg** - image of a diagram to be used in the Introduction in miniproject.tex

**miniproject.tex** - text file of the written report

**Ref.bib** - list of references for miniproject.tex







### **Author and Email: Sarah Dobson  sld21@ic.ac.uk**
