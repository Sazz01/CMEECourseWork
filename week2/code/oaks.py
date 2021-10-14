#### Finds out those taxa that are oak trees from a list of species

taxa = [ 'Quercus robur',
         'Fraxinus excelsior',
         'Pinus sylvestris',
         'Quercus cerris',
         'Quercus petraea',
         ]

#defining an oak species by asking the function to return (in lower case so it matches strartswith?) species names that start with quercus
def is_an_oak(name):
    return name.lower().startswith('quercus')


##Using for loops

oaks_loops = set ()  #assign oak_loops as an empty set
for species in taxa: #species - the name for the new data set from the species list, taxa is mentioned becuase thats where the data will be pulled from
    if is_an_oak(species): #applying list of names that is_an_oak has matched from taxa to species
        oaks_loops.add(species) #now adding the specues to the oak_loops set
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