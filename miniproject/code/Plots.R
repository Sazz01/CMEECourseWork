#AUTHOR: Sarah Dobson sld21@ic.ac.uk
#DATE: 21th November 2021
#DESCRIPTION: plotting the model outputs for each dataset and checking to see if the NLLS model assumptions are met for every converged model in every dataset.


#####Remove anything elsee already in the workspace######
rm(list=ls())

#######Load in required packages########
require("tidyverse")
require("broom")
require("minpack.lm")


###########Load in data#########
data <- read.csv("../data/wrangled_data.csv")

#######Non linear model equations####
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
                                                                             (t + t_lag)))))-1)/(exp(K-N_0))))}


##########Plotting the Predicted Lines for a dataset where all models converged ########

data2<- data %>% filter(Rep_ID == "245_1") 


###Assigning starting parameters
N_0_start <- data2$PopBio[which.max(data2$counter)] 
K_start <- max(data2$PopBio) 
A<- lm(logPopBio~ Time, data = data2)
r_val <- coef(summary(A))["Time", "Estimate"]
filtdata <- filter(data2, counter > 1/2* max(counter)) 
t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$PopBio)))]
N_0_start2 <- data2$logPopBio[which.max(data2$counter)] # using the log population size for the gompertz model
K_start2 <- max(data2$logPopBio) # using the log population size for the gompertz model

#Run models
fit_logistic <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), data = data2,
                      list( r_max=r_val, N_0 = N_0_start, K = K_start), control = list(maxiter = 1000))

fit_gompertz <- nlsLM(logPopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), data = data2,
                      list( r_max=r_val, N_0 = N_0_start2, K = K_start2, t_lag= t_lag2), control = list(maxiter = 1000))   


fit_baranyi<- nlsLM(logPopBio ~ baranyi(t = Time, r_max, K, N_0, t_lag), data= data2,
                    list(K = K_start, N_0 = N_0_start, r_max = r_val, t_lag = t_lag2), control = list(maxiter = 1000))

 

##Getting the predicted values and a nice looking curve

timepoints <- seq(min(data2$Time), max(data2$Time)) ##assign a sequence ranging from the minimum to the maximum time value


#to get predicted values, run the models again using the parameters from the previously run models and the time points that have just been generated
logistic_points <- logistic_model(t = timepoints, 
                                  r_max = coef(fit_logistic)["r_max"], 
                                  N = coef(fit_logistic)["N_0"],
                                  K = coef(fit_logistic)["K"])

gompertz_points <- gompertz_model(t = timepoints, 
                                  r_max = (coef(fit_gompertz)["r_max"]), 
                                  N = (coef(fit_gompertz)["N_0"]),
                                  K = (coef(fit_gompertz)["K"]),
                                  t_lag =(coef(fit_gompertz)["t_lag"]))

baranyi_points <- baranyi(t = timepoints, 
                                  r_max = (coef(fit_baranyi)["r_max"]), 
                                  N = (coef(fit_baranyi)["N_0"]),
                                  K = (coef(fit_baranyi)["K"]),
                                  t_lag = (coef(fit_baranyi)["t_lag"]))

#assign these predicted values and the time points into a dataframe for each model

df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic Model"  #assign a column which specifies the model the values were taken from
names(df1) <- c("Time", "PopBio", "model") #assign columns names with the parameters used
df1$LogPopBio <- log(df1$PopBio) #log PopBio estimate so that the predictions from the model will be on the same scale as the other models

df2 <- data.frame(timepoints, gompertz_points )
df2$model <- "Gompertz equation"
names(df2) <- c("Time", "LogPopBio", "model")


df3 <- data.frame(timepoints, baranyi_points )
df3$model <- "baranyi equation"
names(df3) <- c("Time", "LogPopBio", "model")


###plot the lines
plot1 <-ggplot(data2, aes(x = Time, y = logPopBio)) + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), size = 1, se = F, aes(colour="Cubic Regression Model")) + 
  geom_smooth(method = "lm", formula = y ~poly(x, 2), size = 1, se = F, aes(colour="Quadratic Regression Model")) + 
  geom_line(data = df1, aes(x = Time, y = LogPopBio, colour = "Logistic Model"), size =  1) + 
  geom_line(data = df2, aes(x = Time, y = LogPopBio, colour = "Gompertz Model"), size =  1) + 
  geom_line(data = df3, aes(x = Time, y = LogPopBio, colour = "Baranyi Model"), size =  1)+
  scale_colour_manual(name="legend", values=c("blue", "red", "green", "purple", "orange"))+ labs(x= "Time", y = "Log Population size" )+ geom_point(shape = 1, size = 3) + theme_bw()+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"), legend.position = c(0.25, 0.75), legend.title = element_text(size = 12, face="bold"), legend.key.size = unit(10, "mm"), legend.text = element_text(size=10)) +scale_x_continuous(limits = c(0, 800))+scale_y_continuous(limits = c(-6, -3))

