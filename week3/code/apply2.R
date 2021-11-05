rm(list = ls())

#Author: Sarah Dobson
#Date: 5th November 2021
#Description: defining our own function using apply


SomeOperation <- function(v){ # (What does this function do?)fucntion(x) defines a new function for argument x. A matrix in this case.
  if (sum(v) > 0){ #note that sum(v) is a single (scalar) value. if the sum of the matrix is more than zero
    return (v * 100) #it will times that number by hundred and return it
  }
  return (v)

}

M <- matrix(rnorm(100), 10, 10) #rnorm- normally distributed numbers start from -1, so some numbers will be negative. 
print (apply(M, 1, SomeOperation)) #apply applies V across all the columns automatically, a loop doesnt have to be made.

print("Script complete!")
