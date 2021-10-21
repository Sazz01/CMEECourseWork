

#DESCRIPTION: 
#This script: 
#(1) imports trees.csv into R environment, 
#(2) calculates the height of each tree in the TreeData dataframe, 
#(3) adds this information to the dataframe as a new column called Tree.Height.m, 
#(4) saves the updated dataframe to the results folder under 'TreeHts.csv'.
#
#FUNCTIONS
#TreeHeight: this function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using the trigonometric formula.
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#


#(1)
TreeData <- read.csv("../data/trees.csv", header = TRUE)
class(TreeData)

#(2)
TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
  
  return (height)
}

#(3)
TreeData$Tree.Height.m<- TreeHeight(TreeData[,3], TreeData[,2])

#(4)
write.csv(TreeData, "../results/TreeHts.csv", row.names = F)

