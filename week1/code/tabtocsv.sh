#!/bin/bash
#Author: Sarah Dobson sld21@ic.ac.uk
#Script: tabtocsv.sh
#Description: subsitute the tabs in the files with commas
##script does not change the input file, saves output file as $1.csv, old extension is removed
#Moves .csv file into the results folder
#Arguements: 1 -> tab delimited file; 
#Date 8 Oct 2021


#First determine if the there is an input file;

if [ $# -eq 1 ]; then

echo "Input file has been provided"

#first convert tabs into commas in the file, turns file into .oldextension.cvs file

echo "swapping tabs for commas"

cat $1 | tr -s "\t" "," >> $1.csv

#now to take way the old extension; 

echo "removing .txt entension"

mv "$1.csv" "${1%.*}.csv" >> $1 


#moving new .cvs file to results folder

echo "moving" "${1%.*}.csv" "file to the results folder"

mv ${1%.*}.csv ../results/


echo "done!"


#if no input file has been given, it will provide the following statment and then exit
else

  echo "Cannot complete task. Input file is either missing or written incorrectly; please provide a .txt file"
  exit



fi

