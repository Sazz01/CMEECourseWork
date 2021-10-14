#!/usr/bin/env python3


"""Some functions exemplifying the use of control statements"""

__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'


import sys
def foo_1(x):
    return x ** 0.5

#foo_1 returns the square root of x

def foo_2(x, y):
    if x > y:
        return x
    return y

#if x is greater than y, foo_2 will return the number 
#inputted for x, if not foo_2 will return the number inputted for y
#basically will foo_2 return the lrger number of the two.


def foo_3(x, y, z):
    if x > y: #if x is greater than y
        tmp = y #tmp stores the original value of y
        y = x    #new y is now equal to x
        x = tmp #x is now the old value of y
    if y > z: #if y is greater than z (even if it is now only greater after being swapped previously)
        tmp = z #same as abbove
        z = y
        y = tmp
    return [x, y, z] #returns the numbers in their new positons

# foo_3 swaps the values of x and y around if x is greater than y, 
#then swaps the value of y and z around if y is greater than z.

def foo_4(x):
    result = 1
    for i in range(1, x +1):  #i lists off all the numbers between 1 and x (but not including x (ie. x = 4, i only goes from 1 -3), so thats why x +1 is included)
        result = result * i   #result is then calculated by multiplying the range of i by the previous result(eg. 4), for example if x (and i) is 4, it will multiply 1 x 2 x 3 x 4)
    return result #if x is 4, should return 10

#foo_5 calculates the factorial of x

def foo_5(x):#a recursive function that calculates the factorial of x
    if x == 1: #if x = 1 is true
        return 1 #return 1
    return x * foo_5(x - 1)  #if x doesnt equal 1, it will if (x =5) multiply 5 by (5-1) by (5-1-1) (5-1-1-1) by (5-1-1-1) etc until we hit 0. essentialy we multiply 5 x 4 x 3 x 2 x 1


def foo_6(x): #Calculate the factorial in a different way
    facto = 1  #assigning to facto
    while x >= 1:  #if x is greater than or equal to 1. While function loops the following command until x is less than 1.
        facto = facto * x  #reassign facto as 1 * x , 
        x = x - 1    #then subract 1 from x, then go through the whole process again, becuase x is changed it will go through all the subractions of x, multyipling it by facto, until it reaches 1 and doesnt do it anymore
    return facto  

