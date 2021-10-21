#Breaking out of loops

i <- 0 #Initialize i
while(i < Inf) {
  if (i == 10) {
    break
  } #Break out of the while loop!
  else {
    cat("i equals " , i, "\n")
    i <- i + 1 #update i
  }
}




#Using next


for (i in 1:10) {
  if ((i %% 2) == 0) # check if the number is odd
    next # pass to next iteration of loop 
  print(i)
}



