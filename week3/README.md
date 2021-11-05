##Project Title: CMEE Coursework Repository Week 3##


##Brief Description:##
#A compilation of code and tasks from week 3 to be assessed as part of our final grade of CMEE Mres at Imperial College London. Instructions for the coding tasks can be found at  https://mhasoba.github.io/TheMulQuaBio/intro.html in chapters 'Biological Computing with R' and 'Data Management and Visualisation'.

#Languages used within the project:# 
    R 3.6.3

#Dependencies used within the project:# 
    R Studio 2021.09.0+351
    


##Installation:## 

#How to install dependent software:#

#R# 
type the following into the linux terminal:

      sudo apt install r-base r-base-dev


#R studio#

open linux terminal and make sure prequisittes are installed:

      sudo apt update
      sudo apt -y install r-base gdebi-core
      
      
download the .deb file from the offical R studio webiste https://www.rstudio.com/products/rstudio/download/#download


Use the gdebi command to install the previously downloaded package. The gdebi command will ensure that all additional prerequisites are also downloaded to fulfil the RStudio requirements: 

      sudo gdebi rstudio-1.2.5019-amd64.deb
      
launch rstudio once completed

      rstudio
      
      
##Usage:##

Brief Explanations for each file Within Code directory does:


apply1.R: Demonstrates how to use the apply function

apply2.R: Demonstartes how to define our own function using apply

basic_io.R: illustrates R file inputs and outputs

boilerplate.R: A boiler plate R script

break.R: Illustrates how to break out of loops in R

browse.R: demonstrates how browser() can be used to detect errors in code

control_flow.R: illustrates control flow loops in R

DataWrang.R: demonstrates how to manage and transform data using base R and reshape package

DataWrangTidy.R: demonstrates how to manage and transform data using tidyverse packages

Florida_warming.R: calculating the correlation coefficient of Year and Annual Temperature in Florida and testing its significance

Florida_warming.tex: a file detailing and discussing the results from Florida_warming.R, which will be compiled into a pdf file.

Girko.R: This script creates a dataframe and combines the commands for plotting the results of a simulation displaying Girko's Circular Law

GPDD_Data.R: demonstrates how to create a world map and superimpose data on the map

MyBars.R: This script demonstrates how to annotate plots with geom_text()

next.R: Illustrates how to skip to the next iteration of a loop

plotLin.R: This script demonstrates mathematical annotation of an axis as well as within the plot area and combines all the commands for annotating a linear regression plot 

PP_Dists.R: This script plots histograms of data, and calculates the mean and median of different subsets of data

PP_regress.R: this script plots calculates the regression results of subsets of data 

preallocate.R: demonstrates how preallocating vectors reduces processing time.

R_conditionals.R: this script demonstrates examples of conditional functions in R

Ricker.R: illustrates modelling the ricker model in R.

sample.R: illustrating the use of lapply and sapply through various functions, we then compare the time taken between functions with loops and sapply/lappy.

TreeHeight.R: #This script uses a function to create new column of data and add it into a pre-exisitng dataframe as a new column.

try.R: demonstrates how try() continues running scripts with error messages, which can be used to figure out errors.

Vectorise1.R: this script demonstrates how vectorizing functions can reduce the time taken to do the function

Vectorise2.R: illustrates how to vectorise the stochastic ricker equation model in R.




Author and Email: Sarah Dobson  sld21@ic.ac.uk
















