rm(list = ls())

#Author Sarah Dobson sld21@ic.ac.uk
#Date: Oct 19 2021
#Description: Illustrates how to skip to the next iteration of a loop



for (i in 1:10) {
  if ((i %% 2) == 0) # check if the number is odd
    next # pass to next iteration of loop 
  print(i)
}

print("Script complete!")