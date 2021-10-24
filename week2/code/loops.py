#!/usr/bin/env python3


"This script gives some examples of loops and demonstrates how they work"


__appname__ = ['loops.py']
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'

#FOR loops in Python
for i in range(5): # i is 0, 1, 2, 3 and 4
    print(i) #prints above

my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list: #k  is for every single item on list, could have been assigned any letter 
    print(k) #prints out what my_list contains

total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands: #s is for every single item in the list
    total = total + s #for each listed number, sequentially adds together each listed number and the previous listed numbers
    print(total) #prints off total


#While loops in Python

z = 0 #z equals 0
while z < 100: #as long as z is less 100 it will complete and rerun the following command
    z = z + 1 #adds 1 to z
    print(z)#then prints it and then reruns command unil z hits 100

b = True #basically b = b
while b: #so while b continues to be itself
    print("GERONIMO! infinite loop! ctrl+c to stop!") #a never ending loop
    #do as stated lollll