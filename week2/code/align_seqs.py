#!/usr/bin/env python3

"""This script imports two DNA sequences from file test.txt
aligns two DNA sequences such that they are as similar as possible, and saves the best alignment 
and its corresponding in a single text file (best.txt). This script also function as a programme"""

__appname__ = ['align_seqs.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'

import sys

"""opening and reading test2.txt into python"""

f = open('../data/test2.txt') #open file 
lines = f.readlines()  #readlines() reads and prints each line separately, but with trailing newlinwe charfacters at the end of each line
items = [] #create a new empty list
for i in lines:
    items.append(i.strip())# adds both lines of sequence to items. strip() gets rid of the newline charcters from both lines
print(items)

seq2 = items[0] #first sequence assigned to seq2
seq1 = items[1] #second sequence assigned to seq1

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

"""getting the length of each sequence"""

l1 = len(seq1) #len() gives the length of both sequences respectively
l2 = len(seq2)
if l1 >= l2:  #if l1 is greater or equal to l2, seq1 and seq2 are equal to s1 and s2 respectively. 
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2 #if l1 is less than l2, seq1 and se2 are equal to s2 and s1 respectively. 
    s2 = seq1 #so s1 always has a higher number than s2. if seq1 and seq2 have swapped, l1 and l2 also have to so that they are assigned to the right sequences. 
    l1, l2 = l2, l1 # swap the two lengths assigned to l1 and l2. this whole bit is done to make sure that the longest sequence is always assigned to s1.

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user) - a random number chosen by the user

"""Calaculating the number of mactchees for each alignment"""
def calculate_score(s1, s2, l1, l2, startpoint): # needs (in order): the longer sequence, the shorter sequence, length of the longer sequence, the length of the shorter sequence, startpoint- which determines what base number on the sequence matching starts to occur.
    matched = "" # to hold string displaying alignements - so it can dusplay matches (*) and not matches (-) as they are processed.
    score = 0   #matches start at zero
    for i in range(l2): #for each base on the shortest sequence length. where i can be any bases on the seqence from 1 - max l2 length (eg.10). this changes the alignment of s2 on s1.
        if (i + startpoint) < l1: #if i + the startpoint is less than the longest sequence length (eg. 16), it will ocntinue to try and match bases across the current alignment. once reachinfg the end it will print off the stuff below and return to the line above.
            if s1[i + startpoint] == s2[i]: # if, the bases read on s1 match the bases read on s2.
                matched = matched + "*" #if the bases match an asterisk is added to 'match'
                score = score + 1  #1 is added to the score, as the fucntion loops over it will add up all the times the bases matched in one go. 
            else:
                matched = matched + "-" #if it doesnt match a dash is added to 'matched'

    # some formatted output
    print("." * startpoint + matched)  #dots are printed for the same number of times as the value of start point + i (eg. startpoint =5 + i = 3 >>> ........) then matched string is printed   
    print("." * startpoint + s2) #dots are printed as explained above, then sequence two is printed
    print(s1) #sequence 1 is printed, the asterisks from 'matched' and matching bases form seq1 and seq2 should align.
    print(score) #prints how many times the bases matched betwen s1 and s2.
    print(" ")

    return score #once done, seq2 will move once space across seq 1 to be compared again and again until it reaches the end of sequence 1 (line 23) 

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

"""determining the best alignment and score"""
# now try to find the best match (highest score) for the two sequences
my_best_align = None  #assign it nothing for the moment
my_best_score = -1   

for i in range(l1): # Note that you just take the last alignment with the highest score. for i in the length of sequence 1
    z = calculate_score(s1, s2, l1, l2, i) #each score from each alignment the abpve function is now refered to as z.
    if z > my_best_score: #if z is greater than my best score,
        my_best_align = "." * i + s2 # think about what this is doing! "." * i prints out dots equal to the number of i with the best score. then the sequence of s2 is added after it. this is so seq 1 and se2 will b printed out togetehr at their best alignment
        my_best_score = z #it assigns z as the new best score






print("%s" % my_best_align, file = open("best.txt", "a"))
print("%s" % s1, file = open("best.txt", "a")) 
print("Best score: %d" % my_best_score, file = open("best.txt", "a")) 



import shutil

"""moving the output to the results section"""

shutil.move('best.txt', '../results/')

"""defining the main argument"""

def main(argv):
    print(calculate_score(s1, s2, l1, l2, 0))
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)
