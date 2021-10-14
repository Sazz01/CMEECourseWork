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

bird_a

for i in birds:
    if i == birds[0]:
        print("Latin Name:", i[0])
        print("Common Name:", i[1])
        print("Mass:", i[2])

    elif i == birds[1]:
        print("Latin Name:", i[0])
        print("Common Name:", i[1])
        print("Mass:", i[2])
    
    elif i == birds[2]:
        print("Latin Name:", i[0])
        print("Common Name:", i[1])
        print("Mass:", i[2])

    elif i == birds[3]:
        print("Latin Name:", i[0])
        print("Common Name:", i[1])
        print("Mass:", i[2])

    elif i == birds[4]:
        print("Latin Name:", i[0])
        print("Common Name:", i[1])
        print("Mass:", i[2])


    
    