#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: 21th November 2021
#DESCRIPTION: fitting quadratic, cubic, logistic, gompertz and the baranyi model across many datasets

#####Remove anything elsee already in the workspace######
rm(list=ls())

#######Load in required packages########
require("tidyverse")
require("minpack.lm")
require("broom")
require("MuMIn")

###########Load in data#########
data <- read.csv("../data/wrangled_data.csv")




######Linear Model Fitting######

#quadratic linear regression model

quadratic_results_tidy<- data %>% group_by(Rep_ID) %>% 
  do(model = tidy(lm(logPopBio ~ poly(Time,2), na.action=na.exclude, data = .))) %>% #group_by and then do() runs the specified model across each dataset, tidy() pulls the parameter estimates and puts them in a dataframe
unnest(model) #unnest makes the model outputs from the tidy dataframe readable

quadratic_results_glance<- data %>% group_by(Rep_ID) %>%
  do(model = glance(lm(logPopBio ~ poly(Time,2), na.action=na.exclude, data = .))) %>% ##glance extracts whole model estimates from each model across each dataset and puts them in a dataframe
  unnest(model)%>%select(Rep_ID, AIC) %>% rename(Quadratic_AIC = AIC) ##select AIC values 

quadratic_results_AICc<- data %>% group_by(Rep_ID) %>% do(model = AICc(lm(logPopBio ~ poly(Time,2), na.action=na.exclude, data = .))) %>% ##AICc extracts the AICc value from each model
unnest(model)%>%select(Rep_ID, model) %>% rename(Quadratic_AICc = model) #select only the dataset and AICc columns

quadratic_results_glance <- left_join(quadratic_results_glance, quadratic_results_AICc, by = "Rep_ID") ##joins AICc value, convergence info and AIC values for the quadratic model for each dataset.


#cubic linear regression 

cubic_results_tidy<- data %>% group_by(Rep_ID) %>% do(model = tidy(lm(logPopBio ~ poly(Time,3), na.action=na.exclude, data = .))) %>% unnest(model)

cubic_results_glance<- data %>% group_by(Rep_ID) %>% do(model = glance(lm(logPopBio ~ poly(Time,3), na.action=na.exclude, data = .))) %>% unnest(model)%>%select(Rep_ID,AIC) %>% rename(Cubic_AIC = AIC) 

cubic_results_AICc<- data %>% group_by(Rep_ID) %>% do(model = AICc(lm(logPopBio ~ poly(Time,3), na.action=na.exclude, data = .))) %>% unnest(model)%>%select(Rep_ID, model) %>% rename(Cubic_AICc = model)

cubic_results_glance <- left_join(cubic_results_glance, cubic_results_AICc, by = "Rep_ID")



#######Non linear model fitting########

#NLSS Growth Equations
logistic_model <- function(t, r_max, K, N_0){ 
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

gompertz_model <- function(t, r_max, K, N_0, t_lag){
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}


baranyi <- function(t=Time, r_max, K, N_0, t_lag) {N_0 + r_max * (t + (1/r_max) * log(exp(-r_max*t) +
                                                                                        exp(-r_max * t_lag) - exp(-r_max * (t + t_lag)))) -
    log(1 + ((exp(r_max * (t + (1/r_max) * log(exp(-r_max*t) +
                                                 exp(-r_max * t_lag) - exp(-r_max *
                                                                             (t + t_lag)))))-1)/(exp(K-N_0))))
  }




#Logistic model part 1: Functions that extract the parameter estimates, whole model estimates and AICc values from inputted data



Tidy_Model_log <- function(data, ...) {
  tryCatch( { #try catch catches any errors (ie. if any datasets do not converge when running the model)
  A<- lm(logPopBio~ Time, data = data) #linear regression on log of the populaton size 
  r_val <- coef(summary(A))["Time", "Estimate"] #assign the estimate for the slope as r_max
  K_start <- max(data$logPopBio) #assign the maximum population size recorded as the carrying capacity
  N_0_start <- dat$logPopBio[which.max(dat$counter)] #assign the first data point as the inital population
  nlsLM(logPopBio ~ logistic_model(t = Time, r_max, K, N_0), data= data,
        list(K = K_start, N_0 = N_0_start, r_max = r_val), control = list(maxiter = 1000)) %>% tidy() #tidy extracts the parameter estimates from eahc model
},   
error = function(e) { #if a dataset doesnt run, trycatch catches the error and 'puts it' in the dataframe below- basically assigns outputs from models that dont converge as NA's in the final dataframe
  tibble(estimate    = c(NA_real_),
         p.value      = c(NA_real_),
         statistic    = c(NA_real_),
         std.error    = c(NA_real_),
         term = c(NA_character_))
})}

Glance_Model_log <- function(data, ...) {
  tryCatch( {
  A<- lm(logPopBio~ Time, data = data)
  r_val <- coef(summary(A))["Time", "Estimate"]
  K_start<- max(data$logPopBio)
  N_0_start<-data$logPopBio[which.max(data$counter)]
nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), data= data,
        list(K = K_start, N_0 = N_0_start, r_max = r_val), control = list(maxiter = 100)) %>% glance() #glace extracts the whole model estimates
}, 
error = function(e) {
  tibble(sigma    = c(NA_real_),
         isConv      = c(NA),
         finTol    = c(NA_real_),
         logLik    = c(NA_real_),
         AIC = c(NA_real_),
         BIC  = c(NA_real_),
         deviance = c(NA_real_),
         df.residual = c(NA_real_),
         nobs = c(NA_real_))
})}


