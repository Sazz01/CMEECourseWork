rm(list = ls())

#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: Writes a script that draws and saves three figures, each containing subplots of distributions of predator mass, prey mass, and the size ratio of prey mass over predator mass by feeding interaction type.
#also calculate the (log) mean and median predator mass, prey mass and predator-prey size-ratios to a csv file and moves it to the results folder.

#######Load and Inspect the data###########################

MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")
dim(MyDF) #check the size of the data frame you loaded
head(MyDF$Type.of.feeding.interaction)



require("tidyverse") 

###Fix prey.mass.unit column and add ratio column#####
MyDF <-MyDF %>% mutate(Prey.mass = if_else(Prey.mass.unit == "mg", (Prey.mass/1000), Prey.mass)) #convert prey masses with mg units into grams.
MyDF<-MyDF %>% mutate(Ratio =Prey.mass/Predator.mass) #create the ratio






#######Calculating the medians and means of Predator.mass, Prey.mass and Predator.mass/Prey.mass ratio for all feeding types#######################


MyDF2 <- MyDF %>%
  select(Predator.mass, Prey.mass, Ratio, Type.of.feeding.interaction) #filter data to columns of interest
#log10 all the numerical columns, as they all have non normal distribution
MyDF2 <- MyDF2 %>% 
  mutate(Predator.mass = log10(Predator.mass)) %>% 
  mutate(Prey.mass = log10(Prey.mass)) %>% 
  mutate(Ratio = log10(Ratio)) 

#calculating the mean for all columns by interaction type

Mean_df <- MyDF2 %>% 
  group_by(Type.of.feeding.interaction) %>% summarise_all(funs(mean)) %>%
  rename_at(vars(2:4) ,function(x){paste0("Mean.", x)})  #

#calculating the median for all the columns by interaction type

Median_df <- MyDF2 %>% group_by(Type.of.feeding.interaction) %>% summarise_all(funs(median)) %>% 
  rename_at(vars(2:4) ,function(x){paste0("Median.", x)}) 

#joining them together and vioolaa

Data_sunmmary<- left_join(Mean_df, Median_df)



#save it 
write.csv(Data_sunmmary, "../results/PP_results.csv")



############# Plotting the distribution of Prey Body Mass via Feeding Interaction Types###############

pdf("../results/Prey_Subplots.pdf", 11.7, 8.3)


par(mfcol=c(2,3)) #initialize multi-paneled plot, 2 by 3 panels
par(mfg = c(1,1)) # specify which sub-plot to use first 
par(mar = c(4, 4, 6, 5))


hist(log10(MyDF$Prey.mass[MyDF$Type.of.feeding.interaction == "insectivorous"]), # Predator histogram
     xlab="log10(Prey Body Mass (g))", 
     ylab= "Frequency", 
     xlim = c(-8, -3),
     xaxs = "i",
     yaxs="i",
     ylim = c(0, 15),
     col = rgb(1, 0, 0, 1),
     main = NULL) # Note 'rgb', fourth value is transparency
title("Insectivorous", line = 0.1)

par(mfg = c(1,2)) # Second sub-plot

par(mar = c(4, 4, 6, 5))
hist(log10(MyDF$Prey.mass[MyDF$Type.of.feeding.interaction == "predacious/piscivorous"]), 
     xlab="log10(Prey Body Mass (g))", ylab="Frequency", 
     xlim = c(-2, 3),
     ylim = c(0, 70),
     xaxs = "i",
     yaxs="i",
     col = rgb(0, 0, 1, 1), # Note 'rgb', fourth value is transparency
     main = NULL) 
title("Predacious/Piscivorous", line = 0.1)

par(mfg = c(1,3))
par(mar = c(4, 4, 6, 5))
hist(log10(MyDF$Prey.mass[MyDF$Type.of.feeding.interaction == "piscivorous"]), 
     xlab="log10(Prey Body Mass (g))", ylab="Frequency", 
     xlim= c(-5, 4),
     ylim = c(0, 4000),
     xaxs = "i",
     yaxs="i",
     col = rgb(0, 0.8, 0.4, 0.3),
     main = NULL) # Note 'rgb', fourth value is transparency
