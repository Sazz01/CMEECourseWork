rm(list = ls())

#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: 5th November 2021
#DESCRIPTION: illustrates modelling the ricker model in R.



#FUNCTIONS:
#ricker - simulates population growth

#ARGUMENTS:

#N0 - starting population size
#r- intrinsic growth rate
#k is the carrying capacity of the population
#generations- the number of times you want the model to run

Ricker <- function(N0=1, r=1, K=10, generations=50) 
{  
  # Runs a simulation of the Ricker model
  # Returns a vector of length generations
  
  N <- rep(NA, generations)    # Creates a vector of NA, by printing NA 50 times (becuase that is the number of generations)
  
  N[1] <- N0  #NO (1 in this case) is assigned to the first element listed in N
  for (t in 2:generations) #for each generation between 2 and 50
  {
    N[t] <- N[t-1] * exp(r*(1.0-(N[t-1]/K))) 
  }
  return (N)
}

plot(Ricker(generations=10), type="l")


print("Script complete!")



