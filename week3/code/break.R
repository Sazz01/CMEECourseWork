rm(list = ls())

#Author: Sarah Dobson
#Date: 5th November 2021
#Description: Illustrates how to break out of loops in R

i <- 0 #Initialize i
while(i < Inf) {
  if (i == 10) {
    break
  } #Break out of the while loop!
  else {
    cat("i equals " , i, "\n")
    i <- i + 1 #update i
  }
}



print("Script complete!")