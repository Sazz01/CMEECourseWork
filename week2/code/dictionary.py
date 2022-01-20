#!/usr/bin/env python3

"""This script populates a dictionary derived from a list of species names. The dictionary maps order names to sets of taxa."""

__appname__ = ['dictionary.py']
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'


taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]



#swap the items around in each tupple across the list, eg. ('1', '2') becomes ('2', '1'), 
swap_items = [(sub[1], sub[0]) for sub in taxa]

#create an empty directionary (called taxa_dic)
taxa_dic = {}
#refer to the key and values in the swap_items list
for key, val in swap_items: 
    taxa_dic.setdefault(key, []).append(val) 
    #.setdefault returns the keys in swap_items into taxa_dic
    #.append(val) adds any corresponding values of those keys into taxa_dic

print(taxa_dic)




