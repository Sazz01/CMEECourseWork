#!/usr/bin/env python3

"""This script extracts taxa that are oak trees from a list of species using a pre-defined function and a for loop, and saves them in a separate file"""

__appname__ = ['tuple.py']
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'

## Functions ##

def is_an_oak(name):
    """function returns species names that start with quercus """

    return name.lower().startswith('quercus')




taxa = [ 'Quercus robur',
         'Fraxinus excelsior',
         'Pinus sylvestris',
         'Quercus cerris',
         'Quercus petraea',
         ]


oaks_loops = set ()  #assign oak_loops as an empty set
for species in taxa: #species - the name for the new data set from the species list, taxa is mentioned because thats where the data will be pulled from
    if is_an_oak(species): #applying list of names that is_an_oak has matched from taxa to species
        oaks_loops.add(species) #now adding the species to the oak_loops set
print(oaks_loops)



##Using list comprehensions

oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_loops)


##Get names in UPPER CASE using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

##Get names in UPPER CASE using list comprehensions
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)