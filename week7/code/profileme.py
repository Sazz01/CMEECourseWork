#!/usr/bin/env python3

"""This script demosntrates how to find out what is slowing down your code via “profiling”: which locates the sections of your code where speed bottlenecks exist.."""

__appname__ = ['profileme.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'

## functions ##

def my_squares(iters):
    """returns the squared values of a list"""
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    """Adds strings to the numbers separated by numbers and spaces and repeats for a given number of times (iters)"""
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    """prints the output and input values from my_square and my_join"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000,"My string")