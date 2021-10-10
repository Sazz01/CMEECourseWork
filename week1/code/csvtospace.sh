#!/bin/bash
#Author: Sarah Dobson sld21@ic.ac.uk
#script: csvtospace
#description: changes a comma separated value (csv) file into a space separated values file 
#script does not change the input file, output is saved under a different name.
#ouput is then moved to the results folder.
#Arguments: 1 -> csv file 
#Date 6 Oct 2021

if [ $# -eq 1 ]; then



#now to remove the exenstion on the input file (if its present, will not change anything if its not)

echo "removing extension from $Var"

Var=$(basename "$1" | cut -d. -f1)


echo "Creating a space separated values file of $Var..., saving it as 'new$Var'"
sed 's/,/ /g' $Var.csv >> "new$Var".txt



#Now move the .txt file to the results folder

echo "moving" "new$Var.txt" "file to the results folder"

mv ../code/"new$Var".txt ../results/

else 

 echo "Cannot complete task. Input file is either missing or incorrectly spelled"

exit

fi




