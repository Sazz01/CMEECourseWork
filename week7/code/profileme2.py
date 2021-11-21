#!/usr/bin/env python3

"""This script is a continuation from profileme.py. In this script we 1. converted the loop to a list comprehension, and 2. replaced the .join with an explicit string concatenation."""

__appname__ = ['profileme2.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'


def my_squares(iters):
    out = [i ** 2 for i in range(iters)]
    return out

def my_join(iters, string):
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x,y):
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")
