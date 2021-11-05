rm(list = ls())

#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: Oct 19 2021
#DESCRIPTION: this script demonstrates examples of conditional functions in R, includes descriptions of what these functions do.

#FUNCTIONS:
#1: Checks if an integer is even
#2: Checks if a number is a power of 2
#3 Checks if a number is prime


#[1] 
is.even <- function(n = 2){
  if (n %% 2 == 0)   # if (n %% 2 == 0) #if n is divided by 2 gives zero remainders
  {
    return(paste(n,'is even!'))
  } 
  return(paste(n,'is odd!')) 
}

print(is.even(6))

#[2]
is.power2 <- function(n = 2){
  if (log2(n) %% 1==0) # if the log2 of n divided by 1 gives zero remainders
  {
    return(paste(n, 'is a power of 2!'))
  } 
  return(paste(n,'is not a power of 2!'))
}

print(is.power2(4))




#[3]
is.prime <- function(n){
  if (n==0){
    return(paste(n,'is a zero!'))
  }
  if (n==1){
    return(paste(n,'is just a unit!'))
  }
  ints <- 2:(n-1) #ints gets all the integers between 2 and n -1.
  if (all(n%%ints!=0)){ #'if n divdied by all the integers assigned to n giev zero remainders
    return(paste(n,'is a prime!'))
  } 
  return(paste(n,'is a composite!'))
}

print(is.prime(3))

print("Script complete!")