Glance_Model_log_AICC <- function(data, ...) {
  tryCatch( {
  A<- lm(logPopBio~ Time, data = data)
  r_val <- coef(summary(A))["Time", "Estimate"]
  K_start<-max(data$logPopBio)
  N_0_start<- data$logPopBio[which.max(data$counter)]
  nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), data= data,
        list(K = K_start, N_0 = N_0_start, r_max = r_val), control = list(maxiter = 1000)) %>% MuMIn::AICc() %>% as_tibble() #AICc extracts the AICc value and as_tibble() puts it in a tibble(dataframe)
},
error = function(e) {
  print(e)
  tibble(value  = c(NA_real_),)
})}



#Logistic model part 2: Running Logistic models on the data and assigning ouputs to dataframes



Tidy_Results_log <- data %>% group_by(Rep_ID)  %>% group_modify(~ Tidy_Model_log (data = .)) #group_modify applies the function specified (Tidy_Model_log) across the group specified by group_by (Rep_ID- individual datasets). 

Glance_Results_log_AICc <- data %>% group_by(Rep_ID) %>% group_modify(~ Glance_Model_log_AICC (data = .)) %>% rename(Log_AICc = value) #extracts AICc and renames the AICc column to better identify which model it belongs to when I combine dataframes later 

Glance_Results_log <- data %>% group_by(Rep_ID) %>% group_modify(~ Glance_Model_log (data = .)) %>% left_join(., Glance_Results_log_AICc, by = "Rep_ID") %>% #joins glance() outputs to the AICc outputs
  select(Rep_ID, Log_AICc, isConv)%>% rename(Log_Conv = isConv) %>% mutate(Log_AICc = replace(Log_AICc, Log_Conv == "FALSE", NA)) #extracts the dataset name, AICc and convergence info columns and then replaces the AICc values for each dataset if the model didnt converge






#Gompertz model part 1: Functions that extract the parameter estimates, whole model estimates and AICc values from inputted data


Tidy_Model_Gom <- function(data, ...) {
  
  tryCatch( {
    A<- lm(logPopBio~ Time, data = data)
    r_val <- coef(summary(A))["Time", "Estimate"]
    filtdata <- data %>% filter(counter > 1/2* max(counter)) ##filter data so that it contains only the first half of the dataset
    t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$logPopBio)))] ###estimate time lag from the largest difference between the differences between each datapoint from the first half of the dataset.
    N_0_start = data$logPopBio[which.max(data$counter)]
    K_start = max(data$logPopBio)
    
    nlsLM(PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), data= data, 
                  list(K = K_start,N_0 = N_0_start, r_max = r_val, t_lag = t_lag2), control = list(maxiter = 100)) %>% tidy()
    },   
  error = function(e) {
    tibble(estimate    = c(NA_real_),
           p.value      = c(NA_real_),
           statistic    = c(NA_real_),
           std.error    = c(NA_real_),
           term = c(NA_character_))
    
  })}



