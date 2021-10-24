#!/usr/bin/env python3

"""This script demonstrates how '__name__ == 'main'' is used to differentiate a programme being run by itself vs it being imported form another module """

__appname__ = '[using_name.py]'
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'

if __name__ == '__main__':
    print('This program is being run by itself')

else: print('I am being imported from another module')

print("This module's name is:" + __name__)