#!/usr/bin/env python3

""" This script, in conjunction with the Debugging section of Biological Computing with Python 1, is used to demonstrate how debugging works"""

__appname__ = ['debugme.py']
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'

def buggyfunc(x):
    
    y = x
    for i in range(x):
        try:     #'try' tries to do the command and if it does not work (any error happens), it transfers control to the except block and whatever you ask Python to do in that block gets executed. this stops an Error being produced and the programme shutting down
            y = y-1
            z = x/y
        except ZeroDivisionError:
            print(f"The result of dividing a number by zero is undefined")
        except:
            print(f"This didn't work; x = {x}; y = {y}")
        else:
            print(f"OK; x = {x}; y = {y}, z = {z};")
    return z

buggyfunc(20)