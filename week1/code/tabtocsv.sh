#!/bin/bash
#Author: Sarah Dobson sld21@ic.ac.uk
#Script: tabtocsv.sh
#Description: subsitute the tabs in the files with commas
#Saves the output into a .csv file
#Moves.csv file into the results folder
#Arguements: 1 -> tab delimited file; Var -> 1 with the extension removed
#Date 8 Oct 2021


if [ $# -eq 1 ]; then

#now to remove the exenstion on the input file (if its present, will not change anything if its not)

echo "removing extension from $Var"

Var=$(basename "$1" | cut -d. -f1)

#now to convert the file into a .csv file

echo "Creating a comma delimited version of $Var..."
cat $Var | tr -s "\t" "," >> $Var.csv
echo "Done!"

#Now move the csv file to the results folder

echo "moving" $Var.csv "file to the results folder"

mv $Var.csv ../results/

exit


else

  echo "Cannot complete task. Input file is either missing or written incorrectly"
  exit



fi