#save plot
pdf("../results/245_1.pdf", 8.7, 8.7)
print(plot1)
graphics.off()

#####plotting predicted lines from a dataframe where all model converged except baranyi
data2<- data %>% filter(Rep_ID == "126_1") 


###Assigning starting parameters
N_0_start <- data2$PopBio[which.max(data2$counter)] 
K_start <- max(data2$PopBio) 
A<- lm(logPopBio~ Time, data = data2)
r_val <- coef(summary(A))["Time", "Estimate"]
filtdata <- filter(data2, counter > 1/2* max(counter)) 
t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$PopBio)))]
N_0_start2 <- data2$logPopBio[which.max(data2$counter)] 
K_start2 <- max(data2$logPopBio) 

#run models
fit_logistic <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), data = data2,
                      list( r_max=r_val, N_0 = N_0_start, K = K_start), control = list(maxiter = 1000))


fit_gompertz <- nlsLM(logPopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), data = data2,
                      list( r_max=r_val, N_0 = N_0_start2, K = K_start2, t_lag= t_lag2), control = list(maxiter = 1000))   

##Getting the predicted values and a nice looking curve

timepoints <- seq(min(data2$Time), max(data2$Time))



logistic_points <- logistic_model(t = timepoints, 
                                  r_max = coef(fit_logistic)["r_max"], 
                                  N = coef(fit_logistic)["N_0"],
                                  K = coef(fit_logistic)["K"])


gompertz_points <- gompertz_model(t = timepoints, 
                                  r_max = (coef(fit_gompertz)["r_max"]), 
                                  N = (coef(fit_gompertz)["N_0"]),
                                  K = (coef(fit_gompertz)["K"]),
                                  t_lag =(coef(fit_gompertz)["t_lag"]))

df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic Model"  #assign a column which specifies the model the values were taken from
names(df1) <- c("Time", "PopBio", "model") #assign columns names with the parameters used
df1$LogPopBio <- log(df1$PopBio) #log PopBio estimate so that the predictions from the model will be on the same scale as the other models

df2 <- data.frame(timepoints, gompertz_points )
df2$model <- "Gompertz equation"
names(df2) <- c("Time", "LogPopBio", "model")





#####Plotting the model

plot2<-ggplot(data2, aes(x = Time, y = logPopBio)) + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), size = 1, se = F, aes(colour="Cubic Regression")) + 
  geom_smooth(method = "lm", formula = y ~poly(x, 2), size = 1, se = F, aes(colour="Quadratic Regression")) + 
  geom_line(data = df1, aes(x = Time, y = LogPopBio, colour = "Logistic Model"), size =  1) + 
  geom_line(data = df2, aes(x = Time, y = LogPopBio, colour = "Gompertz Model"), size =  1) + 
  scale_colour_manual(name="legend", values=c("blue", "red", "green", "purple", "orange"))+ labs(x= "Time", y = "Log Population size" )+ geom_point(shape = 1, size = 3) + theme_bw()+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"), legend.position = c(0.25, 0.75), legend.title = element_text(size = 12, face="bold"), legend.key.size = unit(10, "mm"), legend.text = element_text(size=10)) 
#save the plot
pdf("../results/126_1.pdf", 8.7, 8.7)
print(plot2)
graphics.off()



######Plotting a model where only the cubic, quadratic and the logisitc model converged

data2<- data %>% filter(Rep_ID == "230_1") 


###Assigning starting parameters
N_0_start <- data2$PopBio[which.max(data2$counter)] # lowest population size
K_start <- max(data2$PopBio) # highest population size
A<- lm(logPopBio~ Time, data = data2)
r_val <- coef(summary(A))["Time", "Estimate"]
filtdata <- filter(data2, counter > 1/2* max(counter)) ##filter data so that it contains only the first half of the dataset
t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$PopBio)))]###estimate time lag from the largest difference between the differences between each datapoint from the first half of the dataset.

N_0_start2 <- data2$logPopBio[which.max(data2$counter)] # lowest population size
K_start2 <- max(data2$logPopBio)

#######run models#############
fit_logistic <- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), data = data2,
                      list( r_max=r_val, N_0 = N_0_start, K = K_start), control = list(maxiter = 1000))


##Getting the predicted values and a nice looking curve

timepoints <- seq(min(data2$Time), max(data2$Time))

logistic_points <- logistic_model(t = timepoints, 
                                  r_max = coef(fit_logistic)["r_max"], 
                                  N = coef(fit_logistic)["N_0"],
                                  K = coef(fit_logistic)["K"])

df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic Model"  #assign a column which specifies the model the values were taken from
names(df1) <- c("Time", "PopBio", "model") #assign columns names with the parameters used
df1$LogPopBio <- log(df1$PopBio) #log PopBio estimate so that the predictions from the model will be on the same scale as the other models


