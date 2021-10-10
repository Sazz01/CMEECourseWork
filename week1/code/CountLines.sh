#!/bin/bash

#author: Sarah Dobson sld21@ic.ac.uk
#script: CountLines.sh
#description: script counts the number of lines wihtin the file
#arguments: 1 -> file with lines to be counted
#date: 7 Oct 2021

echo "Counting the number of lines within the file"

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"


exit