title("Piscivorous", line = 0.1)


par(mfg = c(2,1))
par(mar = c(4, 4, 6, 5))
hist(log10(MyDF$Prey.mass[MyDF$Type.of.feeding.interaction == "predacious"]), 
     xlab="log10(Prey Body Mass (g))", ylab="Frequency", 
     xlim= c(-10, 5),
     ylim = c(0, 3000),
     xaxs = "i",
     yaxs="i",
     col = rgb(0.5, 0.3, 0.9, 0.4),  # Plot prey
     main = NULL)
title("Predacious", line =0.1)


par(mfg = c(2,2))
par(mar = c(4, 4, 6, 5))
hist(log10(MyDF$Prey.mass[MyDF$Type.of.feeding.interaction == "planktivorous"]), 
     xlab="log10(Prey Body Mass (g))", ylab="Frequency", 
     xlim= c(-15, 5),
     ylim = c(0, 800),
     xaxs = "i",
     yaxs="i",
     col = rgb(0.9, 0.9, 0, 0.6),# Plot prey
     main = NULL)
title("Planktivorous", line = 0.1)

mtext("Histograms of Prey Body Mass via Types of Feeding Interactions",                   # Add main title
      side = 3,
      line = - 2,
      outer = TRUE)
graphics.off();





############# Plotting the distribution of Predator Body Mass via Feeding Interaction Types###############
pdf("../results/Pred_Subplots.pdf", 11.7, 8.3)


par(mfcol=c(2,3)) #initialize multi-paneled plot
par(mfg = c(1,1)) # specify which sub-plot to use first 
par(mar = c(4, 4, 6, 5))

hist(log10(MyDF$Predator.mass[MyDF$Type.of.feeding.interaction == "insectivorous"]), # Predator histogram
     xlab="log10(Predator Body Mass (g))", 
     ylab="Frequency", 
     xlim = c(-2, 3),
     ylim = c(0, 15),
     xaxs = "i",
     yaxs="i",
     col = rgb(1, 0, 0, 1), # Note 'rgb', fourth value is transparency
     main = NULL)
title("Insectivorous", line = 0.1)



par(mfg = c(1,2)) # Second sub-plot
par(mar = c(4, 4, 6, 5))

hist(log10(MyDF$Predator.mass[MyDF$Type.of.feeding.interaction == "predacious/piscivorous"]), # Predator histogram
     xlab="log10(Predator Mass (g))", ylab="Frequency", 
     xlim = c(1, 4),
     ylim = c(0, 45),
     xaxs = "i",
     yaxs="i",
     col = rgb(0, 0, 1, 1), # Note 'rgb', fourth value is transparency
     main = NULL)
title("Predacious/Piscivorous", line = 0.1)

par(mfg = c(1,3))
par(mar = c(4, 4, 6, 5))

hist(log10(MyDF$Predator.mass[MyDF$Type.of.feeding.interaction == "piscivorous"]), # Predator histogram
     xlab="log10(Predator Body Mass (g))", 
     ylab="Frequency", 
     xlim= c(-4, 8),
     ylim = c(0, 7000),
     xaxs = "i",
     yaxs="i",
     col = rgb(0, 0.8, 0.4, 0.3), # Note 'rgb', fourth value is transparency
     main = NULL)
title("Piscivorous", line = 0.1)


par(mfg = c(2,1))
par(mar = c(4, 4, 6, 5))

hist(log10(MyDF$Predator.mass[MyDF$Type.of.feeding.interaction == "predacious"]), 
     xlab="log10(Predator Body Mass (g))", ylab="Frequency", 
     xlim= c(-5, 8),
     ylim = c(0, 2200),
     xaxs = "i",
     yaxs="i",
     col = rgb(0.5, 0.3, 0.9, 0.4),  # Plot prey
     main = NULL)
title("Predacious", line = 0.1)


par(mfg = c(2,2))
par(mar = c(4, 4, 6, 5))

