#!/bin/bash

#author: Sarah Dobson sld21@ic.ac.uk
#script: CountLines.sh
#description: script counts the number of lines wihtin the file
#arguments: 1 -> file with lines to be counted
#date: 7 Oct 2021


#checking if input file has been provided

if [ $# -eq 1 ]; then

echo "Input file has been provided"


#if no input file has been given, it will provide the following statment and then exit

else 

echo "Cannot complete task; either parameters are missing or incorrectly spelled. Please provide a .csv file"

exit 

fi

#Counting the number of lines in the file
echo "Counting the number of lines within the file"

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"


exit