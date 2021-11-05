rm(list = ls())

#Author: Sarah Dobson
#Date: 5th November 2021
#Description: illustrates control flow loops in R





a <- TRUE
if (a == TRUE){
  print ("a is TRUE")
} else {
  print ("a is FALSE")
}



z <-runif(1) ##Generate a uniformly distributed random number
if (z <= 0.5) {
  print ("Less than a half")
}


#prints out the squared number of i 
for (i in 1:10){
  j <- i * i
  print(paste(i, "squared is", j ))
}


#prints 'this species is' for each species in the list
for(species in c('Heliodoxa rubinoides',
                 'Boissonneaua jardini',
                 'Sula nebouxii')){
  print(paste('The species is', species))
}

#prints out all the elements in v1
v1 <- c("a", "bc", "def")
for (i in v1){
  print(i)
}


#While loops

i <- 0
while (i < 10){
  i <- i+1
  print(i^2)
}

print("Script complete!")

