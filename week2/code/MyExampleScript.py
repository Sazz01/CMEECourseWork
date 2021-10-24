#!/usr/bin/env python3

"""This script shows how to write a python script and run it"""

#docstrings are considered part of the running code (normal comments are
#stripped). Hence, you can access your docstrings at run time.

__appname__ = ['MyExampleScript.py']
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'


def foo(x):
    x *= x # same as x = x*x- so its the square root
    print(x)

foo(2)