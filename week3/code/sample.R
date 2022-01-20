rm(list = ls())

#AUTHOR: Sarah Dobson sld21@ic.ac.uk

#DATE: 5th November 2021
#DESCRIPTION: illustrating the use of lapply and sapply through various functions, we then compare the time taken between functions with loops and sapply/lappy.

#FUNCTIONS:

#1- A function to take a sample of size n from a population "popn" and return its mean
#2- Calculate means using a FOR loop on a vector without preallocation:
#3- runs "num" iterations of the experiment using a FOR loop on a vector with preallocation
#4 - runs "num" iterations of the experiment using a FOR loop on a list with preallocation
#5 - runs "num" iterations of the experiment using vectorization with lapply
#6 To run "num" iterations of the experiment using vectorization with sapply


#1
myexperiment <- function(popn,n){
  pop_sample <- sample(popn, n, replace = FALSE)
  return(mean(pop_sample))
}

#2
loopy_sample1 <- function(popn, n, num){
  result1 <- vector() #Initialize empty vector of size 1 
  for(i in 1:num){
    result1 <- c(result1, myexperiment(popn, n))
  }
  return(result1)
}

#3
loopy_sample2 <- function(popn, n, num){
  result2 <- vector(,num) #Preallocate expected size
  for(i in 1:num){
    result2[i] <- myexperiment(popn, n)
  }
  return(result2)
}

#4
loopy_sample3 <- function(popn, n, num){
  result3 <- vector("list", num) #Preallocate expected size
  for(i in 1:num){
    result3[[i]] <- myexperiment(popn, n)
  }
  return(result3)
}


#5 
lapply_sample <- function(popn, n, num){
  result4 <- lapply(1:num, function(i) myexperiment(popn, n)) #i is a place holder for myexperiment(). lapply 1:num into a list, so "list" doent have to be specificed explicitly like above.
  return(result4)
}

#6 To run "num" iterations of the experiment using vectorization with sapply:
sapply_sample <- function(popn, n, num){
  result5 <- sapply(1:num, function(i) myexperiment(popn, n))
  return(result5)
}


##create a random population
set.seed(12345)
popn <- rnorm(10000) # Generate the population
hist(popn)
n <- 100 # sample size for each experiment
num <- 10000 # Number of times to rerun the experiment


print("Using loops without preallocation on a vector took:" )
print(system.time(loopy_sample1(popn, n, num)))

print("Using loops with preallocation on a vector took:" )
print(system.time(loopy_sample2(popn, n, num)))

print("Using loops with preallocation on a list took:" )
print(system.time(loopy_sample3(popn, n, num)))

print("Using the vectorized sapply function (on a list) took:" )
print(system.time(sapply_sample(popn, n, num)))

print("Using the vectorized lapply function (on a list) took:" )
print(system.time(lapply_sample(popn, n, num)))

print("Script complete!")
