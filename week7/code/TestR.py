#!/usr/bin/env python3

"""This script demonstrates how python can be used to build an automated data analysis or simulation workflow that involves multiple languages. Here we use this script to run r script TestR.R . Saves output and any error messages into two separate files in the resultd
section. Also demonstrates what occurs when a non existant file is used"""

__appname__ = ['TestR.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'

import subprocess
subprocess.Popen("Rscript --verbose TestR.R > ../results/TestR.Rout 2> ../results/TestR_errFile.Rout", shell=True).wait()
subprocess.Popen("Rscript --verbose NonExistScript.R > ../results/outputFile.Rout 2> ../results/errorFile.Rout", shell=True).wait()