rm(list = ls())
#AUTHOR: Sarah Dobson
#DATE: 24th January 2022
#DESCRIPTION: calculting heritability on the observed scale in univariate models
###required packages####
require(tidyverse)
require(MCMCglmm)
require(purrr)
require(QGglmm)


##read in models##
model1<-readRDS("../results/model_Female_T_P1_NC_NP")
model2<-readRDS("../results/model_Male_P_P1_NC_NP")
model3<-readRDS("../results/model_Female_T_P1_NC_WP")
model4<-readRDS("../results/model_Male_P_P1_NC_WP")
model5<-readRDS("../results/model_Female_T_P1_IGE")
model6<-readRDS("../results/model_Male_P_P1_IGE")
model7<-readRDS("../results/model_Female_T_P1_IGE_Cov")
model8<-readRDS("../results/model_Male_P_P1_IGE_Cov")


##DGE + PE models###

#female

#####compute predictions based on fixed effects
X <- model1[["X"]]
predict <- map(1:nrow(model1[["Sol"]]),
               ~ as.vector(X %*% model1[["Sol"]][., ]))

####run QGlmm package to get Va on the observed scale for every iteration
paramsPFE <-
  pmap_dfr(list(predict = predict,
                var.a = model1[["VCV"]][ , "animal"],
                var.p = rowSums(model1[["VCV"]])-1), #need to minus 1 so it backtransforms threshold 
           QGparams,
           model = "binom1.probit",
           verbose = FALSE)

mean(paramsPFE[["h2.obs"]])
HPDinterval(as.mcmc(paramsPFE[["h2.obs"]]))


###male


X <- model2[["X"]]
predict <- map(1:nrow(model2[["Sol"]]),
               ~ as.vector(X %*% model2[["Sol"]][., ]))

paramsPFE2 <-
  pmap_dfr(list(predict = predict,
                var.a = model2[["VCV"]][ , "animal"],
                var.p = rowSums(model2[["VCV"]])),
           QGparams,
           model = "Poisson.log",
           verbose = FALSE)

mean(paramsPFE2[["h2.obs"]])
HPDinterval(as.mcmc(paramsPFE2[["h2.obs"]]))



##DGE + PE + Partner PE models###
#####compute predictions based on fixed effects

#female

X <- model3[["X"]]
predict <- map(1:nrow(model3[["Sol"]]),
               ~ as.vector(X %*% model3[["Sol"]][., ]))

paramsPFE3 <-
  pmap_dfr(list(predict = predict,
                var.a = model3[["VCV"]][ , "animal"],
                var.p = rowSums(model3[["VCV"]])-1), #need to minus 1 so it backtransforms threshold 
           QGparams,
           model = "binom1.probit",
           verbose = FALSE)

mean(paramsPFE3[["h2.obs"]])
HPDinterval(as.mcmc(paramsPFE3[["h2.obs"]]))


###male


X <- model4[["X"]]
predict <- map(1:nrow(model4[["Sol"]]),
               ~ as.vector(X %*% model4[["Sol"]][., ]))

paramsPFE4 <-
  pmap_dfr(list(predict = predict,
                var.a = model4[["VCV"]][ , "animal"],
                var.p = rowSums(model4[["VCV"]])),
           QGparams,
           model = "Poisson.log",
           verbose = FALSE)

mean(paramsPFE4[["h2.obs"]])
HPDinterval(as.mcmc(paramsPFE4[["h2.obs"]]))





##DGE + PE + Partner PE + Partner IGE models###
#####compute predictions based on fixed effects

#female

X <- model5[["X"]]
predict <- map(1:nrow(model5[["Sol"]]),
               ~ as.vector(X %*% model5[["Sol"]][., ]))

paramsPFE5 <-
  pmap_dfr(list(predict = predict,
                var.a = model5[["VCV"]][ , "animal"]+ model5[["VCV"]][ , "Partner"],
                var.p = rowSums(model5[["VCV"]])-1), #need to minus 1 so it backtransforms threshold 
           QGparams,
           model = "binom1.probit",
           verbose = FALSE)

mean(paramsPFE5[["h2.obs"]])
HPDinterval(as.mcmc(paramsPFE5[["h2.obs"]]))


###male


X <- model6[["X"]]
predict <- map(1:nrow(model6[["Sol"]]),
               ~ as.vector(X %*% model6[["Sol"]][., ]))

paramsPFE6 <-
  pmap_dfr(list(predict = predict,
                var.a = model6[["VCV"]][ , "animal"]+ model6[["VCV"]][ , "Partner"],
                var.p = rowSums(model6[["VCV"]])),
           QGparams,
           model = "Poisson.log",
           verbose = FALSE)

mean(paramsPFE6[["h2.obs"]])
HPDinterval(as.mcmc(paramsPFE6[["h2.obs"]]))





##cov(DGE + Partner IGE) + PE + Partner PE models###
#####compute predictions based on fixed effects

#female

X <- model7[["X"]]
predict <- map(1:nrow(model7[["Sol"]]),
               ~ as.vector(X %*% model7[["Sol"]][., ]))

paramsPFE7 <-
  pmap_dfr(list(predict = predict,
                var.a = model7[["VCV"]][ , "Partner.Partner"]+model7[["VCV"]][ , "Partner.animal"]+model7[["VCV"]][ , "animal.Partner"]+model7[["VCV"]][ , "animal.animal"],
                var.p = model7[["VCV"]][ , "Partner.Partner"]+model7[["VCV"]][ , "animal.animal"]+model7[["VCV"]][ , "Partner2"]+model7[["VCV"]][ , "ID2"]+model7[["VCV"]][ , "units"]- 1),
           QGparams,
           model = "binom1.probit",
           verbose = FALSE)

mean(paramsPFE7[["h2.obs"]])
HPDinterval(as.mcmc(paramsPFE7[["h2.obs"]]))


###male


X <- model8[["X"]]
predict <- map(1:nrow(model8[["Sol"]]),
               ~ as.vector(X %*% model8[["Sol"]][., ]))

paramsPFE8 <-
  pmap_dfr(list(predict = predict,
                var.a = model8[["VCV"]][ , "Partner.Partner"]+model8[["VCV"]][ , "Partner.animal"]+model8[["VCV"]][ , "animal.Partner"]+model8[["VCV"]][ , "animal.animal"],
                var.p = model8[["VCV"]][ , "Partner.Partner"]+model8[["VCV"]][ , "animal.animal"]+model8[["VCV"]][ , "Partner2"]+model8[["VCV"]][ , "ID2"]+model8[["VCV"]][ , "units"]),
           QGparams,
           model = "Poisson.log",
           verbose = FALSE)

mean(paramsPFE8[["h2.obs"]])
HPDinterval(as.mcmc(paramsPFE8[["h2.obs"]]))


