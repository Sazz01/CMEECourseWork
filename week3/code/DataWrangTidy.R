rm(list=ls())


#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: demonstrates how to manage and transform data using tidyverse packages
################################################################
################## Wrangling the Pound Hill Dataset using tidyverse commands############
################################################################

############ load required packages ##################

require(tidyverse)
############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- read.csv("../data/PoundHillData.csv", header = FALSE)


################## Transpose the dataset################

#transpose dataframe using t() then change into a tibble dataframe
MyData <- tibble::as_tibble(data.frame(t(MyData), stringsAsFactors = F))


#rename row 1 as column names, then get rid of row 1
MyData <- MyData %>% 
  set_names(slice(.,1)) %>% 
  slice(-1)

#replace blank spaces with NA's, then replace the NAs with 0s            
MyData <- MyData %>%
  mutate_all(list(~na_if(.,""))) %>%
  mutate_all(funs(replace_na(., 0)))


# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";")


############# Convert from wide to long format  ###############

MyWrangledData2 <- MyData %>% 
  pivot_longer(cols =5:45, names_to="Species", values_to="Count" ) %>%
  mutate_at(1:5, as.factor) %>% #change the data types of the columns to the correct type
  mutate_at(6, as.integer)
  
#so Cultivation - Quadrat stays as they are, the rest of the columns headers, are now listed in a new column called "Species", while the values in those columns are now listed in a new column "count" adjacent to their old variable name.

dplyr::glimpse(MyWrangledData2)

#Assigning columns data types
MyWrangledData2 %>%
  mutate_at(1:5, as.factor) %>%
  mutate_at(6, as.integer)


#viewing the data

dplyr::glimpse(MyWrangledData2)


print("Script complete!")
