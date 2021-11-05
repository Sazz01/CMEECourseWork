rm(list=ls())

#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: 5th November 2021
#DESCRIPTION: calculating the correlation coefficient of Year and Annual Temperature in Florida and testing its significance.

##########

load("../data/KeyWestAnnualMeanTemperature.RData")

#turn temp and year into vectors
ats$Year<- as.vector(ats$Year)
ats$Temp<- as.vector(ats$Temp)

real <-cor(ats$Year, ats$Temp) #calculate correlation coefficient 


a<-rep(NA, 1000)  #rep creates a list of NA 1000 times


#for every number from 1 to 1000 replace the NAs in 'a' with the correlation coefficient from ats, where Temp has been mixed up using sample()
for (i in 1:1000){
 a[i] <- cor(ats$Year, sample(ats$Temp, replace = F))
    
}

print(a)


#plot the distribution of the coefficients
pdf("../results/Florida_subplotB.pdf", 11.7, 8.3)

par(mar=c(5, 8, 4, 2) + 0.1)
hist(a, xlab = "Randomised Correlation Coefficient", 
     ylab = "Frequency", xlim=c(-0.6, 0.6),
     xaxs = "i",
     yaxs="i",
     col= "grey", 
     cex.lab = 2,
     cex.axis = 1.5,
     main = NULL)
abline(v=real, col = "red", lwd = 5)
graphics.off()



###Plot the a scatterplot ###

pdf("../results/Florida_subplotA.pdf", 11.7, 8.3)

par(mar=c(5, 8, 4, 2) + 0.1)
plot(ats$Year, ats$Temp, ylim = c(23.5, 26.5), xlim = c(1900, 2000), 
     xlab = "Year", 
     cex.lab = 2,
     cex = 1.5,
     cex.axis = 1.5,
     ylab = "Annual Mean Temperature (\u00B0C)",
     )

abline(lm(ats$Temp ~ ats$Year), col = "red", lwd = 5)

graphics.off()

##calculating p value

B <-length(a[a>real])

B/1000 


print("Script complete!")

