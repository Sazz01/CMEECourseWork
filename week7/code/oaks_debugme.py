"""This script finds taxa in a list of tree species that are oak trees, and saves them to a new csv file. The script has been improved and made more robust."""

__appname__ = ['oaks_debugme.py']
__author__ = 'Sarah Dobson (sld21@imperial.ac.uk)'
__version__ = '0.0.1'


import csv
import sys
import doctest

#Define function
def is_an_oak(name):
    """ Checking to see if species belongs to oak 'Quercus' genus 

    >>> is_an_oak('Quercus ')
    True

    >>> is_an_oak('Fraximus ')
    False

    >>> is_an_oak('Pinus ')
    False

    >>> is_an_oak('Quercuss ')
    False

    """

    return name.lower().startswith(("quercus "))



def main(argv): 
    f = open('../data/TestOaksData.csv','r')
    g = open('../data/JustOaksData.csv','w')

    taxa = list(csv.reader(f))
    csvwrite = csv.writer(g)
    oaks = set()
    for row in taxa[1:]: #so it doesnt print out genus and instead starts from the first genus + species in the file
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0] + " "):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])  
        else:
            print('No oak found- did you mean Quercus?') 
    return 0
    
    


doctest.testmod()  

if (__name__ == "__main__"):
    status = main(sys.argv)

print("script complete!")