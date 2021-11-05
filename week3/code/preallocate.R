rm(list = ls())

#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: 5th November 2021
#DESCRIPTION: demonstrates how preallocating vectors reduces processing time.


#Loops are slow in R because memory allocation for particular variable changes during looping.
#loops that resizes vectors repeatedly makes R reallocate memory repeatidly- slowing the process down. ie:

NoPreallocFun <- function(x){
  a <- vector() # empty vector
  for (i in 1:x) {
    a <- c(a, i)
    print(a)
    print(object.size(a))
  }
}

system.time(NoPreallocFun(10))

#below preallocates a vector that fits all the values so that R doesnt have to reallocate memory each iteration; making it much faster.

PreallocFun <- function(x){
  a <- rep(NA, x) # pre-allocated vector. rep(x) replicates NA for the length of x, ie. an x number of times.
  for (i in 1:x) {
    a[i] <- i
    print(a)
    print(object.size(a))
  }
}

system.time(PreallocFun(10))

print("Script complete!")