hist(log10(MyDF$Predator.mass[MyDF$Type.of.feeding.interaction == "planktivorous"]), 
     xlab="log10(Predator Body Mass (g))", ylab="Frequency", 
     xlim= c(-5, 5),
     ylim = c(0, 600),
     xaxs = "i",
     yaxs="i",
     col = rgb(0.9, 0.9, 0, 0.6),# Plot prey
     main = NULL)
title("Planktivorous", line = 0.1)


mtext("Histograms of Predator Body Mass via Types of Feeding Interactions",                   # Add main title
      side = 3,
      line = - 2,
      outer = TRUE)
graphics.off()



#the size ratio of prey mass over predator mass by feeding interaction type




############# Plotting the distribution of Prey:Predator Body Mass Ratio via Feeding Interaction Types###############

pdf("../results/SizeRatio_Subplots.pdf", 11.7, 8.3)


par(mfcol=c(2,3)) #initialize multi-paneled plot
par(mfg = c(1,1)) # specify which sub-plot to use first 
par(mar = c(4, 4, 6, 5))
hist(log10(MyDF$Ratio[MyDF$Type.of.feeding.interaction == "insectivorous"]), # Predator histogram
     xlab="log10(Prey:Predator Body Mass Ratio(g))", 
     ylab="Frequency", 
     xlim = c(-8, -2),
     ylim = c(0, 15),
     xaxs = "i",
     yaxs="i",
     col = rgb(1, 0, 0, 1), # Note 'rgb', fourth value is transparency
     main = NULL) 
title("Insectivorous", line = 0.1)
      
par(mfg = c(1,2)) # Second sub-plot
par(mar = c(4, 4, 6, 5))

hist(log10(MyDF$Ratio[MyDF$Type.of.feeding.interaction == "predacious/piscivorous"]), # Predator histogram
     xlab="log10(Prey:Predator Body Mass Ratio(g))", ylab="Frequency", 
     xlim = c(-5, 0),
     ylim = c(0, 65),
     xaxs = "i",
     yaxs="i",
     col = rgb(0, 0, 1, 1), # Note 'rgb', fourth value is transparency
     main = NULL) 
title("Predacious/Piscivorous", line = 0.1)

par(mfg = c(1,3))
par(mar = c(4, 4, 6, 5))

hist(log10(MyDF$Ratio[MyDF$Type.of.feeding.interaction == "piscivorous"]), # Predator histogram
     xlab="log10(Prey:Predator Body Mass Ratio(g))", 
     ylab="Frequency", 
     xlim= c(-8, 2),
     ylim = c(0, 4000),
     xaxs = "i",
     yaxs="i",
     col = rgb(0, 0.8, 0.4, 0.3), # Note 'rgb', fourth value is transparency
     main = NULL)
title("Piscivorous", line = 0.1)

par(mfg = c(2,1))
par(mar = c(4, 4, 6, 5))

hist(log10(MyDF$Ratio[MyDF$Type.of.feeding.interaction == "predacious"]), 
     xlab="log10(Prey:Predator Body Mass Ratio (g))", ylab="Frequency", 
     xlim= c(-8, 4),
     ylim = c(0, 5000),
     xaxs = "i",
     yaxs="i",
     col = rgb(0.5, 0.3, 0.9, 0.4),  # Plot prey
     main = NULL)
title("Predacious", line = 0.1)


par(mfg = c(2,2))
par(mar = c(4, 4, 6, 5))


hist(log10(MyDF$Ratio[MyDF$Type.of.feeding.interaction == "planktivorous"]), 
     xlab="log10 Prey:Predator Body Mass Ratio (g))", ylab="Frequency", 
     xlim= c(-8, 2),
     ylim = c(0, 400),
     xaxs = "i",
     yaxs="i",
     col = rgb(0.9, 0.9, 0, 0.6),# Plot prey
     main = NULL)
title("Planktivorous", line = 0.1)


mtext("Histograms of Prey:Predator Body Mass Ratios via Types of Feeding Interactions",                 
      side = 3,
      line = - 2,
      outer = TRUE)
graphics.off()

print("Script complete!")







