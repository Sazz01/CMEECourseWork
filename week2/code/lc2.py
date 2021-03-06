#!/usr/bin/env python3

"""This script modifies lists via comprehensions and loops"""

__appname__ = ['lc2.py']
__author__ = 'Sarah Dobson (sld21@ic.ac.uk)'
__version__ = '0.0.1'

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

HeavyRain = [x for x in rainfall if x[1]> 100]
print(HeavyRain)
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

LightRain = [(x[0]) for x in rainfall if x[1]< 50]
print(LightRain)


# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

HeavyRain= []
for x in rainfall:
    if x[1]> 100:
        HeavyRain.append((x))
print(HeavyRain)


LightRain= []
for x in rainfall:
    if x[1]< 50:
        LightRain.append((x[0]))
print(LightRain)
        

# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.

