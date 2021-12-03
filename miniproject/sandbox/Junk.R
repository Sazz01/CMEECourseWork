ex <- c(rep("ex1", times=4), rep("ex2", times=4))
x <- rep(c(0,60,120,240), times = 2)
y <- c(0,3.73,3.08,4.07,0,1.4,2.6,2.6)

df <- data.frame(ex, x, y)


data6 <-data6%>%
  mutate(N_01 = map_dbl(.data[["data"]], N_0_start)) %>% mutate(K_01 = map_dbl(.data[["data"]], K_start))

data7<- data %>% select(Rep_ID, PopBio, Time, counter) %>% group_by(Rep_ID) %>%nest() %>% mutate(PopBio = rep(list(data6$PopBio), n()))%>% mutate(Time = rep(list(data6$Time), n())) %>% mutate(counter = rep(list(data6$counter), n()))



ggplot(data2, aes(x = logPopBio, y = Time)) + geom_point(shape = 1) + geom_smooth(method = lm,
                                                                                  
                                                                                  se = FALSE)


AIC(lm_growth)

lm_growth <- lm(logPopBio ~ Time + I(Time^2), data = data2)
summary(lm_growth)

ggplot(data2, aes(Time, logPopBio)) +
  geom_point() +
  stat_smooth(method = "lm", formula = y ~ x + I(x^2), size = 1, se = F)






#now for fitting nls on multiple data sets


for (i in data$Rep_ID){
  
  n<- nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0),
            start = list(K = min(data$PopBio),
                         N_0 = data$PopBio[which.max(data$counter)],
                         r_max = 0.01), subdata = i) 
  
}




levs <- levels(data$Rep_ID)
Map(sublm, levs)

start_val_sigmoid <-
  list(K = min(data$PopBio),
       N_0 = data$PopBio[which.max(data$counter)],
       r_max = 0.01)


start_val_sigmoid <- function(y, x) {
  list(K = min(y),
       N_0 = y[which.max(x)],
       r_max = 0.01) }

start_val_sigmoid <- 
  list(K = min(data$PopBio),
       N_0 = data$PopBio[which.max(data$counter)],
       r_max = 0.01)

dat<- data %>% group_by(Rep_ID)%>%
  do(model = tidy(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), 
                        list(r_max= 0.001, N_0 = 5, K = 800), data = dat))) %>% unnest(model) %>%
  pivot_wider(names_from = "term", values_from = c(estimate, std.error, statistic, p.value))

dat<- data %>% group_by(Rep_ID)%>%
  do(model = glance(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), 
                          list(K = min(PopBio),
                               N_0 = PopBio[which.max(counter)],
                               r_max = 0.01), data = data))) %>% unnest(model) 

dat2<- dat%>% mutate(K_01 = min(.$PopBio)) %>% mutate(N_01 = .$PopBio[which.max(.$counter)]) %>%
  do(model = tidy(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), data= .,
                        start = start_val_sigmoid(dat, counter, PopBio)))) %>% unnest(model) 

fiit = 
  nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), 
        list(K = min(PopBio),
             N_0 = PopBio[which.max(counter)],
             r_max = 0.01), data = data)



dat<- data %>% group_by(Rep_ID)%>% do(data.frame(model=tidy(fiit)))%>% unnest()




######
data5<-data %>% select(Rep_ID, N_0, K)%>% unique() %>% 
  mutate(r_max = rep(0.001)) %>% list()

st1 <- split(as.data.frame(data), levels(df$Rep_ID))

L <- Map(nls, data = split(data, data$Rep_ID), st1, MoreArgs = list(formula = logistic_model()))



summary(fit_logistic)




dat<- data %>% group_by(ID)
data6 <-data6%>%
  mutate(N_01 = map_dbl(.data[["data"]], N_0_start)) %>% mutate(K_01 = map_dbl(.data[["data"]], K_start))

data7<- data %>% select(Rep_ID, PopBio, Time, counter) %>% group_by(Rep_ID) %>%nest() %>% mutate(PopBio = rep(list(data6$PopBio), n()))%>% mutate(Time = rep(list(data6$Time), n())) %>% mutate(counter = rep(list(data6$counter), n()))



mtcars %>% group_by(cyl) %>% nest() %>% mutate(am = rep(list(mtcars$am), n()))


data6<- data %>% group_by(Rep_ID) %>% do(model = tidy(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), data = .,
                                                            list( r_max=r_max_start, N_0 = PopBio[which.max(counter)] , K = max(PopBio))))) %>% unnest(model)%>%
  pivot_wider(names_from = "term", values_from = c(estimate, std.error, statistic, p.value))

dat<- data %>% group_by(ID) %>% do(model = tidy(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0), data = .,
                                                      list(r_max=r_max_start, N_0 = N_0_start, K = K_start)))) %>% unnest(model) %>% 
  pivot_wider(names_from = "term", values_from = c(estimate, std.error, statistic, p.value))

data6<- data %>% group_by(Rep_ID) %>% nest()

N_0_start <- function(df){
  df$PopBio[which.max(df$counter)]
}


K_start <- function(df){
  max(df$PopBio)
}


data6<- data %>% select(Rep_ID, PopBio, Time, counter) %>% group_by(Rep_ID)   
data7<- data6 %>% group_by(Rep_ID) %>% nest() %>% mutate(PopBio = rep(list(data6$PopBio), n()))%>% mutate(Time = rep(list(data6$Time), n())) %>% mutate(Time = rep(list(data6$Time), n()))

data6 <-data6%>% group_by(Rep_ID) %>% nest() %>% 
  mutate(N_01 = map_dbl(.data[["data"]], N_0_start)) %>% mutate(K_01 = map_dbl(.data[["data"]], K_start))


data8<-left_join(data6, data7, by = "Rep_ID")
data8<- data6 %>% unnest(cols = c(data))

dat <- data8 %>% do(model = tidy(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0)), data = .,
                                 start = list(r_max= 0.001, N_0 = N_01, K = K_01))) %>% unnest(model) %>% 
  pivot_wider(names_from = "term", values_from = c(estimate, std.error, statistic, p.value))

data8 %>% group_by(Rep_ID) %>% do(model = tidy(nlsLM(PopBio ~ logistic_model(t = Time, r_max, K, N_0)), data = .,
                                               start = start_val_sigmoid)) %>% unnest(model) %>% 
  pivot_wider(names_from = "term", values_from = c(estimate, std.error, statistic, p.value))

