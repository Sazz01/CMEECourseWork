#!/bin/bash

#Author: Sarah Dobson sld21@ic.ac.uk
#script: tiff2png.sh
#description: changes a .tiff file into a .png file 
#Saves the output as a .png file
#Arguments: f-> .tiff file 
#Date 8 Oct 2021


#check if a file has been provided
if [ $# -eq 0 ]; then 

echo "no input file provided; please provide a .tif file"

exit

else 

echo "input file provided"
fi



#now to check if a .csv file has been provided, if not, the process will end.
echo "checking if .tif file has been provided"

if [[ $1 = *.tif ]] 
then 

echo "Correct file type"
else 

echo "wrong file type"

exit

fi

#now to cpnvert .tif file to .png

for f in $1; 
    do  
        echo "Converting $f"; 
        convert "$f"  "$(basename "$f" .tif).png"; 
    done

echo "done!"

exit



