rm(list = ls())

#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: 5th November 2021
#DESCRIPTION: illustrates how to vectorise the stochastic ricker equation model in R.

#FUNCTIONS:
#stochrik- simulates population growth using the stochastic ricker equation with gaussian fluctuations

#ARGUMENTS:

#p0 - population size
#sigma - level of fluctuation
#numyears- the number of years (times) the model is repeated for
#r- intrinsic growth rate
#k is the carrying capacity of the population
#generations- the number of times you want the model to run




############Run the stochastic Ricker equation with gaussian fluctuation#########

rm(list = ls())


stochrick <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2, numyears = 100)
{
  
  N <- matrix(NA, numyears, length(p0))  #initialize empty matrix
  
  N[1, ] <- p0
  
  for (pop in 1:length(p0)) { #loop through the populations
    
    for (yr in 2:numyears){ #for each pop, loop through the years
      
      N[yr, pop] <- N[yr-1, pop] * exp(r * (1 - N[yr - 1, pop] / K) + rnorm(1, 0, sigma)) # add one fluctuation from normal distribution
      
    }
    
  }
  return(N)
  
}

View(stochrick())



#####Improving the performance (speed) of the function by removing a loop#######



vectorised_stochrick <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2,numyears = 100)
{
  
  N <- matrix(NA, numyears, length(p0))  #initialize empty matrix
  
  N[1, ] <- p0
  

  for (yr in 2:numyears){ #for each pop, loop through the years
      
      N[yr, 1:length(p0)] <- N[yr-1, 1:length(p0)] * exp(r * (1 - N[yr - 1, 1:length(p0)] / K) + rnorm(1, 0, sigma)) #instead of using pop, insert 1:length(p0) so that it will be through each population in 1 loops instead of 2. add one fluctuation from normal distribution
      
    }
    
  return(N)
  
}

###Comparing the speed of the functions#############

print("Vectorized Stochastic Ricker takes:")
print(system.time(stochrick ()))


print("Vectorized Stochastic Ricker takes:")
print(system.time(stochrick ()))

print("Script complete!")
