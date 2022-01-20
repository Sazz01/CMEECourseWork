rm(list = ls())

#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: this script completes task 1 to 5 from the Practical_Alleles_.pdf, calculating expected and observed allele and genotype frequencies from 20 brown bears.


####Load and Inspect Data###
MyDF <- read.csv("../data/bears(1).csv", stringsAsFactors=F, header=F, colClasses=rep("character", 10000))

### required packages ####
require(tidyverse)


#Question 1 
MyDF2<- MyDF %>% summarise_all(n_distinct) %>% select_if(function(col) !all(col == 1))
#or could also use this method
MyDF2<- MyDF %>%  select_if(~n_distinct(.) == 2)


# Question 2

MyDF3<- MyDF %>%  select_if(~n_distinct(.) == 2)%>%
  gather(var, level) %>%
  group_by(var, level) %>%
  summarise(val = n()) %>%
  spread(var, val, fill = 0) %>%
  mutate_at(vars(-level), ~./40)


MyDF3<- MyDF %>%  select_if(~n_distinct(.) == 2)%>%
  gather(var, level)%>%
  group_by(var, level)%>%
  summarise(val = n()) %>%
  spread(var, val, fill = 0)





#Question 3

MyDF4<- MyDF %>%  select_if(~n_distinct(.) == 2) %>%
  mutate(id = ceiling(row_number() / 2)) %>%
  group_by(id) %>% summarise(across(everything(), str_c, collapse="")) %>%
 select(-id)%>%
  gather(var, level) %>%
  group_by(var, level) %>%
  summarise(val = n()) %>%
  spread(var, val, fill = 0) %>%
  mutate_at(vars(-level), ~./20)

MyDF4<- MyDF %>%  select_if(~n_distinct(.) == 2)%>%
  mutate(id = ceiling(row_number() / 2))%>%
  group_by(id) %>% summarise(across(everything(), str_c, collapse=""))%>%
  select(-id)%>%
  gather(var, level) %>%
  group_by(var, level) %>%
  summarise(val = n())%>%
  spread(var, val, fill = 0) %>%
  mutate_at(vars(-level), ~./20)


#Question 4
l<- c("CC", "GG", "AA", "TT")
MyDF5<- MyDF4 %>% filter(level %in% l) %>% select(-level) %>% summarise(across(everything(), sum))

`%notin%` <- Negate(`%in%`) #create a 'not in' function

MyDF6<- MyDF4 %>% filter(level %notin% l) %>% select(-level) %>% summarise(across(everything(), sum))

a<-bind_rows(MyDF5, MyDF6)


#Question 5


MyDF7<-MyDF3 %>% mutate_at(vars(-level), ~.^2) %>% select(-level) %>% summarise(across(everything(), sum))


MyDF7<-MyDF3 %>% mutate_at(vars(-level), ~.^2) %>% select(-level) %>% summarise(across(everything(), sum))


