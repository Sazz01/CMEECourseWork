rm(list = ls())
#AUTHOR: Sarah Dobson
#DATE: 24th January 2022
#DESCRIPTION: calculting heritability on the latent scale in univariate models

####required packages###
require(tidyverse)
require(MCMCglmm)
require(purrr)


##reading in models###
model1<-readRDS("../results/model_Female_T_P1_NC_NP")
model2<-readRDS("../results/model_Male_P_P1_NC_NP")
model3<-readRDS("../results/model_Female_T_P1_NC_WP")
model4<-readRDS("../results/model_Male_P_P1_NC_WP")
model5<-readRDS("../results/model_Female_T_P1_IGE")
model6<-readRDS("../results/model_Male_P_P1_IGE")
model7<-readRDS("../results/model_Female_T_P1_IGE_Cov")
model8<-readRDS("../results/model_Male_P_P1_IGE_Cov")


###function for computing fixed effect variance 

compute_varpred <- function(beta, design_matrix) {
  var(as.vector(design_matrix %*% beta))
}

##models with DGE + ID#####



###compute fixed effect variance

X <- model1[["X"]]
vf <- apply(model1[["Sol"]], 1, compute_varpred, design_matrix = X)

Y <- model2[["X"]]
vf2 <- apply(model2[["Sol"]], 1, compute_varpred, design_matrix = Y)

###compute phenotypic variance

vpFE = rowSums(model1[["VCV"]]+ vf)
vpFE2 = rowSums(model2[["VCV"]]+ vf2)


##latent heritabilites
##femlale
var.a = model1[["VCV"]][ , "animal"]
herit1<- (var.a /vpFE)
HPDinterval(as.mcmc(herit1))







##models with DGE + ID + Partner PE #####

###compute fixed effect variance

X <- model3[["X"]]
vf <- apply(model3[["Sol"]], 1, compute_varpred, design_matrix = X)

Y <- model4[["X"]]
vf2 <- apply(model4[["Sol"]], 1, compute_varpred, design_matrix = Y)

###compute phenotypic variance

vpFE = rowSums(model3[["VCV"]]+ vf)
vpFE2 = rowSums(model4[["VCV"]]+ vf2)


##latent heritabilites
##femlale
var.a = model3[["VCV"]][ , "animal"]
herit3<- (var.a /vpFE)
HPDinterval(as.mcmc(herit3))


##male
var.a2 = model4[["VCV"]][ , "animal"]
herit4<- (var.a2 /vpFE)
HPDinterval(as.mcmc(herit4))





##models with DGE + ID + Partner PE + Partner IGEs#####


###compute fixed effect variance

X <- model5[["X"]]
vf <- apply(model5[["Sol"]], 1, compute_varpred, design_matrix = X)

Y <- model6[["X"]]
vf2 <- apply(model6[["Sol"]], 1, compute_varpred, design_matrix = Y)

###compute phenotypic variance

vpFE = rowSums(model5[["VCV"]]+ vf)
vpFE2 = rowSums(model6[["VCV"]]+ vf2)


##latent heritabilites
##femlale
var.a = model5[["VCV"]][ , "animal"]
herit5<- (var.a /vpFE)
HPDinterval(as.mcmc(herit5))


##male
var.a2 = model6[["VCV"]][ , "animal"]
herit6<- (var.a2 /vpFE)
HPDinterval(as.mcmc(herit6))




##models with cov(DGE + Partner IGEs) + ID + Partner PE#####

###compute fixed effect variance


X <- model7[["X"]]
vf <- apply(model7[["Sol"]], 1, compute_varpred, design_matrix = X)

Y <- model8[["X"]]
vf2 <- apply(model8[["Sol"]], 1, compute_varpred, design_matrix = Y)

###compute phenotypic variance

vpFE <- vf +(model7[["VCV"]][ , "Partner.Partner"] + model7[["VCV"]][ , "animal.animal"]+model7[["VCV"]][ , "ID2"]+model7[["VCV"]][ , "Partner2"]+model7[["VCV"]][ , "units"])
vpFE2 <- vf2 +(model8[["VCV"]][ , "Partner.Partner"] + model8[["VCV"]][ , "animal.animal"]+model8[["VCV"]][ , "ID2"]+model8[["VCV"]][ , "Partner2"]+model8[["VCV"]][ , "units"])


##latent heritabilites
##femlale
var.a = model7[["VCV"]][ , "animal"]
herit7<- (var.a /vpFE)
HPDinterval(as.mcmc(herit7))


##male
var.a2 = model6[["VCV"]][ , "animal"]
herit8<- (var.a2 /vpFE2)
HPDinterval(as.mcmc(herit8))

