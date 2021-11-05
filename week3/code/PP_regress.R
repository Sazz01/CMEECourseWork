rm(list = ls())

#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: this script calculates the regression results of subsets of the data corresponding to available Feeding Type Predator life Stage combinations eand saves it 
#to a csv delimited table called (PP_Regress_Results.csv), in the results directory.

#####Load and inspect the Data################
MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
dim(MyDF) #check the size of the data frame you loaded
head(MyDF$Type.of.feeding.interaction)

require(dplyr)
require(tidyr)
require(plyr)
require(purrr)
require(broom)
require(ggplot2)

################regression analysis of Predator.mass by Prey.mass for every Feeding Type and Predator lifestage#################################################




MyDF <- MyDF %>% select(Type.of.feeding.interaction, Predator.lifestage, Predator.mass, Prey.mass, Prey.mass.unit) #filter dataframe out so that only the necessary columns are present

MyDF <-MyDF %>% mutate(Prey.mass = if_else(Prey.mass.unit == "mg", (Prey.mass/1000), Prey.mass)) #convert prey masses with mg units into grams.

Tidy_coef<-MyDF %>% unite("Feeding_Type", Type.of.feeding.interaction:Predator.lifestage) %>% group_by(Feeding_Type) %>% #combine Type.of.feeding.interaction and Predator.lifestage columns into one, and then group them by this new column
  do(model = tidy(lm(log10(Predator.mass) ~ log10(Prey.mass), data = .))) %>% unnest(model)  %>% #once grouped, do linear rgeression analysis on all these groups separately, tidy and unnest extract the coefficients the intercept and Prey.mass of each model into a new dataframe
  pivot_wider(names_from = "term", values_from = c(estimate, std.error, statistic, p.value)) %>% #the term column is removed, and instead separate columns for standard error, t-value, p.value and estimate of the intercept and Prey.mass are made.
  select("Feeding_Type", "estimate_(Intercept)", "estimate_log10(Prey.mass)")

Glance_coef<-MyDF %>% unite("Feeding_Type", Type.of.feeding.interaction:Predator.lifestage) %>% group_by(Feeding_Type) %>%
  do(model = glance(lm(log10(Predator.mass) ~ log10(Prey.mass), data = .))) %>% #glance extracts the Regression coefficients of each model
  unnest(model) %>% select("Feeding_Type", "r.squared", "statistic", "p.value")


###rename columns in each dataframe so that they are easier to read

Glance_coef$F_statistic <- Glance_coef$statistic
Glance_coef$statistic <- NULL
Glance_coef$regression_p.value<- Glance_coef$p.value
Glance_coef$p.value <- NULL

Tidy_coef$Intercept<- Tidy_coef$`estimate_(Intercept)`
Tidy_coef$Slope<- Tidy_coef$`estimate_log10(Prey.mass)`


Tidy_coef$`estimate_log10(Prey.mass)`<- NULL
Tidy_coef$`estimate_(Intercept)`<-NULL


#merge them into one dataframe

Regression_ouputs <-merge(x = Tidy_coef, y = Glance_coef, by = "Feeding_Type", all.x = TRUE)



#####save dataframe as a cscv file into results folder

write.csv(Regression_ouputs, "../results/PP_Regress_Results.csv")


#######Saving Regression Plots as PDF file in results##################################################

p <- ggplot(MyDF, aes(x = Prey.mass, y = Predator.mass, colour = Predator.lifestage )) 

p+ scale_x_log10("Prey.mass in grams")+ scale_y_log10("Predator.mass in grams")+geom_point(shape = 3)+ facet_wrap(~Type.of.feeding.interaction, ncol= 1) +
  facet_grid( Type.of.feeding.interaction~ .,) + geom_smooth(method = "lm", fullrange = TRUE) + theme_bw() +theme(legend.position = "bottom", plot.margin = unit(c(1,3,1,3), "cm"))


pdf("../results/Regression_plots.pdf", 8.3, 11.7)
print(p)
graphics.off()


print("Script complete!")



