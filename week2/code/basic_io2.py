#!/usr/bin/env python3

"""This script demonstrates code that can be used to save and export data in python"""

__appname__ = ['basic_io2.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'


#Save the elements of a list into a file
list_to_save = range(100)

#Now open and create a file named 'testout.txt' in the sandbox folder
f = open('../sandbox/testout.txt', 'w')
#Now save the list (1 to 100) as a string in the testout.txt file
for i in list_to_save:
    f.write(str(i) + '\n') ## '\n' adds a new line at the end (eg. 101)

f.close()