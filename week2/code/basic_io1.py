#!/usr/bin/env python3

"""This script demonstrates code that can be used to import data in python"""

__appname__ = '[basic_io1.py]'
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'



"""Importing data in python"""
#Open a file for reading
f = open('../sandbox/test.txt', 'r')

#use "implicit" for loop:
#if the object is a file, python will cycle over lines
for line in f:
    print(line)


#close the file
f.close()

#same example, skip blank lines
f = open('../sandbox/test.txt', 'r')

for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()