Glance_Model_Gom <- function(data, ...) {
  
  tryCatch( {
    A<- lm(logPopBio~ Time, data = data)
    r_val <- coef(summary(A))["Time", "Estimate"]
    filtdata<- data %>% filter(counter > 1/2* max(counter)) 
    t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$logPopBio)))]
    N_0_start = data$logPopBio[which.max(data$counter)]
    K_start = max(data$logPopBio)
    
    nlsLM(logPopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), data= data, 
                  list(K = K_start, N_0 = N_0_start, r_max = r_val, t_lag = t_lag2), control = list(maxiter = 1000)) %>% glance()
    },   
  error = function(e) {
    print(e)
    tibble(sigma    = c(NA_real_),
           isConv      = c(NA),
           finTol    = c(NA_real_),
           logLik    = c(NA_real_),
           AIC      = c(NA_real_),
           BIC        = c(NA_real_),
           deviance =c(NA_real_),
           df.residual = c(NA_real_),
           nobs = c(NA_real_))
    
  })}


Glance_Model_Gom_AICC <- function(data, ...) {
  
  tryCatch( {
    A<- lm(logPopBio~ Time, data = data)
    r_val <- coef(summary(A))["Time", "Estimate"]
    filtdata <- data %>% filter(counter > 1/2* max(counter)) 
    t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$logPopBio)))]
    N_0_start = data$logPopBio[which.max(data$counter)]
    K_start = max(data$logPopBio)
    
    nlsLM(logPopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), data= data, 
                  list(K = K_start, N_0 = N_0_start, r_max = r_val, t_lag = t_lag2), control = list(maxiter = 1000)) %>% MuMIn::AICc() %>% as_tibble()
    
  },   
  error = function(e) {
    print(e)
    tibble(value    = c(NA_real_))
    
  })}


#Gompertz model part 2: Running Gompertz model on the data 

Tidy_Results_Gom <- data %>% group_by(Rep_ID) %>% group_modify((~ Tidy_Model_Gom (data = .))) 

Glance_Results_Gom_AICC <- data %>% group_by(Rep_ID) %>% group_modify((~ Glance_Model_Gom_AICC (data = .))) %>% rename(Gom_AICc = value)

Glance_Results_Gom <-  data %>% group_by(Rep_ID)  %>% group_modify(~ Glance_Model_Gom (data = .)) %>% left_join(., Glance_Results_Gom_AICC, by = "Rep_ID") %>% select(Rep_ID, Gom_AICc, isConv) %>% rename(Gom_Conv = isConv)%>% mutate(Gom_AICc = replace(Gom_AICc, Gom_Conv == "FALSE", NA))



#Baranyi model part 1: Functions that extract the parameter estimates, whole model estimates and AICc values from inputted data


Glance_Model_Bar <- function(data, ...) {
  
  tryCatch( {
    A<- lm(logPopBio~ Time, data = data)
    
    filtdata <- data %>% filter(counter > 1/2* max(counter)) 
    t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$PopBio)))]
    
    K_val_est= max(data$PopBio)
    N_0_est = data$PopBio[which.max(data$counter)]
    r_val_est <- coef(summary(A))["Time", "Estimate"]
    t_lag_est<- t_lag2

        nlsLM(logPopBio ~ baranyi(t = Time, r_max, K, N_0, t_lag), data= data,
          list(K = K_val_est, N_0 = N_0_est, r_max = r_val_est, t_lag = t_lag2), control = list(maxiter = 1000)) %>% glance() 
    },   
  error = function(e) {
    print(e)
    tibble(sigma    = c(NA_real_),
           isConv      = c(NA),
           finTol    = c(NA_real_),
           logLik    = c(NA_real_),
           AIC      = c(NA_real_),
           BIC        = c(NA_real_),
           deviance =c(NA_real_),
           df.residual = c(NA_real_),
           nobs = c(NA_real_))
    
  })}



