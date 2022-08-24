




data <- readRDS("data/data.rds")

pedigree <- readRDS("data/pedigree.rds")


library(MCMCglmm)


#running animal mcmcglmm model

prior <- list(R = list(V = 1, nu = 0.002),
              G = list(G1 = list(V = 1, nu = 0.002)))

modelburnin <- MCMCglmm(Tarsus ~ 1,
                        random = ~ animal,
                        family = "gaussian",
                        prior = prior,
                        pedigree = pedigree,
                        data = data,
                        nitt = 500,
                        burnin = 1,
                        thin = 1)

model <- MCMCglmm(Tarsus ~ 1,
                  random = ~ animal,
                  family = "gaussian",
                  prior = prior,
                  pedigree = pedigree,
                  data = data,
                  nitt = 100000,
                  burnin = 10000,
                  thin = 10)

#running model diagnostics

plot(modelburnin[["VCV"]])

heidel.diag(modelburnin[["VCV"]])

##computing heritability 
herit <-
  model[["VCV"]][ , "animal"] /
  (model[["VCV"]][ , "animal"] + model[["VCV"]][ , "units"])

effectiveSize(herit)
mean(herit)


HPDinterval(herit) 


#adding random effects


priorRE <- list(R = list(V = 1, nu = 0.002),
                G = list(G1 = list(V = 1, nu = 0.002),
                         G2 = list(V = 1, nu = 0.002)))


modelRE <- MCMCglmm(Tarsus ~ 1,
                    random = ~ animal + Wood,
                    family = "gaussian",
                    prior = priorRE,
                    pedigree = pedigree,
                    data = data,
                    nitt = 100000,
                    burnin = 10000,
                    thin = 10)


heritRE <- modelRE$VCV[, "animal"] / rowSums(modelRE$VCV)

mean(heritRE)


HPDinterval(heritRE)


##adding fixed effects



modelFE <- MCMCglmm(Tarsus ~ Birth_Temp,
                    random = ~ animal + Wood,
                    family = "gaussian",
                    prior = priorRE,
                    pedigree = pedigree,
                    data = data,
                    nitt = 100000,
                    burnin = 10000,
                    thin = 10)


mean(modelRE[["VCV"]][ , "units"])
mean(modelFE[["VCV"]][ , "units"])


mean(modelRE[["VCV"]][ , "animal"])
mean(modelFE[["VCV"]][ , "animal"])


heritFE_naive <-
  modelFE[["VCV"]][ , "animal"] / rowSums(modelFE[["VCV"]])
mean(heritRE)
mean(heritFE_naive)



compute_varpred <- function(beta, design_matrix) {
  var(as.vector(design_matrix %*% beta))
}
X <- modelFE[["X"]]
vf <- apply(modelFE[["Sol"]], 1, compute_varpred, design_matrix = X)


vpRE <- rowSums(modelRE[["VCV"]])
vpFE <- rowSums(modelFE[["VCV"]]) + vf


mean(vpRE)
mean(vpFE)


heritFE <- modelFE[["VCV"]][ , "animal"] / vpFE
mean(heritFE)


#Glmmm

priorP <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1000)))


modelP <- MCMCglmm(Nb_Revival ~ 1,
                   random = ~ animal + Wood,
                   family = "poisson", # Note the family here
                   prior = priorP,
                   pedigree = pedigree,
                   data = data,
                   nitt = 100000,
                   burnin = 10000,
                   thin = 10)

heritP_lat <- modelP[["VCV"]][ , "animal"] / rowSums(modelP[["VCV"]])
mean(heritP_lat)
HPDinterval(heritP_lat)

library(QGglmm)

mu_est <- mean(modelP[["Sol"]][ , "(Intercept)"])
va_est <- mean(modelP[["VCV"]][ , "animal"])
vp_est <- mean(rowSums(modelP[["VCV"]]))



QGparams(mu = mu_est,
         var.a = va_est, # IMPORTANT
         var.p = vp_est, # This is not the best way,
         model = "Poisson.log")


library(purrr)


