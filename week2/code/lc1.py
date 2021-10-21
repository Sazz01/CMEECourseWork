#!/usr/bin/env python3
#author: Sarah Dobson sld21.ic.ac.uk
#date: 15 October 2021

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 


#To create each list via comprehension: ask python to print lists of the first, second and third elements of each tupple in the list respectively. 
LatinNames = [L[0] for L in birds]
print(LatinNames)

CommonNames = [C[1] for C in birds]
print(CommonNames)

BodyMass  = [B[2] for B in birds]
print(BodyMass) 



# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

#do the same as above, but via loops
LatinNames = []
for L in birds:
    LatinNames.append(L[0])
print(LatinNames)
    
CommonNames = []
for C in birds:
    CommonNames.append(C[1])
print(CommonNames)


BodyMass = []
for B in birds:
    BodyMass.append(B[2])
print(BodyMass)



# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.
 