Tidy_Model_Bar <- function(data, ...) {
  
  tryCatch( {
    A<- lm(logPopBio~ Time, data = data)
    r_val <- coef(summary(A))["Time", "Estimate"]
    filtdata<- data %>% filter(counter > 1/2* max(counter)) 
    t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$PopBio)))]
    
    K_val_est= max(data$PopBio)
    N_0_est = data$PopBio[which.max(data$counter)]
    r_val_est <- coef(summary(A))["Time", "Estimate"]
    t_lag_est<- t_lag2
    
    nlsLM(logPopBio ~ baranyi(t = Time, r_max, K, N_0, t_lag), data= data,
          list(K = K_val_est, 
               N_0 = N_0_est,
               r_max = r_val_est, t_lag = t_lag2), control = list(maxiter = 1000)) %>% tidy() 
    
  },   
  error = function(e) {
    print(e)
    tibble(sigma    = c(NA_real_),
           isConv      = c(NA),
           finTol    = c(NA_real_),
           logLik    = c(NA_real_),
           AIC      = c(NA_real_),
           BIC        = c(NA_real_),
           deviance =c(NA_real_),
           df.residual = c(NA_real_),
           nobs = c(NA_real_))
    
  })}




Glance_Model_Bar_AICc <- function(data, ...) {
  
  tryCatch( {
    A<- lm(logPopBio~ Time, data = data)
    
    filtdata <- data %>% filter(counter > 1/2* max(counter)) 
    t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$PopBio)))]
    K_val_est= max(data$PopBio)
    N_0_est = data$PopBio[which.max(data$counter)]
    r_val_est <- coef(summary(A))["Time", "Estimate"]
   
    
    nlsLM(logPopBio ~ baranyi(t = Time, r_max, K, N_0, t_lag), data= data,
          list(K = K_val_est, N_0 = N_0_est, r_max = r_val_est, t_lag = t_lag2), control = list(maxiter = 1000)) %>% MuMIn::AICc() %>% as_tibble()
    },   
  error = function(e) {
    print(e)
    tibble(value = c(NA_real_))
    
  })}


#Baranyi model part 2: Running Baranyi model on the data 

Tidy_Results_Bar <- data %>% group_by(Rep_ID) %>% group_modify((~ Tidy_Model_Bar (data = .)))

Glance_Results_Bar_AICc <- data %>% group_by(Rep_ID) %>% group_modify((~ Glance_Model_Bar_AICc (data = .))) %>% rename(Bar_AICc = value)

Glance_Results_Bar <-  data %>% group_by(Rep_ID)  %>% group_modify(~ Glance_Model_Bar (data = .)) %>% 
  left_join(., Glance_Results_Bar_AICc, by = "Rep_ID")%>% select(Rep_ID, Bar_AICc, isConv)%>% rename(Bar_Conv = isConv)%>% 
  mutate(Bir_AICc = replace(Bar_AICc, Bar_Conv == "FALSE", NA))



#####Making and saving dataframes dataframes#########


#joining all the data frames with AICc and Convergence Information together
AICc_Conv_AIC_dataframe <- list(quadratic_results_glance, cubic_results_glance, Glance_Results_log, Glance_Results_Gom, Glance_Results_Bar) %>% reduce(left_join)

#save the dataframe
write.csv(AICc_Conv_AIC_dataframe, "../results/AIC_Conv.csv", row.names=FALSE)

#select just the AICc values for each model
AICc_dataframe<-select(AICc_Conv_AIC_dataframe, Rep_ID, Cubic_AICc, Quadratic_AICc, Log_AICc, Gom_AICc, Bar_AICc)

#determine the model with the smallest AICc value for each dataset
AICc_bestmod_dataframe <- AICc_dataframe %>% mutate(across(c(Cubic_AICc, Quadratic_AICc, Log_AICc, Gom_AICc, Bar_AICc), abs))%>% rowwise %>% mutate(Best_model= names(.)[2:6][which.min(c(Cubic_AICc, Quadratic_AICc, Log_AICc, Gom_AICc, Bar_AICc))])

#save the dataframe
write.csv(AICc_bestmod_dataframe, "../results/AICcs.csv", row.names=FALSE)

# Rename AICc columns and calculate how many times each model Converged
AICc_bestmod_dataframe <- AICc_bestmod_dataframe %>% rename(Baranyi = Bar_AICc, Gompertz = Gom_AICc, Logistic = Log_AICc, Cubic = Cubic_AICc, Quadratic = Quadratic_AICc) 
AICc_bestmod_count<- as_tibble(table(AICc_bestmod_dataframe$Best_model), .name_repair = ~c("Model", "Best Model Count")) %>% mutate("Convergence Count"= c(26, 228, 128, 221, 228))


#Save dataframe
write.csv(AICc_bestmod_count, "../results/ModelResults.csv", row.names=FALSE)



######end of the script######







