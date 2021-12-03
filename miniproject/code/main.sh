#!/bin/bash
#Author: Sarah Dobson sld21@ic.ac.uk
#Script: MyExampleScript.sh
#Description: master file which runs every other file to produce the miniproject.tex
#Arguements: none
#Date Oct 9 2021

print("Wrangling data...")
Rscript Wrangle.R
print("Wrangling done!")

print("Fitting models to each dataset...")
Rscript model_fitting.R
print("Model fitting done!")

print("Plotting to use in pdf file + checking model residuals...")
Rscript Plots.R
print("Done! Almost there!")

print("Move to the report folder")
cd ../report

print("Compile pdf")
bash CompileLaTeX.sh miniproject.tex
print("DOone!")

print("Script complete! woooohooooooooooo i am freeeeeeeee")