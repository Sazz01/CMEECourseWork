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

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc.
#  OR,
# 'Chiroptera': {'Myotis lucifugus'} ... etc


#swap the items around in each tupple across
#the list, eg. ('1', '2') becomes ('2', '1'), 
#so that once added to the dictionaery it will read the order
#as a key and the species as values
swap_items = [(sub[1], sub[0]) for sub in taxa]
print(swap_items) #make sure it has swapped

#create an empty directionary (called taxa_dic)
taxa_dic = {}
#refer to the key and vlaues in the swap_items list
for key, val in swap_items: 
    taxa_dic.setdefault(key, []).append(val) 
    #.setdefault returns the keys in swap_items into taxa_dic
    #.append(val) adds any corresponding
    #values of those keys into taxa_dic

print(taxa_dic)




