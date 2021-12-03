#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: 21th November 2021
#DESCRIPTION: manipulating and wrangling the datatsets before model fitting


#####Remove anything elsee already in the workspace######
rm(list=ls())

#######Load in required packages########
require("tidyverse")

###########Load in data#########
data <- read.csv("../data/LogisticGrowthData.csv")
metadata <- read.csv("../data/LogisticGrowthMetaData.csv")


###Assign datasets######
#separate datasets by Temperature, Author, Species, Medium type and replicate number: assign this to Rep ID
data <- data %>% relocate(c(Temp, Citation, Species), .before = Rep)  %>% # merge Temp, Citation and Species columns, assigned this 'ID'.
  unite(ID, Medium:Species, sep = "_", remove = FALSE) %>%
  mutate(ID = as.numeric(factor(ID))) %>%
  na.omit(data)%>%
  unite("Rep_ID", ID, Rep, remove = F) #merge ID with the replicate number, assign this 'Rep_ID'. Separate datasets will be referred to as Rep_ID from now on.

###### Filter out datasets with negative Time and population values#####
data <- data %>% group_by(Rep_ID)  %>% filter(Time > 0) %>% filter(PopBio > 0)


###### Get the number of datapoints within each dataset#########
Counts<- data %>% 
  group_by(Rep_ID) %>% 
  summarise(avg_count = n())
data <- left_join(data, Counts) # assisn counts to each dataset

######filter dataset and assign numbers to the datapoints#####
wrangle_data<- data%>% filter(avg_count > 7)%>% #remove data sets with less than 8 datapoints 
  group_by(Rep_ID) %>% arrange(desc(Time), .by_group = T) %>% #arranges time from highest to lowest in each dataset
   mutate(counter = row_number()) # assigns a number to each datapoint in chronological order in a dataset. (eg. the largest time number will be assigned 1, the second largest assigned 2 etc) 


##add the log of Population size as the column to the dataframe
wrangle_data$logPopBio <- log(wrangle_data$PopBio)
wrangle_data$logPopBio[is.infinite(wrangle_data$logPopBio)] <- NA


#####save dataframe#####
write.csv(wrangle_data, "../data/wrangled_data.csv", row.names=FALSE)



######end of script########







                                   