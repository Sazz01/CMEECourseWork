#!/usr/bin/env python3

"""This script reads a .csv file (test.csv) into the workspace, creates a new file 
containing only a subset of the data and then moves the output to the results section"""

__name__ = ['basic_csv.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'



import csv

"""reading test.csv file into python"""
#Read a file containing:
#'Species', 'Infraorder','Family,'Distribution','Body mass male (Kg)'
with open('../data/testcsv.csv', 'r') as f:

#csv.reader() enables the script to read the .csv file, [] means everything within the rows.
    csvread = csv.reader(f)
    temp = []
    for row in csvread: #applies changes to the rows in the file (now named csvread)
        temp.append(tuple(row))  
        
        #linked everything in each row together, so tupples the specie name 
        #with its common game, Infraorder, body etc
        
        print(row)
        #prints 'the species is' before row [0], which is the tupple containing the species name
        print("The species is", row[0])


    """writing a new file (bodymass.csv) that contains only the species name and body mass"""
    #write a file containing only species name and Body mass, 
with open('../data/testcsv.csv', 'r') as f:
    with open('../data/bodymass.csv', 'w') as g:

        csvread = csv.reader(f)
        #need to read the file so that we can extract/ copy some rows from it.
        csvwrite = csv.writer(g)
        #allows us to write/ manually edit the csv file
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0], row[4]]) 
            #we are now writing into bodymass.csv from basic.csv 
            #the first tupple (species name) and the fourth (bodymass) from each row