#Plot the lines
plot3<-ggplot(data2, aes(x = Time, y = logPopBio)) + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), size = 2, se = F, aes(colour="Cubic Regression")) + 
  geom_smooth(method = "lm", formula = y ~poly(x, 2), size = 1, se = F, aes(colour="Quadratic Regression")) + 
  geom_line(data = df1, aes(x = Time, y = LogPopBio, colour = "Logistic Model"), size =  1) + 
  scale_colour_manual(name="legend", values=c("blue", "red", "green"))+ labs(x= "Time", y = "Log Population size" )+ geom_point(shape = 1, size = 3) + theme_bw()+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"), legend.position = c(0.75, 0.25), legend.title = element_text(size = 12, face="bold"), legend.key.size = unit(10, "mm"), legend.text = element_text(size=10)) 

#save the plot
pdf("../results/230_1.pdf", 8.7, 8.7)
print(plot3)
graphics.off()

########checking NLLS model assumptions###############  




###Creating the functions needed to extract the prediction data


Augment_Model_log <- function(data, ...) {tryCatch( {
  A<- lm(PopBio~ Time, data = data)
  r_val <- coef(summary(A))["Time", "Estimate"]
  augment(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), data= data,
        list(K = max(data$PopBio), N_0 = data$PopBio[which.max(data$counter)], r_max = r_val), control = list(maxiter = 1000))) ##augment extracts the predicted values from the model
},
error = function(e) {
  tibble(PopBio    = c(NA_real_),
         Time      = c(NA_real_),
         .fitted  = c(NA_real_),
         .resid   = c(NA_real_))
})}



Aug_Model_Gom <- function(data, ...) {
  
  tryCatch( {
    A<- lm(logPopBio~ Time, data = data)
    
    filtdata <- filter(data, counter > 1/2* max(counter)) 
    t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$logPopBio)))]
    
    K_val_= max(data$logPopBio)
    N_0_start = data$logPopBio[which.max(data$counter)]
    r_val<- coef(summary(A))["Time", "Estimate"]

    
    augment(nlsLM(logPopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), data= data,
                  list(K = K_start, 
                       N_0 = N_0_start,
                       r_max = r_val, t_lag = t_lag2), control = list(maxiter = 1000)))
    
  },   
  error = function(e) {
    tibble(estimate    = c(NA_real_),
           p.value      = c(NA_real_),
           statistic    = c(NA_real_),
           std.error    = c(NA_real_),
           term = c(NA_character_))
    
  })}



Augment_Model_Bar <- function(data, ...) {
  
  tryCatch( {
    A<- lm(logPopBio~ Time, data = data)
    
    filtdata <- filter(data, counter > 1/2* max(counter)) 
    t_lag2<- filtdata$Time[which.max(diff(diff(filtdata$PopBio)))]
    
    K_val_est= max(data$PopBio)
    N_0_est = data$PopBio[which.max(data$counter)]
    r_val_est <- coef(summary(A))["Time", "Estimate"]
    t_lag_est<- t_lag2
    
    augment(nlsLM(PopBio ~ baranyi(t = Time, r_max, K, N_0, t_lag), data= data,
          list(K = K_val_est, 
               N_0 = N_0_est,
               r_max = r_val_est, t_lag = t_lag2), control = list(maxiter = 1000)))
    
  },   
  error = function(e) {
    tibble(logPopBio    = c(NA_real_),
           Time      = c(NA_real_),
           .fitted  = c(NA_real_),
           .resid   = c(NA_real_))
    
  })}


####Running the Models

Augment_Results_Gom <- data %>% group_by(Rep_ID) %>% group_modify((~ Aug_Model_Gom (data = .))) 
Augment_Results_log <-data %>% group_by(Rep_ID) %>% group_modify(~ Augment_Model_log (data = .))
Augment_Results_Bar <-data %>% group_by(Rep_ID) %>% group_modify(~ Augment_Model_Bar (data = .))

##plotting the plots to check NLLS model assumptions for every dataset

#plotting histograms of each models'residuals
ggplot(Augment_Results_Gom, aes(.resid)) + geom_histogram()+ facet_wrap(Augment_Results_Gom$Rep_ID, scales = "free")# for the Gompertz models
ggplot(Augment_Results_log, aes(.resid)) + geom_histogram()+ facet_wrap(Augment_Results_log$Rep_ID, scales = "free")#for the LOgisitc models
ggplot(Augment_Results_Bar, aes(.resid)) + geom_histogram()+ facet_wrap(Augment_Results_Bar$Rep_Bar, scales = "free")#for the baranyi models


##plotting scatterplots of the fitted values vs the residual values for each model
ggplot(Augment_Results_Gom, aes(x= .resid, y =.fitted)) + geom_point()+ geom_smooth(se = F)+ facet_wrap(Augment_Results_Gom$Rep_ID, scales = "free")
ggplot(Augment_Results_log, aes(x= .resid, y =.fitted)) + geom_point()+ facet_wrap(Augment_Results_log$Rep_ID, scales = "free")
ggplot(Augment_Results_Bar, aes(x= .resid, y =.fitted)) + geom_point()+ facet_wrap(Augment_Results_Bar$Rep_ID, scales = "free")

#####Script done####










