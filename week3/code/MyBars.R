rm(list = ls())

#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: This script demonstrates how to annotate plots with geom_text(), combines all the commands for annotating a plot and saves the plot as a pdf file in results###

require(ggplot2)

######load in the data###########

a <- read.table("../data/Results.txt", header = TRUE)


a$ymin <- rep(0, dim(a)[1]) # append a column of zeros

#######Print the first, second and third lineranges as separate layers######
p <- ggplot(a) + geom_linerange(data = a, aes(
  x = x,
  ymin = ymin,
  ymax = y1,
  size = (0.5)
),
colour = "#E69F00",
alpha = 1/2, show.legend = FALSE)  + geom_linerange(data = a, aes(
  x = x,
  ymin = ymin,
  ymax = y2,
  size = (0.5)
),
colour = "#56B4E9",
alpha = 1/2, show.legend = FALSE) + geom_linerange(data = a, aes(
  x = x,
  ymin = ymin,
  ymax = y3,
  size = (0.5)
),
colour = "#D55E00",
alpha = 1/2, show.legend = FALSE) + geom_text(data = a, aes(x = x, y = -500, label = Label)) + scale_x_continuous("My x axis",
  breaks = seq(3, 5, by = 0.05)) + 
  scale_y_continuous("My y axis") + 
  theme_bw() + 
  theme(legend.position = "none")


#######save plot as a pdf file and move to results###############
pdf("../results/MyBars.pdf", 11.7, 8.3)
print(p)

graphics.off()



print("Script complete!")

