#!/bin/bash
#Author: Sarah Dobson sld21@ic.ac.uk
#Script: tabtocsv.sh
#Description: subsitute the tabs in the files with commas
#
#Saves the output into a .csv file
#Arguements: 1 -> tab delimited file
echo "Creating a comma delimited version of $1..."
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"
exit