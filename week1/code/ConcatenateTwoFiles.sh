#!/bin/bash

#Author: Sarah Dobson sld21@ic.ac.uk
#script: ConcatenateTwoFiles.sh
#description: merges two files together into a new file,  
#new file is then moved to results folder
#Arguments: 1 -> first file to be merged; 2-> second file to be merged;
#3-> name of new merged file
#Date 8 Oct 2021

if [ $# -eq 3 ]; then
 
cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3

#Now move the pdf file to the results folder

echo "moving" $3 "file to the results folder"

mv ../code/$3 ../results/

exit

else

 echo "Incorrect input; input files either missing or incorrectly spelled. Please provide 3 input files in the format: 1st input file, 2nd input file, name for merged file"

exit

fi




