rm(list = ls())
#AUTHOR: Sarah Dobson
#DATE: 24th January 2022
#DESCRIPTION: calculting heritability and genetic correlations on the latent scale in bivariate models


####required packages###
require(tidyverse)
require(MCMCglmm)
require(purrr)

##read in models##
model1<-readRDS("../results/model_PT_P1_NC_NP")
model2<-readRDS("../results/model_PT_P1_NC_WP")
model3<-readRDS("../results/model_PT_P1_IGE")


##function for computing fixed effect variance##
compute_vcvpred <- function(beta, design_matrix, ntraits) {
  list(cov(matrix(design_matrix %*% beta, ncol = ntraits)))
}




##models with DGE + PE####

##fixed effect matrices
X <- model1[["X"]]

Fixed_Effect_matrix <-
  flatten(
    apply(model1[["Sol"]], 1, compute_vcvpred, design_matrix = X, ntraits = 2)
  )

##random effects variance + covariance matrices
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
            row[[4]]<- row[[2]]# moved to 4 to match genetic matrix placement 
            row[[2]] <- 0 # gets zero as covariance is restrained
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )

##residual effect matrices
R<-
  flatten(
    apply(model1[["VCV"]][ , grep("units", colnames(model1[["VCV"]]))],
          1,
          function(row) {
            row[[4]]<- row[[2]]
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )


###compute phenotypic variance covariance matrix

GenFix<- map2(Genetic_matrix, R, `+`)
Random <-map2(ID2_matrix, Fixed_Effect_matrix  , `+`)
P <- map2(E, Random, `+`)

##computing heritabilites

#female
herit_female<- c()
for (i in 1:length(Genetic_matrix)){
  m<- ((Genetic_matrix[[i]][[4]])/P[[i]][[4]]) 
  
  herit_female<-append(herit_female, m) 
}

mean(herit_female)
HPDinterval(as.mcmc(herit_female))

#male
herit_male<- c()
for (i in 1:length(Genetic_matrix)){
  f<- ((Genetic_matrix[[i]][[1]])/P[[i]][[1]] )
  herit_male<-append(herit_male, f) 
}

mean(herit_male)
HPDinterval(as.mcmc(herit_male))

###computing latent genetic correlation estimates


genetic_corr<-c()

for (i in 1:length(Genetic_matrix)){
  g<- (Genetic_matrix[[i]][[2]])/sqrt((Genetic_matrix[[i]][[1]])* (Genetic_matrix[[i]][[4]]))
  genetic_corr<-append(genetic_corr, g) 
}

mean(genetic_corr2)
HPDinterval(as.mcmc(genetic_corr2))






#####DGE + PE + Partner PE  models#######



##fixed effect matrices
X <- model2[["X"]]

Fixed_Effect_matrix <-
  flatten(
    apply(model2[["Sol"]], 1, compute_vcvpred, design_matrix = X, ntraits = 2)
  )



##random effects variance + covariance matrices
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
            row[[4]]<- row[[2]]# moved to 4 to match genetic matrix placement 
            row[[2]] <- 0 # gets zero as covariance is restrained
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )


Partner_matrix<-
  flatten(
    apply(model2[["VCV"]][ , grep("Partner", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            list(matrix(row, ncol = 2, nrow = 2))
            row[[4]]<- row[[2]]
            row[[2]] <- 0
            row[[3]] <- 0
          })
  )

##residual effect matrices
R<-
  flatten(
    apply(model2[["VCV"]][ , grep("units", colnames(model2[["VCV"]]))],
          1,
          function(row) {
            row[[4]]<- row[[2]]
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )


###compute phenotypic variance covariance matrix

GenFix<- map2(Genetic_matrix, R, `+`)
E<- map2(GenFix, Partner_matrix, `+`)
Random <-map2(ID2_matrix, Fixed_Effect_matrix  , `+`)
P <- map2(E, Random, `+`)

##computing heritabilites

#female
herit_female2<- c()
for (i in 1:length(Genetic_matrix)){
  m<- ((Genetic_matrix[[i]][[4]])/P[[i]][[4]]) 
  
  herit_female2<-append(herit_female2, m) 
}

mean(herit_female2)
HPDinterval(as.mcmc(herit_female2))

#male
herit_male2<- c()
for (i in 1:length(Genetic_matrix)){
  f<- ((Genetic_matrix[[i]][[1]])/P[[i]][[1]] )
  herit_male2<-append(herit_male2, f) 
}

mean(herit_male2)
HPDinterval(as.mcmc(herit_male2))


###computing latent genetic correlation estimates


genetic_corr2<-c()

for (i in 1:length(Genetic_matrix)){
  g<- (Genetic_matrix[[i]][[2]])/sqrt((Genetic_matrix[[i]][[1]])* (Genetic_matrix[[i]][[4]]))
  genetic_corr2<-append(genetic_corr2, g) 
}

mean(genetic_corr2)
HPDinterval(as.mcmc(genetic_corr2))








#####DGE + PE + Partner PE  +Partner IGE models#######



##fixed effect matrices
X <- model3[["X"]]

Fixed_Effect_matrix <-
  flatten(
    apply(model3[["Sol"]], 1, compute_vcvpred, design_matrix = X, ntraits = 2)
  )



##random effects variance + covariance matrices
Genetic_matrix<-
  flatten(
    apply(model3[["VCV"]][ , grep("animal", colnames(model3[["VCV"]]))],
          1,
          function(row) {
            list(matrix(row, ncol = 2))
          })
  )


ID2_matrix<-
  flatten(
    apply(model3[["VCV"]][ , grep("ID2", colnames(model3[["VCV"]]))],
          1,
          function(row) {
            row[[4]]<- row[[2]]# moved to 4 to match genetic matrix placement 
            row[[2]] <- 0 # gets zero as covariance is restrained
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )


Partner_matrix<-
  flatten(
    apply(model3[["VCV"]][ , grep("Partner", colnames(model3[["VCV"]]))],
          1,
          function(row) {
            list(matrix(row, ncol = 2, nrow = 2))
          })
  )

Partner_matrix2<-
  flatten(
    apply(model3[["VCV"]][ , grep("Partner", colnames(model3[["VCV"]]))],
          1,
          function(row) {
            list(matrix(row, ncol = 2, nrow = 2))
          })
  )

##residual effect matrices
R<-
  flatten(
    apply(model3[["VCV"]][ , grep("units", colnames(model3[["VCV"]]))],
          1,
          function(row) {
            row[[4]]<- row[[2]]
            row[[2]] <- 0
            row[[3]] <- 0
            list(matrix(row, ncol = 2))
          })
  )


###compute phenotypic variance covariance matrix

GenFix<- map2(Genetic_matrix, Partner_matrix, `+`)
GenFix2<- map2(Partner2_matrix, R, `+`)
E<-map2(GenFix, GenFix2, `+`)
Random <-map2(ID2_matrix, Fixed_Effect_matrix, `+`)
P <- map2(E, Random, `+`)

##computing latent heritabilites

#female
herit_female3<- c()
for (i in 1:length(GenFix)){
  m<- ((GenFix[[i]][[4]])/P[[i]][[4]]) 
  
  herit_female3<-append(herit_female3, m) 
}

mean(herit_female3)
HPDinterval(as.mcmc(herit_female3))

#male
herit_male3<- c()
for (i in 1:length(GenFix)){
  f<- ((GenFix[[i]][[1]])/P[[i]][[1]] )
  herit_male3<-append(herit_male3, f) 
}

mean(herit_male3)
HPDinterval(as.mcmc(herit_male3))

##computing latent correlation estimates


genetic_corr3<-c()

for (i in 1:length(GenFix)){
  g<- (GenFix[[i]][[2]])/sqrt((GenFix[[i]][[1]])* (GenFix[[i]][[4]]))
  genetic_corr3<-append(genetic_corr3, g) 
}

mean(genetic_corr3)
HPDinterval(as.mcmc(genetic_corr3))







###########