paramsP <-
  pmap_dfr(list(mu = modelP[["Sol"]][ , "(Intercept)"], # - This is the list
                var.a = modelP[["VCV"]][ , "animal"], # | which provides our
                var.p = rowSums(modelP[["VCV"]])), # | posterior distr.
           QGparams, # - Calling the function
           model = "Poisson.log", # - Other arguments
           verbose = FALSE) # | for QGparams
mean(paramsP[["h2.obs"]])
HPDinterval(as.mcmc(paramsP[["h2.obs"]]))



###adding fixed effects



modelPFE <-
  MCMCglmm(Nb_Revival ~ Birth_Moon,
           random = ~ animal + Wood,
           family = "poisson",
           prior = priorP,
           pedigree = pedigree,
           data = data,
           nitt = 100000,
           burnin = 10000,
           thin = 10)



X <- modelPFE[["X"]]
predict <- map(1:nrow(modelPFE[["Sol"]]),
               ~ as.vector(X %*% modelPFE[["Sol"]][., ]))
var.p = rowSums(modelPFE[["VCV"]])

paramsPFE <-
  pmap_dfr(list(predict = predict,
                var.a = modelPFE[["VCV"]][ , "animal"],
                var.p = rowSums(modelPFE[["VCV"]])),
           QGparams,
           model = "Poisson.log",
           verbose = FALSE)


mean(paramsPFE[["h2.obs"]])
HPDinterval(as.mcmc(paramsPFE[["h2.obs"]]))


#binomial model



prior <- list(R = list(V = 1, fix = 1),
              G = list(G1 = list(V = 1, nu = 1000, alpha.mu = 0, alpha.V = 1)))


priorB <- list(R = list(V = 1, fix = 1),
               G = list(G1 = list(V = 1, nu = 1000, alpha.mu = 0, alpha.V = 1),
                        G2 = list(V = 1, nu = 1000, alpha.mu = 0, alpha.V = 1)))


modelB <- MCMCglmm(White ~ 1,
                   random = ~ animal + Wood,
                   family = "threshold",
                   prior = priorB,
                   pedigree = pedigree,
                   data = data,
                   nitt = 100000,
                   burnin = 10000,
                   thin = 10)

#estimating heritability  on latent scale

heritB_liab <-
  modelB[["VCV"]][ , "animal"] / rowSums(modelB[["VCV"]])
mean(heritB_liab)
HPDinterval(heritB_liab)

#estimating heritability  on observed scale

paramsB <-
  pmap_dfr(list(mu = modelB[["Sol"]][ , "(Intercept)"],
                var.a = modelB[["VCV"]][ , "animal"],
                var.p = rowSums(modelB[["VCV"]]) - 1), # Note the - 1 here
           QGparams,
           model = "binom1.probit",
           verbose = FALSE)
mean(paramsB[["h2.obs"]])
HPDinterval(as.mcmc(paramsB[["h2.obs"]]))



#Multi- trait models




prior <- list(R = list(V = diag(2), nu = 2),
              G = list(G1 = list(V = diag(2), nu = 2)))



priorM <- list(R = list(V = diag(2), nu = 2),
               G = list(G1 = list(V = diag(2), nu = 2)))
modelM <- MCMCglmm(cbind(Tarsus, Weight) ~ trait - 1,
                   random = ~ us(trait):animal,
                   rcov = ~ us(trait):units,
                   family = c("gaussian", "gaussian"),
                   prior = priorM,
                   pedigree = pedigree,
                   data = data,
                   nitt = 100000,
                   burnin = 10000,
                   thin = 10)


VCV_uscl <- modelMF[["VCV"]]


effectiveSize(VCV_uscl)
heidel.diag(VCV_uscl)


herit_tarsus <-
  VCV_uscl[ , "traitTarsus:traitTarsus.animal"] /
  (VCV_uscl[ , "traitTarsus:traitTarsus.animal"] +
     VCV_uscl[ , "traitTarsus:traitTarsus.units"])
herit_weight <-
  VCV_uscl[ , "traitWeight:traitWeight.animal"] /
  (VCV_uscl[ , "traitWeight:traitWeight.animal"] +
     VCV_uscl[ , "traitWeight:traitWeight.units"])


mean(herit_tarsus)
HPDinterval(herit_tarsus)
mean(herit_weight)
HPDinterval(herit_weight)


