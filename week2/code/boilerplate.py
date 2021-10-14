#!/usr/bin/env python3

"""Program Description: Prints 'this is a boiler plate'"""

__appname__ = '[boilerplate.py]'
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = ""

##imports##

import sys  #module to interface our program with the operating system

##constants##

##functions##

def main(argv): #argv - like $1 in bash, will be the file name you input, in this case it is to print the sentenc below
    """Main entry point of the programme"""
    print('This is a boiler plate') # NOTE: indented using two tabs or 4 spaces 
    return 0 #0 is code for a successful run


if __name__ == "__main__":
    """Makes sure the main function is called from command line"""
    status = main(sys.argv)
    sys.exit(status)


