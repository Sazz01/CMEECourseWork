#!/bin/bash
#Author: Sarah Dobson sld21@ic.ac.uk
#script: csvtospace
#description: changes comma separated value (csv) files into a space separated values file.

#Saves the output as a txt file
#Arguments: 1 -> csv file; 2-> txt file with new name
#Date 6 Oct 2021

echo "Creating a space separated values file of $1..."
cat $1 | tr -s "," " " >> $2.txt
echo "Done!"
exit