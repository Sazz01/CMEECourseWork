#/bin/bash

#author: Sarah Dobson sld21@ic.ac.uk
#script: CompileLaTeX.sh
#description: script converts latex files into pdfs by compiling latex files with bibtex files, removes excess files and then moves the pdf file to the results folder
#Arguments: 1 ->  file with extension; Var -> file with exentsion removed
#Date 7 Oct 2021



if [ $# -eq 1 ]; then

#now to remove the exenstion on the file being turned into a pdf (if its present, will not change anything if its not)

echo "removing extension from $Var"

Var=$(basename "$1" | cut -d. -f1)



#converting file to pdf format

echo "converting $Var to pdf "

pdflatex $Var.tex
bibtex $Var
pdflatex $Var.tex
pdflatex $Var.tex



##Now to cleanup incompelete files 
rm *.aux
rm *.log
rm *.bbl
rm *.blg


#Now move the pdf file to the results folder

echo "moving" $Var.pdf "file to the results folder"


mv ../code/$Var.pdf ../results/

#Opening pdf file

echo "opening pdf file"

evince ../results/$Var.pdf&

exit

else

 echo "Cannot complete task. Input file is either missing or incorrectly spelled"

exit

fi
