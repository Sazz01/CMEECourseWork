rm(list = ls())

#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: 5th November 2021
#DESCRIPTION: demonstrates how browser() can be used to detect errors in code


#FUNCTIONS:
#Exponential - runs a simulation of exponential growth and returns a vector of length generations

#ARGUMENTS:
#N0 - starting population size
#r- intrinsic growth rate
#generations - number of times (geneerations) you want to run the function



Exponential <- function(N0 = 1, r = 1, generations = 10){
  # Runs a simulation of exponential growth
  # Returns a vector of length generations
  
  N <- rep(NA, generations)    # Creates a vector of NA
  
  N[1] <- N0
  for (t in 2:generations){
    N[t] <- N[t-1] * exp(r)
    browser()
  }
  return (N)
}

plot(Exponential(), type="l", main="Exponential growth")



print("Script complete!")
