rm(list = ls())

#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: This script creates a dataframe and combines the commands for plotting the results of a simulation displaying Girko's Circular Law:
# that the eigenvalues of a matrix of size are approximately contained in a 
#circle in the complex plane with radius. The resulting plot is saved as a pdf file and move to results.

#FUNCTIONS:
#build_ellispe - calaculates the ellispe(the predicted bounds of the eigenvalues)

#ARGUMENTS:
#hradius - lenght of the horizontal radius
#vradius - length of the vertical radius 



require(ggplot2)

###### Calculate the ellipse ####

build_ellipse <- function(hradius, vradius){ # function that returns an ellipse
  npoints = 250
  a <- seq(0, 2 * pi, length = npoints + 1)
  x <- hradius * cos(a)
  y <- vradius * sin(a)  
  return(data.frame(x = x, y = y))
}

########Building a dataframe to plot the ellispe##################

N <- 250 # Assign size of the matrix

M <- matrix(rnorm(N * N), N, N) # Build the matrix

eigvals <- eigen(M)$values # Find the eigenvalues

eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals)) # Build a dataframe

my_radius <- sqrt(N) # The radius of the circle is sqrt(N)

ellDF <- build_ellipse(my_radius, my_radius) # Dataframe to plot the ellipse

names(ellDF) <- c("Real", "Imaginary") # rename the columns


#######Plotting the Diagram######## 

# plot the eigenvalues
p <- ggplot(eigDF, aes(x = Real, y = Imaginary))+
  geom_point(shape = I(3)) +
  theme(legend.position = "none") +
 geom_hline(aes(yintercept = 0)) + geom_vline(aes(xintercept = 0)) + # now add the vertical and horizontal lines
 geom_polygon(data = ellDF, aes(x = Real, y = Imaginary, alpha = 1/20, fill = "red"))# finally, add the ellipse


p

#######save plot as a pdf file and move to results###############
pdf("../results/Girko.pdf", 11.7, 8.3)
print(p)

graphics.off()


print("Script complete!")
