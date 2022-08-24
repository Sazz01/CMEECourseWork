rm(list = ls())
#AUTHOR: Sarah Dobson
#DATE: 24th January 2022
#DESCRIPTION: calculting heritability and genetic correlations on the observed scale in bivariate models

####required packages######
require(tidyverse)
require(MCMCglmm)
require(purrr)

##read in models#####
model1<-readRDS("../results/model_PT_P1_NC_NP")
model2<-readRDS("../results/model_PT_P1_NC_WP")
model3<-readRDS("../results/model_PT_P1_IGE")




#####DGE + PE models######

###get female predicted values based on fixed effects

Git <-model1[["X"]][ , grep("F_EPP_brood", colnames(model1[["X"]]))]

Git2 <-model1[["Sol"]][ , grep("F_EPP_brood", colnames(model1[["Sol"]]))]

length(Git2)
predict2 <- map(1:nrow(Git2),
                ~ as.vector(Git %*% Git2[.,]))


##get male predicted values based on fixed effects

Git3 <-model1[["X"]][ , grep("male_brood_EPO", colnames(model1[["X"]]))]

Git4 <-model1[["Sol"]][ , grep("male_brood_EPO", colnames(model1[["Sol"]]))]

predict3 <- map(1:nrow(Git4),
                ~ as.vector(Git3 %*% Git4[.,]))

## zero readings get NA
for (i in 1:length(predict3)) {
  for (j in 1:length(predict3[[i]])){
    if (predict3[[i]][[j]] == 0){
      predict3[[i]][[j]] <- NA
    }
  }}

for (i in 1:length(predict2)) {
  for (j in 1:length(predict2[[i]])){
    if (predict2[[i]][[j]] == 0){
      predict2[[i]][[j]] <- NA
    }
  }}

##then remove NAs
for (i in 1:length(predict2)) {
  predict2[[i]]<- predict2[[i]][!is.na(predict2[[i]])]
}


for (i in 1:length(predict3)) {
  predict3[[i]]<- predict3[[i]][!is.na(predict3[[i]])]
}

##create a matrix to bind male and female predictions for eahc iteration together in separate columns

matrix<- c()

for (i in 1:length(predict3)) {
  matrix[[i]] <- cbind(predict3[[i]], predict2[[i]])
}

matrix[[1]]

#Random effect variance- covariance matrices 

Genetic_matrix<-
  flatten(
    apply(model1[["VCV"]][ , grep("animal", colnames(model1[["VCV"]]))],
          1,
          function(row) {
            
            list(matrix(row, ncol = 2))
          })
  )