genetic_corr <-
  VCV_uscl[ , "traitTarsus:traitWeight.animal"] /
  sqrt(VCV_uscl[ , "traitTarsus:traitTarsus.animal"] *
         VCV_uscl[ , "traitWeight:traitWeight.animal"])

mean(genetic_corr)
HPDinterval(genetic_corr)



##addind fixed effects


modelMF <- MCMCglmm(cbind(Tarsus, Weight) ~ trait - 1 +
                      trait:Birth_Temp + at.level(trait, 2):Birth_Moon,
                    random = ~ us(trait):animal,
                    rcov = ~ us(trait):units,
                    family = c("gaussian", "gaussian"),
                    prior = priorM,
                    pedigree = pedigree,
                    data = data,
                    nitt = 100000,
                    burnin = 10000,
                    thin = 10)


compute_vcvpred <- function(beta, design_matrix, ntraits) {
  list(cov(matrix(design_matrix %*% beta, ncol = ntraits)))
}
X <- modelMF[["X"]]
Fixed <-
  flatten(
    apply(modelMF[["Sol"]], 1, compute_vcvpred, design_matrix = X, ntraits = 2)
  )

modelMF[["X"]]
modelMF[["Sol"]]

mu <- flatten(apply(modelMF[["Sol"]], 1, list))

for (i in 1:length(mu)){
  mu[[i]]<- cbind(mu[[i]][[1]], mu[[i]][[2]])
}


G <-
  flatten(
    apply(modelMF[["VCV"]][ , grep("animal", colnames(modelMF[["VCV"]]))],
          1,
          function(row) {
            list(matrix(row, ncol = 2))
          })
  )

R <-
  flatten(
    apply(modelMF[["VCV"]][ , grep("units", colnames(modelMF[["VCV"]]))],
          1,
          function(row) {
            row[4] <- row[4] - 1
            list(matrix(row, ncol = 2))
          })
  )

GF<- map2(G, Fixed, `+`)

P <- map2(G, R, `+`)


paramsM2 <-
  pmap(list(mu = mu,
            vcv.G = G,
            vcv.P = P),
       QGmvparams,
       models = c("Gaussian", "Gaussian"),
       verbose = FALSE)




X <- modelFE[["X"]]
vf <- apply(modelFE[["Sol"]], 1, compute_varpred, design_matrix = X)


vpRE <- rowSums(modelRE[["VCV"]])
vpFE <- rowSums(modelFE[["VCV"]]) + vf
vf

vpMF<- rowSums(modelMF[["VCV"]]) 





yhat <- predict(modelFE, type = "terms")





###

mu1 = modelMF[["Sol"]][, "traitTarsus"]
mu2 = modelMF[["Sol"]][, "traitWeight"]
mu <- c(row["mu1"], row["mu2"])

summary(modelMF)

plot(modelM[["VCV"]])

modelM[["VCV"]][,"traitTarsus:traitTarsus.animal"]

df <- cbind(mu1 = modelM[["Sol"]][, "traitTarsus"],
            mu2 = modelM[["Sol"]][, "traitWeight"],
            modelM[["VCV"]])




post <- apply(df, 1, function(row) {
  mu <- c(row["mu1"], row["mu2"])
  G <- matrix(c(row["traitTarsus:traitTarsus.animal"],
                row["traitTarsus:traitWeight.animal"],
                row[ "traitTarsus:traitWeight.animal"],
                row["traitWeight:traitWeight.animal"]),
              ncol = 2)
  R <- matrix(c(row["traitTarsus:traitTarsus.units"],
                row["traitTarsus:traitWeight.units"],
                row["traitTarsus:traitWeight.units"],
                row["traitWeight:traitWeight.units"]),
              ncol = 2)
  

  
  QGmvparams(mu = mu, vcv.G = G, vcv.P = P,
             model = c("binom1.probit", "Gaussian"), verbose = FALSE)
  
 
})




length(Fixed2)

Fixed2<- Fixed[9000]

Fixed<-unlist()

Fixed3<- as.matrix

