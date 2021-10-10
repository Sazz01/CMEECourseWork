#!/bin/bash

#Author: Sarah Dobson sld21@ic.ac.uk
#script: tiff2png.sh
#description: changes a .tiff file into a .png file 
#Saves the output as a .png file
#Arguments: f-> .tiff file 
#Date 8 Oct 2021

for f in *.tif; 
    do  
        echo "Converting $f"; 
        convert "$f"  "$(basename "$f" .tif).png"; 
    done

     




