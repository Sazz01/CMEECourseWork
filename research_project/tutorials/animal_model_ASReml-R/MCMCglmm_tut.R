#date: 14th Jan 2022
#author: Sarah Dobson
#name: MCMCglmm_tut.R
#description: this script demonstrates how to (1) correctly run and test assumptions on an animal model using r package MCMCglmm, (2) calculate heritability from an animal model (3) add random and fixed effects to an animal model (4) model selection


library("MCMCglmm")



####load and inspect data####
Data <- as.data.frame(read.table(file = "gryphon.txt", header = TRUE))
names(Data)[1] <- "animal"

for (x in 1:4) Data[, x] <- as.factor(Data[, x])
Data$BWT <- as.numeric(Data$BWT)
Data$TARSUS <- as.numeric(Data$TARSUS)
head(Data)

Ped <- as.data.frame(read.table(file = "./gryphonped.txt", header = TRUE))
for (x in 1:3) Ped[, x] <- as.factor(Ped[, x])
head(Ped)


########How to run animal models in mcmcmglmmm#######

prior1.1 <- list(G = list(G1 = list(V = 1, nu = 0.002)), R = list(V = 1, nu = 0.002))


model1.1 <- MCMCglmm(BWT ~ 1, random = ~animal, pedigree = Ped, data = Data, prior = prior1.1)
plot(model1.1$Sol)
plot(model1.1$VCV) #can see autocorrelation, especially in the left hand side graphs. This means we cannot trust the posterior distributions of our variance/variables components

###to try and get rid of autocorreltation run the model for longer, with longer intervals
model1.2 <- MCMCglmm(BWT ~ 1, random = ~animal, pedigree = Ped, data = Data, nitt = 65000, thin = 50, burnin = 15000, prior = prior1.1, verbose = FALSE)
plot(model1.2$Sol)
plot(model1.2$VCV) #they look much better now- more like a ''fuzzy cattepillar''

#another way to test for correlation more formally/ distinctly.


autocorr(model1.2$VCV)


#normally these values wouldnt be accepted( still to nigh) and should be as close to zero as possible, but they are suffiecicent for this tutorial.


#We can obtain estimates of the additive genetic and residual variance by calculating the modes of the posterior distributions:


posterior.mode(model1.2$VCV)

#We can obtain the Bayesian equivalent of confidence intervals by calculating the values of the estimates that bound 95% (or any other proportion) of the posterior distributions:

HPDinterval(model1.2$VCV)


#we used weak priors to obtain this results, would proper priors have influenced the results? A way to test this to rerun the model with proper priors by defining a prior with a higher belief parameter and 
#we will specify that a large proportion of the variation is under genetic control

p.var <- var(Data$BWT, na.rm = TRUE)


prior1.3 <- list(G = list(G1 = list(V = matrix(p.var * 0.05), nu = 1)), R = list(V = matrix(p.var * 0.95), nu = 1))


model1.3 <- MCMCglmm(BWT ~ 1, random = ~animal, pedigree = Ped, data = Data, prior = prior1.3, nitt = 65000, thin = 50, burnin = 15000, verbose = FALSE)

plot(model1.3$Sol)
plot(model1.3$VCV)

posterior.mode(model1.3$VCV)
HPDinterval(model1.3$VCV) #as you can see, theres hardly any difference, and so we can conclude that the prior used has no effect on outcome, 
#which is common when there is a lot of data and the model itself is simple



######Estimating Heritability#########

#A useful property of Bayesian posterior distributions is that we can apply almost any transformation to these distributions and they will remain valid. 
# We can obtain an estimate of the heritability by applying the basic formula h2=VA/VP to each sample of the posterior disribution:





posterior.heritability1.1 <- model1.2$VCV[, "animal"]/(model1.2$VCV[, "animal"] + model1.2$VCV[, "units"])
HPDinterval(posterior.heritability1.1, 0.95)
posterior.mode(posterior.heritability1.1)


#Generate a plot of the posterior distribution of this heritability estimate


plot(posterior.heritability1.1)



####Adding fixed effects####


#To add effects to a univariate model modify the fixed effect portion of the model specification


model1.4 <- MCMCglmm(BWT ~ SEX, random = ~animal, pedigree = Ped, data = Data, prior = prior1.1, nitt = 65000, thin = 50, burnin = 15000, verbose = FALSE)


##assess the significance of SEX as a fixed affact by looking at the posterior distribution

