#!/usr/bin/env python3

"""Some functions exemplifying the use of control statements with doc testing"""
#docstrings are considered part of the running code (normal comments are
#stripped). Hence, you can access your docstrings at run time.

__appname__ = ['test_control_flow.py']
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'

import sys
import doctest

def even_or_odd(x=0): # if not specified, x should take value 0.

    """Find whether a number x is even or odd.

    >>> even_or_odd(10)
    '10 is Even!'

    >>> even_or_odd(5)
    '5 is Odd!'

    whenever a float is provided, then the closet integer is used:
    >>> even_or_odd(-2)
    '-2 is Even!'

    """

    #Define function to be tested
    if x % 2 == 0: #The conditional if
        return "%d is Even!" % x
    return "%d is Odd!" % x

def main(argv):
    print(even_or_odd(22))
    print(even_or_odd(33))
    return 0

if (__name__ == "__main__"): #can be suppressed - dont need this bit when doctesting
    status = main(sys.argv)
   
doctest.testmod() #to run with embedded tests
