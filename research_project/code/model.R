rm(list = ls())
#AUTHOR: Sarah Dobson
#DATE: 24th January 2022
#DESCRIPTION: running bivariate male and female EPR models with differing random effects

####require relevent packages########
require(tidyverse)
require(MCMCglmm)
require(MasterBayes)
require(QGglmm)
require(purrr)

#####load in data#########

DF <- read.csv("../data/InterPleiotropy4.csv")
ped <- read.csv("../data/Pedigree.csv")

####Formatting pedigree#######

names(ped)[1]<-"animal"

a<-ped$MOTHER[!ped$animal %in% ped$MOTHER] 
a<-as.data.frame(a) %>% distinct %>% rename(animal = a)
b<-ped$FATHER[!ped$animal %in% ped$FATHER]
b<-as.data.frame(b) %>% distinct %>% rename(animal = b)
c<-dplyr::full_join(a, b)
ped2<-dplyr::full_join(c, ped)
ped2 <- insertPed(ped2)
ped2 <- orderPed(ped2)
ped2= as.data.frame(ped2)


##subset DF to measure female EPR probability vs Male EPR probability##

sub_DF<- DF %>% dplyr::select(ID, Sex, F_EPP_brood, male_brood_EPO, Cohort, Partner, Age, couple)
sub_DF<- sub_DF %>% mutate(ID2 = ID) %>% rename(animal = ID)%>% filter(!is.na(Age))%>% mutate(Partner2 = Partner)%>% filter(!is.na(Partner))
sub_DF<- sub_DF[(sub_DF$animal %in% ped2$animal),]
sub_DF<- sub_DF[(sub_DF$Partner %in% ped2$animal),]
sub_DF$Partner<-as.factor(sub_DF$Partner)
sub_DF$Partner2<-as.factor(sub_DF$Partner2)
sub_DF$couple<-as.factor(sub_DF$couple)
sub_DF$animal<-as.factor(sub_DF$animal)
sub_DF$Cohort<-as.factor(sub_DF$Cohort)
sub_DF$ID2<-as.factor(sub_DF$ID2)
sub_DF$male_brood_EPO<-as.numeric(sub_DF$male_brood_EPO)



###DGE + PE model###



prior1 <- list(G1 = list(G1 = list(V = diag(2), nu = 2, alpha.mu = c(0,0), alpha.V = diag(2)),
                G2 = list(V = diag(2), nu = 2, alpha.mu = c(0,0), alpha.V = diag(2))),
       R = list(V = diag(2), nu = 1.002, fix = 2))


prior2 <- list(G = list(G1 = list(V = diag(2)*0.02, nu = 3, alpha.mu = c(0, 0), alpha.V = diag(2)*1000),
                         G2 = list(V = diag(2)*0.02, nu = 3, alpha.mu = c(0, 0), alpha.V = diag(2)*1000)),
                R = list(V = diag(2), nu = 1.002, fix = 2))





model_PT_P1_NC_NP<- MCMCglmm(cbind(male_brood_EPO, F_EPP_brood)~trait-1 + trait:Age,
                  random=~us(trait):animal+idh(trait):ID2+idh(trait):Partner,
                  rcov=~idh(trait):units,
                  family=c("poisson","threshold"),
                  pedigree=ped5,
                  data=sub_DF,
                  nitt = 755000,
                  burnin = 5000,
                  thin = 500, prior=priorM3)



##chekc model assumptions

model1<- model_PT_P1_NC_NP
summary(model1)
plot(model1$VCV)
plot(model1$Sol)
autocorr.diag(model1$VCV)



###save model outputs 
saveRDS(model1, "../results/model_PT_P1_NC_WP")




###DGE + PE + Partner PE model###



###make priors
prior1 <- list(G = list(G1 = list(V = diag(2), nu = 2, alpha.mu = c(0,0), alpha.V = diag(2)),
                        G2 = list(V = diag(2), nu = 2, alpha.mu = c(0,0), alpha.V = diag(2)),
                        G3 = list(V = diag(2), nu = 2, alpha.mu = c(0,0), alpha.V = diag(2))),
               R = list(V = diag(2), nu = 1.002, fix = 2))

prior2 <- list(G = list(G1 = list(V=diag(2)* 0.02, nu=3, alpha.mu = c(0, 0), alpha.V = diag(2)*1000),
                         G2 = list(V=diag(2)* 0.02, nu=3, alpha.mu = c(0, 0), alpha.V = diag(2)*1000),
                         G3 = list(V=diag(2)* 0.02, nu=3, alpha.mu = c(0, 0), alpha.V = diag(2)*1000)),
                R = list(V = diag(2), nu =1.002))


###run model


model_PT_P1_NC_WP<- MCMCglmm(cbind(FEPO, male_brood_EPO)~trait-1 + trait:Number_Broods_with_Partner + trait:Age,
                  random=~us(trait):animal+idh(trait):Partner+idh(trait):ID2,
                  rcov=~idh(trait):units,
                  family=c("gaussian","gaussian"),
                  pedigree=ped5,
                  data=sub_DF,
                  nitt = 505000,
                  burnin = 5000,
                  thin = 500,
                  prior=priorM2)

model1<- model_PT_P1_NC_WP
summary(model1)
plot(model1$VCV)
plot(model1$Sol)
autocorr.diag(model1$VCV)

saveRDS(model1, "../results/model_PT_P1_NC_WP")





####DGE + PE + Partner PE + Partner IGE model######



invA <- inverseA(ped5)$Ainv

##priors

prior1 <- list(G = list(G1 = list(V=diag(2), nu= 2, alpha.mu = c(0, 0), alpha.V = diag(2)),
                        G2 = list(V=diag(2), nu= 2, alpha.mu = c(0, 0), alpha.V = diag(2)),
                        G3 = list(V=diag(2), nu= 2, alpha.mu = c(0, 0), alpha.V = diag(2)),
                        G4 = list(V=diag(2), nu= 2, alpha.mu = c(0, 0), alpha.V = diag(2))),
               R = list(V = diag(2), nu = 1.002, fix = 2))

prior2 <- list(G = list(G1 = list(V = diag(2)*0.02, nu = 3, alpha.mu = c(0, 0), alpha.V = diag(2)*1000),
                        G2 = list(V = diag(2)*0.02, nu = 3, alpha.mu = c(0, 0), alpha.V = diag(2)*1000),
                        G3 = list(V = diag(2)*0.02, nu = 3, alpha.mu = c(0, 0), alpha.V = diag(2)*1000)),
               R = list(V = diag(2), nu = 1.002, fix = 2))


##run model

model1<- MCMCglmm(cbind(male_brood_EPO, F_EPP_brood)~trait-1 + trait:Age,
                  random=~us(trait):animal+us(trait):Partner+idh(trait):Partner2 +idh(trait):ID2,
                  rcov=~idh(trait):units,
                  family=c("poisson","threshold"),
                  ginverse=list(animal=invA, Partner=invA),
                  data=sub_DF,
                  nitt = 2555000,
                  burnin = 5000,
                  thin = 2000,
               prior=prior2)



summary(model1)
plot(model1$VCV)
plot(model1$Sol)
autocorr.diag(model1$VCV)
autocorr.diag(model1$Sol)

saveRDS(model1, "../results/model_PT_P1_IGE")


