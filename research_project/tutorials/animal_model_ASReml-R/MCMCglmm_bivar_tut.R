#date: 17th Jan 2022
#author: Sarah Dobson
#name: MCMCglmm_bivar_tut.R
#description:  demonstrate how to run a multivariate animal model using the R package MCMCglmm and example data files provided.

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


######Priors#########

#Fitting a multivariate model in MCMCglmm involves several new consideration compared to a univariate model
# First, we have to fit multivariate priors; second, we have to specify the ways in which effects on different traits may covary, including the nature of
#residual (co)variation; and third, we will have to be a little more specific when specifying to MCMCglmm what type of distributions from which we assume our data are 
#drawn.

prior2.1 <- list(G = list(G1 = list(V = diag(2), n = 1.002)), R = list(V = diag(2), n = 1.002)) # the prior is constructed similarly to the univariate models in tutorial 1
#only we are specifying a 2x2 covariance matrix rather than a single variance. To get proper priors the degree of belief parameter (n) to greater than 1 =(1.002). 


model2.0 <- MCMCglmm(cbind(BWT, TARSUS) ~ trait - 1, random = ~us(trait):animal, rcov = ~us(trait):units, family = c("gaussian", "gaussian"), pedigree = Ped, data = Data, prior = prior2.1, verbose = FALSE)
#cbind to specifies the two response variables, body weight and tarsus length.
#The nature of genetic and residual (co)variance (between and) of the traits is specified as unstructured matrices, the most general structure available for this type of data. 
#Finally, we have specified that we wish to treat both traits as gaussian responses.


plot(model2.0$VCV)

plot(model2.0$VCV[, "traitTARSUS:traitTARSUS.animal"])


autocorr(model2.0$VCV)[, , "traitTARSUS:traitTARSUS.animal"][3, 4]

autocorr(model2.0$VCV)


model2.1<-MCMCglmm(cbind(BWT,TARSUS)~trait-1,
                   random=~us(trait):animal,
                   rcov=~us(trait):units,
                   family=c("gaussian","gaussian"),
                   pedigree=Ped,data=Data,
                   nitt=130000,thin=100,burnin=30000, prior=prior2.1,verbose=FALSE)


autocorr(model2.1$VCV)[, , "traitTARSUS:traitTARSUS.animal"][3, 4] #This level of autocorrelation is more acceptable, at least for the purpose of demonstration in this tutorial.




#####Calculating variance componenet, heritabilities and genetic correlations from bivariate models######



posterior.mode(model2.1$VCV)


heritability.BWT2.1 <- model2.1$VCV[, "traitBWT:traitBWT.animal"]/(model2.1$VCV[,"traitBWT:traitBWT.animal"] + model2.1$VCV[, "traitBWT:traitBWT.units"])
posterior.mode(heritability.BWT2.1)

heritability.TARSUS2.1 <- model2.1$VCV[, "traitTARSUS:traitTARSUS.animal"]/(model2.1$VCV[,"traitTARSUS:traitTARSUS.animal"] + model2.1$VCV[, "traitTARSUS:traitTARSUS.units"])
posterior.mode(heritability.TARSUS2.1)


genetic.correlation2.1 <- model2.1$VCV[, "traitBWT:traitTARSUS.animal"]/sqrt(model2.1$VCV[, "traitBWT:traitBWT.animal"] * model2.1$VCV[, "traitTARSUS:traitTARSUS.animal"])
posterior.mode(genetic.correlation2.1)


####Adding fixed and random effects to bivariate models####


#Given that our full model of BWT from tutorial 1 had SEX as a fixed effect as well as random effects of BYEAR
#and MOTHER we could specify a bivariate formulation of this using the following code:


prior2.2<-list(G=list(G1=list(V=diag(2),n=1.002),
                      G2=list(V=diag(2),n=1.002),
                      G3=list(VV=diag(2),n=1.002)),
               R=list(V=diag(2),n=1.002))



model2.2<-MCMCglmm(cbind(BWT,TARSUS)~trait-1+trait:SEX,
                   random=~us(trait):animal+us(trait):BYEAR+us(trait):MOTHER,
                   rcov=~us(trait):units,
                   family=c("gaussian","gaussian"),
                   pedigree=Ped,data=Data,
                   nitt=130000,thin=100,burnin=30000,
                   prior=prior2.2,verbose=FALSE)

posterior.mode(model2.2$VCV)


genetic.correlation2.2 <- model2.2$VCV[, "traitBWT:traitTARSUS.animal"]/sqrt(model2.2$VCV[,"traitBWT:traitBWT.animal"] * model2.2$VCV[, "traitTARSUS:traitTARSUS.animal"])


maternal.correlation2.2 <- model2.2$VCV[, "traitBWT:traitTARSUS.MOTHER"]/sqrt(model2.2$VCV[,"traitBWT:traitBWT.MOTHER"] * model2.2$VCV[, "traitTARSUS:traitTARSUS.MOTHER"])


posterior.mode(genetic.correlation2.2)

posterior.mode(maternal.correlation2.2)

#Evaluation of the statistical support for these genetic and maternal correlations is
#straightforward. Because we imposed no constraint on their estimation, we can evaluate
#the extent to which the posterior distributions overlap zero:
HPDinterval(genetic.correlation2.2, 0.95)
HPDinterval(maternal.correlation2.2, 0.95) # neither overlap zero, so they can be considered statistically supported.


