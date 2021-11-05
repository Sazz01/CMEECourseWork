rm(list = ls())

#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: This script demonstrates mathematical annotation of an axis as well as within the plot area and combines all the commands for annotating a linear regression plot 
#and saves the resulting figure in results

require(ggplot2)


####Creating Linear Regression Data####
x <- seq(0, 100, by = 0.1)
y <- -4. + 0.25 * x +
  rnorm(length(x), mean = 0., sd = 2.5)

# and put them in a dataframe
my_data <- data.frame(x = x, y = y)

# perform a linear regression
my_lm <- summary(lm(y ~ x, data = my_data))

#####Plotting the data#######
p <-  ggplot(my_data, aes(x = x, y = y,
                          colour = abs(my_lm$residual))
) +
  geom_point() +
  scale_colour_gradient(low = "black", high = "red") +
  theme(legend.position = "none") +
  scale_x_continuous(
    expression(alpha^2 * pi / beta * sqrt(Theta))) + # add the regression line
  geom_abline(
  intercept = my_lm$coefficients[1][1],
  slope = my_lm$coefficients[2][1],
  colour = "red") + # throw some math on the plot
  geom_text(aes(x = 60, y = 0,
                       label = "sqrt(alpha) * 2* pi"), 
                   parse = TRUE, size = 6, 
                   colour = "blue")

#######save plot as a pdf file and move to results###############
pdf("../results/MyLinReg.pdf", 11.7, 8.3)
print(p)

graphics.off()

print("Script complete!")