for (i in 1:length(Fixed2)) {
  a<- unlist(Fixed2[i])
  
a<-as.matrix(a)

Fixed3<- append(Fixed3, a)
  
}

Fixed2<-as.matrix(Fixed2)
post2 <- apply(df, 1, function(row) {
  mu <- c(row["mu1"], row["mu2"])
  G <- matrix(c(row["traitTarsus:traitTarsus.animal"],
                row["traitTarsus:traitWeight.animal"],
                row[ "traitTarsus:traitWeight.animal"],
                row["traitWeight:traitWeight.animal"]),
              ncol = 2)
  R <- matrix(c(row["traitTarsus:traitTarsus.units"],
                row["traitTarsus:traitWeight.units"],
                row["traitTarsus:traitWeight.units"],
                row["traitWeight:traitWeight.units"]),
              ncol = 2)
  
 })


R <- matrix(c(row["traitTarsus:traitTarsus.units"],
              row["traitTarsus:traitWeight.units"],
              row["traitTarsus:traitWeight.units"],
              row["traitWeight:traitWeight.units"]), ncol = 5)

R <- matrix(c(row["traitTarsus:traitTarsus.units"],
              row["traitTarsus:traitWeight.units"],
              row["traitTarsus:traitWeight.units"],
              row["traitWeight:traitWeight.units"]),
            ncol = 2)



paramsM2 <- transpose(post)


# And to format the output in a more simple way
# abind() from the abind package transforms a list of matrices into a 3D-array
paramsM2[["mean.obs"]] <- unlist(paramsM2[["mean.obs"]])
paramsM2[["vcv.G.obs"]] <- abind::abind(paramsM2[["vcv.G.obs"]], along = 3)
paramsM2[["vcv.P.obs"]] <- abind::abind(paramsM2[["vcv.P.obs"]], along = 3)

Fixed2[1]

Fixed2 <- transpose(Fixed)
Fixed3 <- Fixed2

Fixed2<-array(Fixed)


apply(paramsM2[["vcv.G.obs"]], c(1, 2), mean)
apply(paramsM2[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[1] })
apply(paramsM2[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[2] })

apply(paramsM2[["vcv.G.obs"]], c(1, 2), function (mean) { HPDinterval(as.mcmc(mean))[1] })
apply(paramsM2[["vcv.G.obs"]], c(1, 2), function (mean) { HPDinterval(as.mcmc(mean))[1] })

heritM2_Pois <- (paramsM2[["vcv.G.obs"]] / paramsM2[["vcv.P.obs"]])[1, 1, ]
heritM2_Bin <- (paramsM2[["vcv.G.obs"]] / paramsM2[["vcv.P.obs"]])[2, 2, ]


mean(heritM2_Pois)
mean(heritM2_Bin)

paramsM2.5<-paramsM2[["vcv.P.obs"]][, , 1]


Fixed2<- Fixed[1]

a= list(Fixed2, paramsM2.5)

Reduce("+",a[1])





######Non normal data 




priorM2 <-
  list(R = list(V = diag(2), nu = 2, fix = 2),
       G = list(G1 = list(V = diag(2),
                          nu = 2,
                          alpha.mu = c(0,0),
                          alpha.V = diag(2))))



modelM2 <- MCMCglmm(cbind(Nb_Revival, White) ~ trait - 1,
                    random = ~ us(trait):animal,
                    rcov = ~ us(trait):units,
                    family = c("poisson", "threshold"),
                    prior = priorM2,
                    pedigree = pedigree,
                    data = data,
                    nitt = 100000,
                    burnin = 10000,
                    thin = 10)


summary(modelM2)

modelM2[["Sol"]]
mu <- flatten(apply(modelMF[["Sol"]], 1, list))  
length(mu)
mu[[3]][[1]]
mu[[3]]
cbind(mu[[1]][[1]], mu[[1]][[2]])




m3<-
mu2 <- flatten(apply(modelM2[["Sol"]], 1, list))

G <-
  flatten(
    apply(modelM2[["VCV"]][ , grep("animal", colnames(modelM2[["VCV"]]))],
          1,
          function(row) {
            list(matrix(row, ncol = 2))
          })
  )

