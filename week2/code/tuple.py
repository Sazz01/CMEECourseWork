#!/usr/bin/env python3

"""This script modifies tuples via loops"""

#docstrings are considered part of the running code (normal comments are
#stripped). Hence, you can access your docstrings at run time.

__appname__ = ['tuple.py']
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'



birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by species 
# 
# A nice example output is:
# 
# Latin name: Passerculus sandwichensis
# Common name: Savannah sparrow
# Mass: 18.7
# ... etc.

# Hints: use the "print" command! You can use list comprehensions!



for i in birds:
    if i[0]:
        print("Latin Nmae: %s" % i[0])
    if i[1]:
        print("Common Name: %s" % i[1])
    if i[2]:
        print("Mass: %s" % i[2])

    
    