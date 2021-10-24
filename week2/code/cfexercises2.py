#!/usr/bin/env python3

##predicitng how many times "hello" will be printed before testing each of these functions
"""This script demonsrates how conditional functions allow for fine-grained control over the function’s operations. Here we try to predict how many times "hello" will be printed when testing each of these functions"""

__name__ = ['cfexercies2.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'



for j in range(12): #remember range only does 0 to 11
    if j % 3 == 0:
        print('hello') 

#% will return the rest  of an euclidian division, 
# for example 10 % 3 == 1 , becuase 10 // 3 = 9 
#(becuase its closest number it can be divided to wholley) with 1 left over
#therefore 'hello' is printed 4 times because j is wholly divided by 3 4 times (0, 3, 6 and 9)
#with nothing left over


for j in range(15): #remember range only does 0 to 14
    if j % 5 == 3:
        print('hello')
    elif j % 4 == 3: #so if the first condition is not met for any number on the range, 
    #it will check for the following condition
        print('hello')
    


#%5 part = 2 times, 4% part = 3  times so 5 in total

#j % 5 == 3 for 3, 8 and 13
#j % 4 == 3 for 3, 7 and 11
#11 (becuase 3 is listed above, its discounted, so it only prints 5)

z = 0
while z != 15: #while z  is not equal to 15, keep repeating the command
    print('hello') #print hello
    z = z + 3 #add 3 to z before repeating the command

#will print 5 times



z = 12
while z < 100: #so while z is less than hundred, this function will repeat its self
    if z == 31: #and if z is specifically 31
        for k in range(7): #for every number from 0 to 6 (so for 7 instances)
            print('hello') #it will print hello
    elif z == 18: #however, if that condition is not met, it will check for the following condition: if z is 18 it will print once
        print('hello') #it will print hello
    z = z + 1 #at the end it will add 1 to z until it reaches 100, when the whole command will end

     #so, it will probably print hello 8 times