summary(model1.4)
posterior.mode(model1.4$Sol[, "SEX2"])

HPDinterval(model1.4$Sol[, "SEX2"], 0.95)

posterior.mode(model1.4$VCV)
posterior.mode(model1.2$VCV) #sex was previosuly contributing to Vr, which is now slightly lower than before


#if we calculate VP as VA+VR then fixed effects will soak up more residual variance driving VP. 
#Assuming that VA is more or less unaffected by the fixed effects fitted then as VP goes down we expect our estimate of h2 will go up.


posterior.heritability1.2 <- model1.4$VCV[, "animal"]/(model1.4$VCV[,"animal"] + model1.4$VCV[, "units"])


posterior.mode(posterior.heritability1.2)
posterior.mode(posterior.heritability1.1) #heritability estimate did go up once sex was introduced as a fixed effect


HPDinterval(posterior.heritability1.2, 0.95)
HPDinterval(posterior.heritability1.1, 0.95)


#####Adding random effects#######


#This is done by simply modifying the model statement in the same way, but requires addition of a prior for the new random effect.
#For instance, we can fit an effect of birthyear:


prior1.5 <- list(G = list(G1 = list(V = 1, n = 0.002), G2 = list(V = 1, n = 0.002)), R = list(V = 1, n = 0.002))



model1.5 <- MCMCglmm(BWT ~ SEX, random = ~animal + BYEAR, pedigree = Ped, data = Data, nitt = 65000, thin = 50, burnin = 15000, prior = prior1.5, verbose = FALSE)

posterior.mode(model1.5$VCV)
#variance in birth weight explained by birth year is 0.7887. Although VA has changed somewhat, most of what is now partitioned as a birth year effect was
#previously partitioned as VR. Thus what we have really done here is to partition environmental effects into those arising from year to year differences
#versus everything else, andwe do not really expect much change in h2 (since now h2 = VA/(VA + VBY + VR)).




#Howveer, what if we added a MOTHER random effect to account for maternal effects?

p.var <- var(Data$BWT, na.rm = TRUE)


prior1.6 <- list(G = list(G1 = list(V = 1, n = 0.002), G2 = list(V = 1, n = 0.002), G3 = list(V = 1, n = 0.002)), R = list(V = 1, n = 0.002))

model1.6 <- MCMCglmm(BWT ~ SEX, random = ~animal + BYEAR + MOTHER, pedigree = Ped, data = Data, nitt = 65000, thin = 50, burnin = 15000, prior = prior1.6, verbose = FALSE)

posterior.mode(model1.6$VCV)
#Here partitioning of significant maternal variance decreases VR and VA. The latter is because maternal effects of the sort we simulated
#(fixed differences between mothers) increases the similarity among maternal siblings. Consequently they can look very much like additive
#genetic effects and if present, but unmodelled, represent a type of ‘common environment effect’ that can - and will- cause upward bias in VA and so h2.
#Let’s compare the estimates of heritability from each model we have done so far:


posterior.heritability1.3 <- model1.5$VCV[, "animal"]/(model1.5$VCV[,"animal"] + model1.5$VCV[, "BYEAR"] + model1.5$VCV[, "units"])
posterior.heritability1.4 <- model1.6$VCV[, "animal"]/(model1.6$VCV[,"animal"] + model1.6$VCV[, "BYEAR"] + model1.6$VCV[, "MOTHER"] + model1.6$VCV[, "units"])


posterior.mode(posterior.heritability1.2)
posterior.mode(posterior.heritability1.3)
posterior.mode(posterior.heritability1.4)



######Testing significance of variance components#####


#The significance of fixed effects can be tested by evaluating whether or not their posterior distributions overlap zero.
#this approach does not work for variance components, as they are bound to be positive (given a proper prior), therefore even when a random effect is not
#meaningful, its posterior distribution will never overlap zero. Model comparisons can be performed using the deviance information
#criterion (DIC), although the properties of DIC are not well understood and that the DIC may be focused at the wrong level for most people’s intended
#level of infernce - particularly with non-Gaussian responses. 


model1.5$DIC

model1.6$DIC #model 1.6 has a much lower DIC value. Since the maternal effect term is the only
#difference between the models, we can consider the inclusion of this term statistically
#justifiable. We should note however that DIC has a large sampling variance and should
#probably only be calculated based on much longer MCMC runs.


