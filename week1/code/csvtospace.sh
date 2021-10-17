#!/bin/bash
#Author: Sarah Dobson sld21@ic.ac.uk
#script: csvtospace
#description: changes a comma separated value (csv) file into a space separated values (.txt) file.
#script does not change the input file, saves output file as $1.txt, .csv extension is removed
#ouput is then moved to the results folder.
#Arguments: 1 -> csv file 
#Date 6 Oct 2021


#First determine if the there is an input file;

if [ $# -eq 1 ]; then

echo "Input file has been provided"



#if no input file has been given, it will provide the following statment and then exit

else 

echo "Cannot complete task; either parameters are missing or incorrectly spelled. Please provide a .csv file"

exit 

fi


#now to check if a .csv file has been provided, if not, the process will end.

echo "checking if .csv file has been provided"

if [[ $1 = *.csv ]] 
then 

echo "Correct file type"
else 

echo "wrong file type"

exit

fi


#Now continuing on with the conversion...

#first convert tabs into commas in the file, turns file into .txt.cvs file

echo "swapping commas for spaces"


cat $1 | tr -s "," " " >> $1.txt


#now to take way .txt extension; 

echo "removing .txt entension"

mv "$1.txt" "${1%.csv}.txt" >> $1






##moving new .cvs file to results folder

echo "moving" "${1%.csv}.txt" "file to the results folder"

mv ${1%.csv}.txt ../results/

exit 

