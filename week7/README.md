# Project Title: CMEE Coursework Repository Week 7

### Brief Description: 
A compilation of code and tasks from week 7 to be assessed as part of our final grade of CMEE Mres at Imperial College London. Instructions for the coding tasks can be found at https://mhasoba.github.io/TheMulQuaBio/intro.html in chapters *'Biological Computing with Python II'* and *'Introduction to Jupyter'*.

### Languages used within the project: 
**Python 3.8.10** 

**R 3.6.3**

### Dependencies used within the project: 
**Visual Studio Code 1.60.2** 

**Git 2.25.1**

**R Studio 2021.09.0+351**

**jupyter notebook 6.4.6**


## How to install dependent software:

#### Visual Studio Code: 

Manually download .deb file from https://code.visualstudio.com/download
   
Once completed, enter the following into the terminal:
   
       cd ../path/to/the file
       install sudo dpkg -i <file>.deb 
       
### Python:
In the bash terminal type:
       
       python3
       
You will get a new command prompt that looks like this:
  
        >>>
Now type:
  
      import this
  
### Git: 
  
       sudo apt-get install git 
       
       
### R: 
type the following into the linux terminal:

      sudo apt install r-base r-base-dev


#### R studio:

open linux terminal and make sure prerequisites are installed:

      sudo apt update
      sudo apt -y install r-base gdebi-core
      
      
download the .deb file from the offical R studio webiste https://www.rstudio.com/products/rstudio/download/#download


Use the gdebi command to install the previously downloaded package. The gdebi command will ensure that all additional prerequisites are also downloaded to fulfill the RStudio requirements: 

      sudo gdebi rstudio-1.2.5019-amd64.deb
      
launch rstudio once completed:

      rstudio
      
#### jupyter notebook:

follow the instructions for downloading jupyter notebook here: https://jupyter.readthedocs.io/en/latest/install.html

#### jupter notebook kernels:
follow the instructions for installing the python and R kernels here: https://imperial-fons-computing.github.io/jupyter.html



## Usage  

#### Brief Explanations for what each file within Code directory does:


**LV1.py**: This script demonstrates how to do numerical integration in python using the scipy package

**MyFirstJupyterNotebook.ipynb**: running python and R commands with Jupyter notebook.

**oaks_debugme.py**: This script finds taxa in a list of tree species that are oak trees, and saves them to a new csv file. The script has been improved and made more robust.

**profileme.py**: This script demosntrates how to find out what is slowing down your code via “profiling”

**profileme2.py**: A continuation of profileme.py but with improved code

**TestR.R**: rscript saying "Hello! This is R"

**TestR.py**: deomstrates how to run R scripts using pythong using rscript 'TestR.R'.

**timeitme.py**: This script compares the functions from profileme.py and profileme2.py and determines which one is faster.




### **Author and Email**: Sarah Dobson  sld21@ic.ac.uk