ID2_matrix<-
  flatten(
    apply(model1[["VCV"]][ , grep("ID2", colnames(model1[["VCV"]]))],
          1,
          function(row) {
            row[4] <- row[4] - 1
            row[[4]]<- row[[2]]
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )


R<-
  flatten(
    apply(model1[["VCV"]][ , grep("units", colnames(model1[["VCV"]]))],
          1,
          function(row) {
            row[[4]]<- row[[2]]
            row[4] <- row[4] - 1 #-1 to get rick backtransformation for threshold trait
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )





GenID<-map2(ID2_matrix, Genetic_matrix , `+`)
P <- map2(GenID, R, `+`)

###run QGlmm pakcage to get estimates on the observed scale

paramsM2F <-
  pmap(list(predict = matrix,
            vcv.G = Genetic_matrix,
            vcv.P = P),
       QGmvparams,
       models = c("Poisson.log", "binom1.probit"))


##save results cause they take ages to runnnnn

saveRDS(paramsM2F, "../results/back_transformed_results/model_PT_P2_NC_NP_Hd.rds")



paramsM2F <- transpose(paramsM2F)
# And to format the output in a more simple way
# abind() from the abind package transforms a list of matrices into a 3D-array
paramsM2F[["mean.obs"]] <- unlist(paramsM2F[["mean.obs"]])
paramsM2F[["vcv.G.obs"]] <- abind::abind(paramsM2F[["vcv.G.obs"]], along = 3)
paramsM2F[["vcv.P.obs"]] <- abind::abind(paramsM2F[["vcv.P.obs"]], along = 3)

#heritabilty estimates
apply(paramsM2F[["vcv.G.obs"]], c(1, 2), mean)
apply(paramsM2F[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[1] })
apply(paramsM2F[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[2] })


#male 
herit_male <- (paramsM2F[["vcv.G.obs"]] / paramsM2F[["vcv.P.obs"]])[1, 1, ]
mean(herit_male)
HPDinterval(as.mcmc(herit_male))

#female
herit_female <- (paramsM2F[["vcv.G.obs"]] / paramsM2F[["vcv.P.obs"]])[2, 2, ]
mean(herit_female)
HPDinterval(as.mcmc(herit_female))


##genetic correlation
genetic.corr<- paramsM2F[["vcv.G.obs"]][1, 2, ]/sqrt(paramsM2F[["vcv.G.obs"]][1, 1,] * paramsM2F[["vcv.G.obs"]][2, 2,])

mean(genetic.corr)
HPDinterval(as.mcmc(genetic.corr))








#####DGE + PE + Partner PE models######

###get female predicted values based on fixed effects

Git <-model2[["X"]][ , grep("F_EPP_brood", colnames(model2[["X"]]))]

Git2 <-model2[["Sol"]][ , grep("F_EPP_brood", colnames(model2[["Sol"]]))]

length(Git2)
predict2 <- map(1:nrow(Git2),
                ~ as.vector(Git %*% Git2[.,]))


##get male predicted values based on fixed effects

Git3 <-model2[["X"]][ , grep("male_brood_EPO", colnames(model2[["X"]]))]

Git4 <-model2[["Sol"]][ , grep("male_brood_EPO", colnames(model2[["Sol"]]))]

predict3 <- map(1:nrow(Git4),
                ~ as.vector(Git3 %*% Git4[.,]))

## zero readings get NA
for (i in 1:length(predict3)) {
  for (j in 1:length(predict3[[i]])){
    if (predict3[[i]][[j]] == 0){
      predict3[[i]][[j]] <- NA
    }
  }}

for (i in 1:length(predict2)) {
  for (j in 1:length(predict2[[i]])){
    if (predict2[[i]][[j]] == 0){
      predict2[[i]][[j]] <- NA
    }
  }}

##then remove NAs
for (i in 1:length(predict2)) {
  predict2[[i]]<- predict2[[i]][!is.na(predict2[[i]])]
}


for (i in 1:length(predict3)) {
  predict3[[i]]<- predict3[[i]][!is.na(predict3[[i]])]
}

##create a matrix to bind male and female predictions for eahc iteration together in separate columns

matrix<- c()

for (i in 1:length(predict3)) {
  matrix[[i]] <- cbind(predict3[[i]], predict2[[i]])
}

matrix[[1]]

#Random effect variance- covariance matrices 

Genetic_matrix<-
  flatten(
    apply(model2[["VCV"]][ , grep("animal", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            
            list(matrix(row, ncol = 2))
          })
  )


ID2_matrix<-
  flatten(
    apply(model2[["VCV"]][ , grep("ID2", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            row[4] <- row[4] - 1
            row[[4]]<- row[[2]]
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )

Partner_matrix<-
  flatten(
    apply(model2[["VCV"]][ , grep("Partner", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            row[4] <- row[4] - 1
            row[[4]]<- row[[2]]
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )


R<-
  flatten(
    apply(model2[["VCV"]][ , grep("units", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            row[[4]]<- row[[2]]
            row[4] <- row[4] - 1 #-1 to get rick backtransformation for threshold trait
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )



###compute total phenotypic variance

GenID<-map2(ID2_matrix, Genetic_matrix , `+`)
RPat <- map2(GenID, R, `+`)

P <- map2(GenID, RPat, `+`)
###run QGlmm pakcage to get estimates on the observed scale

paramsM2F <-
  pmap(list(predict = matrix,
            vcv.G = Genetic_matrix,
            vcv.P = P),
       QGmvparams,
       models = c("Poisson.log", "binom1.probit"))


##save results cause they take ages to runnnnn

saveRDS(paramsM2F, "../results/back_transformed_results/model_PT_P2_NC_WP_Hd.rds")



paramsM2F <- transpose(paramsM2F)
# And to format the output in a more simple way
# abind() from the abind package transforms a list of matrices into a 3D-array
paramsM2F[["mean.obs"]] <- unlist(paramsM2F[["mean.obs"]])
paramsM2F[["vcv.G.obs"]] <- abind::abind(paramsM2F[["vcv.G.obs"]], along = 3)
paramsM2F[["vcv.P.obs"]] <- abind::abind(paramsM2F[["vcv.P.obs"]], along = 3)

#heritabilty estimates
apply(paramsM2F[["vcv.G.obs"]], c(1, 2), mean)
apply(paramsM2F[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[1] })
apply(paramsM2F[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[2] })


#male 
herit_male2 <- (paramsM2F[["vcv.G.obs"]] / paramsM2F[["vcv.P.obs"]])[1, 1, ]
mean(herit_male2)
HPDinterval(as.mcmc(herit_male2))

#female
herit_female2 <- (paramsM2F[["vcv.G.obs"]] / paramsM2F[["vcv.P.obs"]])[2, 2, ]
mean(herit_female2)
HPDinterval(as.mcmc(herit_female2))


##genetic correlation
genetic.corr2<- paramsM2F[["vcv.G.obs"]][1, 2, ]/sqrt(paramsM2F[["vcv.G.obs"]][1, 1,] * paramsM2F[["vcv.G.obs"]][2, 2,])
mean(genetic.corr2)
HPDinterval(as.mcmc(genetic.corr2))








#####DGE + PE + Partner PE + Partner IGEs models######

###get female predicted values based on fixed effects

Git <-model3[["X"]][ , grep("F_EPP_brood", colnames(model3[["X"]]))]

Git2 <-model3[["Sol"]][ , grep("F_EPP_brood", colnames(model3[["Sol"]]))]

length(Git2)
predict2 <- map(1:nrow(Git2),
                ~ as.vector(Git %*% Git2[.,]))


##get male predicted values based on fixed effects

Git3 <-model3[["X"]][ , grep("male_brood_EPO", colnames(model3[["X"]]))]

Git4 <-model3[["Sol"]][ , grep("male_brood_EPO", colnames(model3[["Sol"]]))]

predict3 <- map(1:nrow(Git4),
                ~ as.vector(Git3 %*% Git4[.,]))

## zero readings get NA
for (i in 1:length(predict3)) {
  for (j in 1:length(predict3[[i]])){
    if (predict3[[i]][[j]] == 0){
      predict3[[i]][[j]] <- NA
    }
  }}

for (i in 1:length(predict2)) {
  for (j in 1:length(predict2[[i]])){
    if (predict2[[i]][[j]] == 0){
      predict2[[i]][[j]] <- NA
    }
  }}

##then remove NAs
for (i in 1:length(predict2)) {
  predict2[[i]]<- predict2[[i]][!is.na(predict2[[i]])]
}


for (i in 1:length(predict3)) {
  predict3[[i]]<- predict3[[i]][!is.na(predict3[[i]])]
}

##create a matrix to bind male and female predictions for each iteration together in separate columns

matrix<- c()

for (i in 1:length(predict3)) {
  matrix[[i]] <- cbind(predict3[[i]], predict2[[i]])
}

matrix[[1]]

#Random effect variance- covariance matrices 

Genetic_matrix<-
  flatten(
    apply(model2[["VCV"]][ , grep("animal", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            
            list(matrix(row, ncol = 2))
          })
  )


ID2_matrix<-
  flatten(
    apply(model2[["VCV"]][ , grep("ID2", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            row[4] <- row[4] - 1
            row[[4]]<- row[[2]]
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )

Partner_matrix<-
  flatten(
    apply(model1[["VCV"]][ , grep("Partner", colnames(model1[["VCV"]]))],
          1,
          function(row) {
            list(matrix(row, ncol = 2, nrow=2))
          })
  )


Partner2_matrix<-
  flatten(
    apply(model2[["VCV"]][ , grep("Partner2", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            row[4] <- row[4] - 1
            row[[4]]<- row[[2]]
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )


R<-
  flatten(
    apply(model2[["VCV"]][ , grep("units", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            row[[4]]<- row[[2]]
            row[4] <- row[4] - 1 #-1 to get rick backtransformation for threshold trait
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )






###combine DGE and IGE to get total heritable variation
Genetic_matrix2<-map2(Genetic_matrix, Partner_matrix, `+`)



###compute total phenotypic variance
GenID<-map2(ID2_matrix, Genetic_matrix2, `+`)


RPat <- map2(R, Partner2_matrix, `+`)

P <- map2(GenID, RPat, `+`)
###run QGlmm pakcage to get estimates on the observed scale

paramsM2F <-
  pmap(list(predict = matrix,
            vcv.G = Genetic_matrix2,
            vcv.P = P),
       QGmvparams,
       models = c("Poisson.log", "binom1.probit"))


##save results cause they take ages to runnnnn

saveRDS(paramsM2F, "../results/back_transformed_results/model_PT_P2_IGE.rds")



paramsM2F <- transpose(paramsM2F)
# And to format the output in a more simple way
# abind() from the abind package transforms a list of matrices into a 3D-array
paramsM2F[["mean.obs"]] <- unlist(paramsM2F[["mean.obs"]])
paramsM2F[["vcv.G.obs"]] <- abind::abind(paramsM2F[["vcv.G.obs"]], along = 3)
paramsM2F[["vcv.P.obs"]] <- abind::abind(paramsM2F[["vcv.P.obs"]], along = 3)

#heritabilty estimates
apply(paramsM2F[["vcv.G.obs"]], c(1, 2), mean)
apply(paramsM2F[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[1] })
apply(paramsM2F[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[2] })


#male 
herit_male3 <- (paramsM2F[["vcv.G.obs"]] / paramsM2F[["vcv.P.obs"]])[1, 1, ]
mean(herit_male3)
HPDinterval(as.mcmc(herit_male3))

#female
herit_female3 <- (paramsM2F[["vcv.G.obs"]] / paramsM2F[["vcv.P.obs"]])[2, 2, ]
mean(herit_female3)
HPDinterval(as.mcmc(herit_female3))


##genetic correlation
genetic.corr3<- paramsM2F[["vcv.G.obs"]][1, 2, ]/sqrt(paramsM2F[["vcv.G.obs"]][1, 1,] * paramsM2F[["vcv.G.obs"]][2, 2,])
mean(genetic.corr3)
HPDinterval(as.mcmc(genetic.corr3))













