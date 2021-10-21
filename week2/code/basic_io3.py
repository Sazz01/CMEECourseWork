#!/usr/bin/env python3

"""This script demonstrates code that can be used to store data for later use and load it in python"""

__appname__ = '[basic_io3.py]'
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'

"""storing data in python"""

#To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

import pickle

f = open('../sandbox/testp.p', 'wb') ##note the b: accept binary files
pickle.dump(my_dictionary, f)
f.close()


"""loading the data"""
##load the data again

f = open('../sandbox/testp.p', 'rb')
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)