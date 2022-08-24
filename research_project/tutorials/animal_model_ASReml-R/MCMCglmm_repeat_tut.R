#date: 17th Jan 2022
#author: Sarah Dobson
#name: MCMCglmm_repeat_tut.R



DataRM <- as.data.frame(read.table(file = "./gryphonRM.txt", header = TRUE))
names(DataRM)[1] <- "animal"
for (x in 1:4) DataRM[, x] <- as.factor(Data[, x])
DataRM$LAYDATE <- as.numeric(DataRM$LAYDATE)
head(DataRM)

DataRM$ID <- DataRM$animal
head(DataRM)

####estimatung repeatability of laying date######
p.var <- var(DataRM$LAYDATE, na.rm = TRUE)

prior3.1 <- list(G = list(G1 = list(V = 1, nu = 0.002)), R = list(V = 1, nu = 0.002))
model3.1 <- MCMCglmm(LAYDATE ~ 1, random = ~ID, data = DataRM, prior = prior3.1, verbose = FALSE)
posterior.mode(model3.1$VCV)

model3.2 <- MCMCglmm(LAYDATE ~ AGE, random = ~ID, data = DataRM, prior = prior3.1, verbose = FALSE)
plot(model3.2$Sol)
plot(model3.2$VCV)
posterior.mode(model3.2$VCV)


#####Partitioning additive and permanent environment effects######

#we expect repeatability will set the upper limit for heritability: while additive genetic effects will cause among-individual variation, so will other types of effect. 
#Non-additive contributions to fixed among-individual differences are normally referred to as ‘permanent environment effects’,
#although ‘non-heritable effects’ that are consistent within individuals may be a better way to think of modelling this effect. 
#If a trait has repeated measures then it is necessary to model permanent environment effects in an animal model to prevent upward bias in VA.

model3.3 <- MCMCglmm(LAYDATE ~ 1 + AGE, random = ~animal, pedigree = Ped, data = DataRM, prior = prior3.1, verbose = FALSE)


posterior.mode(model3.3$VCV)

#This suggests that all of the among-individual variance is - rightly or wrongly - being partitioned as VA here. 
#In fact here the partition is wrong since the simulation included both additive genetic effects (laydate) and additional fixed heterogeneity that was not associated
#with the pedigree structure (i.e. permanent environment effects(Age in this case)). An more appropriate estimate of VA is given by the model:


p.var <- var(DataRM$LAYDATE, na.rm = TRUE)
prior3.4 <- list(G = list(G1 = list(V = 1, n = 0.002), G2 = list(V = 1, n = 0.002)), R = list(V = 1, n = 0.002))
model3.4 <- MCMCglmm(LAYDATE ~ 1 + AGE, random = ~animal + ID, pedigree = Ped, data = DataRM, prior = prior3.4, verbose = FALSE) #add ID as a random effect to account for indivudal differences not associated with a pedigree 
posterior.mode(model3.4$VCV)

#The estimate of VA is now much lower (reduced from 13.6735 to 5.1238) since the additive and permanent environment effects are being properly separated.
#We could obtain estimates of h2 and of the repeatability from this model using the following commands:


model3.4.VP <- model3.4$VCV[, "animal"] + model3.4$VCV[, "ID"] + model3.4$VCV[, "units"]
model3.4.IDplusVA <- model3.4$VCV[, "animal"] + model3.4$VCV[,"ID"] #IDplusVA because repeatbiloty is determined by both permanenet environmental and genetic (pedigree) effects.
posterior.mode(model3.4.IDplusVA/model3.4.VP)



####Adding additional effects and testing significance####


#Models of repeated measures can be extended to include other fixed or random effects.
#For example try including year of measurement (YEAR).


p.var <- var(DataRM$LAYDATE, na.rm = TRUE)
prior3.5 <- list(G = list(G1 = list(V = 1, n = 0.002), G2 = list(V = 1, n = 0.002), G3 = list(V = 1, n = 0.002), G4 = list(V = 1, n = 0.002)), R = list(V = 1, n = 0.002))

model3.5 <- MCMCglmm(LAYDATE ~ 1 + AGE, random = ~animal + ID + YEAR + BYEAR, pedigree = Ped, data = DataRM, prior = prior3.5,verbose = FALSE)
posterior.mode(model3.5$VCV)


#This model will return additional variance components corresponding to year of measurement effects and birth year (of the female effects). 
#The latter were not simulated (do not have a significanrt effect on laydate repeatability?) as should be apparent from the parameter estimate (and by the support interval derivable
#from the posterior distribution and from DIC-based comparison of model3.5 and a model from which the birth year term had been eliminated, see tutorial 1).




#However, YEAR effects were simulated as should be apparent from the from the modal estimate and from the support interval (try this yourself using HPDinterval()) 
#and this could be formally confirmed by comparison of DIC. YEAR effects could alternatively be included as fixed effects (try this, you should be able to handle the new prior specification at this point). 


#Since we simulated large year of measurement effects this treatment will reduce VR and increase the the estimates of heritability and repeatability 
#which must now be interpreted as proportions of phenotypic variance after conditioning on both age and year of measurement effects.