R <-
  flatten(
    apply(modelM2[["VCV"]][ , grep("units", colnames(modelM2[["VCV"]]))],
          1,
          function(row) {
            row[4] <- row[4] - 1
            list(matrix(row, ncol = 2))
          })
  )


P <- map2(G, R, `+`)


paramsM2 <-
  pmap(list(mu = mu,
            vcv.G = G,
            vcv.P = P),
       QGmvparams,
       models = c("Gaussian", "Gaussian"),
       verbose = FALSE)




paramsM2 <- transpose(paramsM2)

paramsM2[["mean.obs"]] <- unlist(paramsM2[["mean.obs"]])
paramsM2[["vcv.G.obs"]] <- abind::abind(paramsM2[["vcv.G.obs"]], along = 3)
paramsM2[["vcv.P.obs"]] <- abind::abind(paramsM2[["vcv.P.obs"]], along = 3)



apply(paramsM2[["vcv.G.obs"]], c(1, 2), mean)
apply(paramsM2[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[1] })
apply(paramsM2[["vcv.G.obs"]], c(1, 2), function (vec) { HPDinterval(as.mcmc(vec))[2] })


heritM2_Pois <- (paramsM2[["vcv.G.obs"]] / paramsM2[["vcv.P.obs"]])[1, 1, ]
heritM2_Bin <- (paramsM2[["vcv.G.obs"]] / paramsM2[["vcv.P.obs"]])[2, 2, ]


mean(heritM2_Pois)
mean(heritM2_Bin)

genetic.corr




modelM2F <- MCMCglmm(cbind(Nb_Revival, White) ~ trait - 1 + trait:Birth_Moon,
                     random = ~ us(trait):animal,
                     rcov = ~ us(trait):units,
                     family = c("poisson", "threshold"),
                     prior = priorM2,
                     pedigree = pedigree,
                     data = data,
                     nitt = 100000,
                     burnin = 10000,
                     thin = 10)
modelM2[["Sol"]]
modelM2F[["Sol"]]
X <- modelM2F[["X"]]
predict <- map(1:nrow(modelM2F[["Sol"]]),   
               ~ as.vector(X %*% modelM2F[["Sol"]][., ]))


G <-
  flatten(
    apply(modelM2F[["VCV"]][ , grep("animal", colnames(modelM2F[["VCV"]]))],
          1,
          function(row) {
            list(matrix(row, ncol = 2))
          })
  )


R <-

flatten(
  apply(modelM2F[["VCV"]][ , grep("units", colnames(modelM2F[["VCV"]]))],
        1,
        function(row) {
          row[4] <- row[4] - 1
          list(matrix(row, ncol = 2))
        })
)





P <- map2(G, R, `+`)

predict <- predict[1]
G <- G[1]
P <- P[1]


paramsM2F <-
  pmap(list(predict = predict,
            vcv.G = G,
            vcv.P = P),
       QGmvparams,
       models = c("Poisson.log", "binom1.probit"),
       verbose = FALSE)




list.models = list(
  model1 = list(inv.link = function(x){pnorm(x)},
                d.inv.link = function(x){dnorm(x)},
                var.func = function(x){pnorm(x) * (1 - pnorm(x))}),
  model2 = list(inv.link = function(x){x},
                d.inv.link = function(x){1},
                var.func = function(x){0})
)

n <- 100

p <- matrix(c(runif(n), runif(n)), ncol = 2)


yhat <- predict(modelM2F, type = "terms")


QGmvparams(predict = p, vcv.G = G, vcv.P = P, models = c("binom1.probit", "Gaussian"))

yhat <- predict(model, type = "terms")







mu <- flatten(apply(modelM2[["Sol"]], 1, list))



G <-
  flatten(
    apply(modelM2[["VCV"]][ , grep("animal", colnames(modelM2[["VCV"]]))],
          1,
          function(row) {
            list(matrix(row, ncol = 2))
          })
  )



R <-
  flatten(
    apply(modelM2[["VCV"]][ , grep("units", colnames(modelM2[["VCV"]]))],
          1,
          function(row) {
            row[4] <- row[4] - 1
            list(matrix(row, ncol = 2))
          })
  )


P <- map2(G, R, `+`)

