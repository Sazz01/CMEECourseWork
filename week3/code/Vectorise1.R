
#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: Oct 19 2021
#DESCRIPTION: this script demonstrates how vectorizing functions can reduce the time taken to do the function. sum(M) is faster than SumAllElements(M) because sum(M) vectorises the 
#values and avoids the loops used in SumAllElements(M)

#FUNCTIONS:
#SumAllElements - sums up all the elements in a matrix via loops across the columns and rows

#ARGUMENTS: 
#M- 1000 x 1000  matrix generated with numbers 1- 1 million


M <- matrix(runif(1000000), 1000, 1000) #createing a 1000x1000 matrix with numbers 1 - 1 million

SumAllElements <- function(M){
  Dimensions <- dim(M) #calculates the number of rows and columns, assigns them as M[1] and M[2] respectively
  Tot <- 0
  for (i in 1:Dimensions[1]){
    for (j in 1:Dimensions[2]){
      Tot <- Tot + M[i, j] #sums all the elements in a matrix together
    }
  }
  return (Tot)
}

print("Using loops, the time taken is:")
print(system.time(SumAllElements(M)))

print("Using the in-built vectorized function, the time taken is:")
print(system.time(sum(M)))





print("Script complete!")

