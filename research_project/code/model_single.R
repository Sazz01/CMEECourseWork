rm(list = ls())
#AUTHOR: Sarah Dobson
#DATE: 24th January 2022
#DESCRIPTION: running univariate male and female EPR models with differing random effects

###require relevent packages#####
require(tidyverse)
require(MCMCglmm)
require(MasterBayes)
require(QGglmm)
require(purrr)


####load in data######

DF <- read.csv("../data/InterPleiotropy4.csv")
ped <- read.csv("../data/Pedigree.csv")

###Formatting pedigree#####

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


####subset  and format sub DF####


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



#####DGE + PE models########

#male EPR

prior1 <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1)))

prior2 <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G2 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000)))




model_Male_P_P1<- MCMCglmm(male_brood_EPO~ Age,
                         random=~animal+ID2,
                         rcov=~units,
                         family="poisson",
                         pedigree=ped2,
                         data=sub_DF,
                         nitt = 205000,
                         burnin = 5000,
                         thin = 200, prior=prior1)

####check model assumptions####
model_Male_P_P1->model1
summary(model1)
plot(model1$Sol)
plot(model1$VCV)
autocorr.diag(model1$VCV)


##save outputs####

saveRDS(model_Male_P_P1, "../results/model_Male_P_P1_NC_NP")



####female EPR


prior1 <- list(R = list(V = 1, fix = 1),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1)))


prior2 <- list(R = list(V = 1, fix = 1),
               G = list(G1 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G2 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000)))


model_Female_T_P1<- MCMCglmm(cbind(FEPO, FWPO)~ Age,
                           random=~animal+ID2,
                           rcov=~units,
                           family= "threshold",
                           pedigree=ped2,
                           data=sub_DF,
                           nitt = 310000,
                           burnin = 10000,
                           thin = 200, prior=prior1)


model_Female_T_P1->model1
summary(model1)
plot(model1$Sol)
plot(model1$VCV)
autocorr.diag(model1$VCV)
saveRDS(model_Female_T_P3, "../results/model_Female_T_P2_NP_NC")


#####DGE + PE + Partner PE###########


###Male EPR

prior1 <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G3 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1)))

prior2 <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G2 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G3 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000)))


model_Male_P_P1<- MCMCglmm(male_brood_EPO~ Age,
                           random=~animal+ID2+Partner,
                           rcov=~units,
                           family="poisson",
                           pedigree=ped2,
                           data=sub_DF,
                           nitt = 505000,
                           burnin = 5000,
                           thin = 500, prior=prior1)




model_Male_P_P1->model1
summary(model1)
plot(model1$Sol)
plot(model1$VCV)
autocorr.diag(model1$VCV)


saveRDS(model_Male_P_P2, "../results/model_Male_P_P2_NC_WP")


###female




prior1 <- list(R = list(V = 1, fix = 1),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G3 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1)))

prior2 <- list(R = list(V = 1, fix = 1),
               G = list(G1 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G2 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G3 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000)))


model_Female_T_P1<- MCMCglmm(F_EPP_brood~ Age,
                             random=~Partner+ID2 +animal,
                             rcov=~units,
                             family="threshold",
                             pedigree=ped2,
                             data=sub_DF,
                             nitt = 1055000,
                             burnin = 5000,
                             thin = 1000, prior=prior2)

model_Female_T_P1->model1

summary(model1)
plot(model1$Sol)
plot(model1$VCV)
autocorr.diag(model1$VCV)
saveRDS(model_Femalee_T_P2, "../results/model_Female_T_P1_NC_WP")


####DGE + PE + Partner PE + Partner IGEs models ######

invA <- inverseA(ped2)$Ainv #create relatedness matrix (need it for computing both DGE and partner IGES)

####Male EPR
prior1 <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G3 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G4 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1)))



prior2 <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G2 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G3 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G4 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000)))




model_Male_P_P1<- MCMCglmm(male_brood_EPO~ Age,
                           random=~animal+ID2+Partner+Partner2,
                           rcov=~units,
                           family="poisson",
                           ginverse=list(animal=invA, Partner=invA),
                           data=sub_DF,
                           nitt = 1055000,
                           burnin = 5000,
                           thin = 1000, prior=prior1)



model_Male_P_P1->model1
summary(model1)
plot(model1$Sol)
plot(model1$VCV)

autocorr.diag(model1$VCV)
saveRDS(model_Male_P_P1, "../results/model_Male_P_P1_IGE")




####female


prior1 <- list(R = list(V = 1, fix = 1),
               G = list(G1 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G3 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G4 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1)))

prior2 <- list(R = list(V = 1, fix = 1),
               G = list(G1 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G2 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G3 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G4 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000)))


model_Female_T_P1<- MCMCglmm(F_EPP_brood~ Age,
                           random=~animal+ID2+Partner + Partner2,
                           rcov=~units,
                           family="threshold",
                           ginverse=list(animal=invA, Partner=invA),
                           data=sub_DF,
                           nitt = 2555000,
                           burnin = 5000,
                           thin = 2000, prior=prior2)



model_Female_T_P1->model1

summary(model1)
plot(model1$Sol)
plot(model1$VCV)
autocorr.diag(model1$VCV)

saveRDS(model_Female_T_P1, "../results/model_Female_T_P1_IGE")





####cov(DGE + PartnerIGEs) + PE + Partner PE#####
invA <- inverseA(ped2)$Ainv

##male EPR
prior1 <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = diag(2), nu = 1, alpha.mu =c(0,0), alpha.V = diag(2)),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G3 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1)))


prior2 <- list(R = list(V = 1, nu = 1),
               G = list(G1 = list(V = diag(2)*0.02, nu = 2, alpha.mu = c(0,0), alpha.V = diag(2)*1000),
                        G2 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G3 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000)))

model_Male_P_P1<- MCMCglmm(male_brood_EPO~ Age,
                           random=~str(animal+Partner)+ID2+ Partner2,
                           rcov=~units,
                           family="poisson",
                           ginverse=list(animal=invA, Partner=invA),
                           data=sub_DF,
                           nitt = 6055000,
                           burnin = 5000,
                           thin = 3000, prior=prior1)


model_Male_P_P1->model1
summary(model1)
plot(model1$Sol)
plot(model1$VCV)
autocorr.diag(model1$VCV)


saveRDS(model_Male_P_P1, "../results/model_Male_P_P1_IGE_Cov")


###female

prior1 <- list(R = list(V = 1, fix = 1),
               G = list(G1 = list(V = diag(2), nu = 1, alpha.mu =c(0,0), alpha.V = diag(2)),
                        G2 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1),
                        G3 = list(V = 1, nu = 1, alpha.mu = 0, alpha.V = 1)))

prior2 <- list(R = list(V = 1, fix = 1),
               G = list(G1 = list(V = diag(2)*0.02, nu = 2, alpha.mu = c(0,0), alpha.V = diag(2)*1000),
                        G2 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000),
                        G3 = list(V = 0.01, nu = 1, alpha.mu = 0, alpha.V = 1000)))


model_Female_T_P1<- MCMCglmm(F_EPP_brood~ Age,
                             random=~str(animal+Partner)+ID2+ Partner2,
                             rcov=~units,
                             family="threshold",
                             ginverse=list(animal=invA, Partner=invA),
                             data=sub_DF,
                             nitt = 6055000,
                             burnin = 5000,
                             thin = 3000, prior=prior1)

model_Female_T_P1->model1
summary(model1)
plot(model1$Sol)
plot(model1$VCV)
autocorr.diag(model1$VCV)

saveRDS(model_Female_T_P1, "../results/model_Female_T_P1_IGE_Cov")




