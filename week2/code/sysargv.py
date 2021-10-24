#!/usr/bin/env python3


"""The script helps us to understand what sys.argv is and how it is used """

__name__ = ['sysargv.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'

import sys
print("this is the name of the script:", sys.argv[0]) # [0] prints the name of the script used 
print("Number of arguments:", len(sys.argv)) #prints how many sys.argv are been used (1)
print("The arguments are:" , str(sys.argv)) #outright tells you what were arguements used when the script was run