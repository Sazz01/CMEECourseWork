MyData <- read.csv("../data/GenomeSize.csv")
head(MyData)

#The variables of interest are BodyWeight and TotalLength. Let’s use the dragonflies data subset.

#So subset the data accordingly and remove NAs:

Data2Fit <- subset(MyData,Suborder == "Anisoptera")

Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] 


plot(Data2Fit$TotalLength, Data2Fit$BodyWeight, xlab = "Body Length", ylab = "Body Weight")


library("ggplot2")
require("minpack.lm")

ggplot(Data2Fit, aes(x = TotalLength, y = BodyWeight)) + 
  geom_point(size = (3),color="red") + theme_bw() + 
  labs(y="Body mass (mg)", x = "Wing length (mm)")


nrow(Data2Fit)


PowFit <- nlsLM(BodyWeight ~ a * TotalLength^b, data = Data2Fit, start = list(a = .1, b = .1))

PowFit 


powMod <- function(x, a, b) {
  return(a * x^b)
}

PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength,a,b), data = Data2Fit, start = list(a = .1, b = .1))



Lengths <- seq(min(Data2Fit$TotalLength),max(Data2Fit$TotalLength),len=200)
coef(PowFit)["a"]
coef(PowFit)["b"]



Predic2PlotPow <- powMod(Lengths,coef(PowFit)["a"],coef(PowFit)["b"])


plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)



summary(PowFit)

print(confint(PowFit))
hist(residuals(PowFit))


#1

Lengths<- as.data.frame(Lengths)
Lengths$Predic2PlotPow<-Predic2PlotPow

ggplot(Data2Fit, aes(x = TotalLength, y = BodyWeight)) + geom_point() +
  geom_line(data = Lengths, aes(y = Predic2PlotPow, x= Lengths))  + geom_text(aes(x= 50, y= 0.3, label=(paste(expression("Weight ==  3.94e-06 * Length^2.59")))),size = 4, parse = TRUE)



#2

Data2Fit <- subset(MyData,Suborder == "Zygoptera")
Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] 
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight, xlab = "Body Length", ylab = "Body Weight")

powMod <- function(x, a, b) {
  return(a * x^b)
}

PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength,a,b), data = Data2Fit, start = list(a = 0.0011, b = 0.3))
coef(PowFit)

summary(PowFit)

Lengths <- seq(min(Data2Fit$TotalLength),max(Data2Fit$TotalLength),len=200)
coef(PowFit)["a"]
coef(PowFit)["b"]



Predic2PlotPow <- powMod(Lengths,coef(PowFit)["a"],coef(PowFit)["b"])


plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)


#3


a <- lm(log(BodyWeight) ~ log(TotalLength), data = Data2Fit)
summary(a)
exp(-15.0045)
exp(2.9556)



#4


Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] 
plot(Data2Fit$TotalLength, Data2Fit$ForewingLength, xlab = "Body Length", ylab = "Body Weight")

PowFit <- nlsLM(ForewingLength ~ powMod(TotalLength,a,b), data = Data2Fit, start = list(a = 15, b = 1))
coef(PowFit)
summary(PowFit)


a <- lm(log(ForewingLength) ~ log(TotalLength), data = Data2Fit)

exp(-1.012)
exp(1.13861)


