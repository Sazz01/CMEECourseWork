rm(list=ls())

#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: demonstrates how to manage and transform data using base R and reshape package


################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../data/PoundHillData.csv", header = FALSE))

# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";")


############# Inspect the dataset ###############
head(MyData)
dim(MyData)
str(MyData)
fix(MyData) #you can also do this
fix(MyMetaData)

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) #t() transposes ie. rotates the matrix around, so that the columns are now rows and vice versa. 
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
#Automatic string to factor conversion introduces non-reproducibility.
#When creating a factor from a character vector, if the levels are 
#not given explicitly the sorted unique values are used for the levels, and of course the result of sorting is locale-dependent. 
#Hence, the results of subsequent statistical analyses can differ with automatic string-to-factor conversion in place.

colnames(TempData) <- MyData[1,] # assign column names from original data. need them to do the melt fucntion


############# Convert from wide to long format  ###############
require(reshape2) # load the reshape2 package

?melt #check out the melt function

MyWrangledData <- melt(TempData, id=c("Cultivation", "Block", "Plot", "Quadrat"), variable.name = "Species", value.name = "Count")
#so Cultivation - Qyadrat stays as they are, the rest of the columns headers, are now listed in a new column called "Species", while the values in those columns are now listed in a new column "count" adjacent to their old variable name.
MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"]) #factor because the variables are distinct from one another.
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"]) #integer- can't have a count of 0.5 for example, so the numbers are whole

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

print("Script complete!")
