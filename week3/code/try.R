rm(list = ls())

#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: 5th November 2021
#DESCRIPTION: demonstrates how try() continues running scripts with error messages, which can be used to figure out errors.


#FUNCTIONS:

#doit - replaces the previous sample with a new sample only if the mean of the sample was more than 30.


#########Running the function###########''
doit <- function(x){
  temp_x <- sample(x, replace = TRUE) #replace replaces the previous sample with a new sample
  if(length(unique(temp_x)) > 30) {#only take mean if sample was sufficient (more than 30)
    print(paste("Mean of this sample was:", as.character(mean(temp_x))))
  } 
  else {
    stop("Couldn't calculate mean: too few unique values!")
  }
}

sample

set.seed(1345) # again, to get the same result for illustration

popn <- rnorm(50)

hist(popn)


lapply(1:15, function(i) doit(popn)) #wont do it: Error in doit(popn) : Couldn't calculate mean: too few unique values!


##########Do with try()#################
result <- lapply(1:15, function(i) try(doit(popn), FALSE))


#asked again for 15 samples, and agian got less than that but without any error. the FALSE 
#modifier in try() surpresses any error messages. they are still stored in results though.


class(result)


#now writing the same thing but instead of using lapply, a loop is used
result <- vector("list", 15) #Preallocate/Initialize
for(i in 1:15) {
  result[[i]] <- try(doit(popn), FALSE)
}

print("Script complete!")

