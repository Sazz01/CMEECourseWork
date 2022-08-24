rm(list = ls())
#AUTHOR: Sarah Dobson
#DATE: 18th January 2022
#Description: Code wrangles data, creating different measurements of EPR and Social bond strength for both males and females, and 
#combines most of them into one dataframe ready to be modelled.

#######required packages####
require(tidyverse)
library(lubridate)

###load in data#####

myDF<- read.table("../data/tblBroodEvents.txt", header = T, sep = ",")

MyDF_new <- read.csv("../data/FitnessCorrelatesSparrows2016.csv", header = T, sep = ",")

MyDF2 <-read.csv("../data/EP_Final", header = T, sep = ",", dec = ".")


###create pedigree###

Pedigree <- MyDF2 %>% select(Offspring, Dam, Sire) %>% rename(ID = Offspring)%>% rename(MOTHER= Dam) %>% rename(FATHER = Sire) 


####Creating Female Extra Pair Measurements##### 


##create a dataframe where female EPR is measured as a binary trait (offspring ia either EPO or WPO)
MyDF3 <- MyDF2 %>% select(-Notes, -BroodRef)%>% filter(!grepl("U", BroodName))%>% 
  filter(!grepl("U", EP))



#create a dataframe with female EPR measured as percentage of clutch that is EP0.
MyDF4<-MyDF3 %>% group_by(BroodName, EP) %>% mutate(count = n()) %>%  select(-Offspring) %>%
  filter (! duplicated(BroodName))%>% filter(!grepl("U", BroodName))%>% 
  filter(!grepl("U", EP)) %>% pivot_wider(names_from = "EP", values_from = count) %>% group_by(BroodName) %>% 
  summarise_all(funs(.[!is.na(.)][1])) %>% replace(is.na(.), 0) %>%
  rename(c(FEPO = "1", FWPO = "0")) %>% mutate(FTO= FEPO + FWPO) %>% mutate(FPercentEP = FEPO/FTO) 
#Now create column to indicate whether per cluctch a female has at least one EPO offspring, 0 for no, 1 for yes. 
MyDF4 <- MyDF4 %>%
  group_by(BroodName) %>% mutate(F_EPP_brood = case_when(FPercentEP == 0 ~ 0, FPercentEP > 0 ~ 1)) 


#Now create a column to indicate how many clutches had EPO for every female
MyDF4 <- MyDF4%>% group_by(Dam) %>% tally(F_EPP_brood == 1) %>% rename(Female_total_EPO_clutches = n) %>% inner_join(MyDF4, by='Dam') %>% select(-Sire)


###creating measurements for the strength of the social bond- will be using the females measure of the social bond

### calculate the number of broods females have had with each partner
MyDF6<- MyDF3 %>% select(Dam, SocialDadID, BroodName, Cohort) %>% 
  filter (! duplicated(BroodName)) %>% na.omit() %>% group_by(Dam) %>% select(-BroodName) %>% group_by(Dam, SocialDadID)%>% select(-Cohort) %>% mutate(count = n())%>% distinct(.) %>% 
  rename(Number_Broods_with_Partner = count)


MyDF6<- MyDF3 %>% select(Dam, SocialDadID, BroodName, Cohort) %>% 
  filter (! duplicated(BroodName)) %>% na.omit() %>% unite("all", Dam:SocialDadID, remove = FALSE) %>% arrange(Dam, Cohort, BroodName, SocialDadID) %>%
  group_by(gr = cumsum(all != lag(all, default = first(all)))) %>%
  mutate(count = n()) %>% 
  rename(Number_Broods_with_Partner = count) %>% ungroup()%>% select(-gr, -all) %>% distinct()



###calculate the number of social partners each female has had


MyDF7<- MyDF6 %>% group_by(Dam) %>% tally() %>% rename(F_total_Partner_number = n) %>% inner_join(MyDF6, by='Dam')

##calculate the total number of broods each female has had

Social_bondDF<- MyDF4 %>% count(Dam)%>% rename(F_total_Brood_number = n) %>% inner_join(MyDF7, by='Dam')


###Join the dataframe together
Full_percent<-left_join(MyDF4, Social_bondDF) 

#Calculate the percentage of clutches with EP the female has had.
Full_percent2 <- Full_percent %>% mutate(F_Percent_clutch_EP = Female_total_EPO_clutches/ F_total_Brood_number) %>% rename(ID = Dam)%>% mutate(Sex = "0")



### Other dataframes that I might use, which records binary EPO/ WPO for each offspring in each brood
Full_binary<-left_join(MyDF3, Social_bondDF, by = c("Dam", "SocialDadID"))

Full_binary2<-left_join(Full_binary, select(MyDF4, c(Dam, BroodName, F_EPP_brood)), by = c("Dam", "BroodName"))

#####male EPR measurements#####

#determine what time each brood occured

MyDf_date<- myDF %>% select(BroodRef, EventDate, EventNumber)%>% filter(EventNumber == "0")


DF<- MyDF2 %>% select(BroodName, BroodRef)

Full_percent3.25<-left_join(MyDf_date, DF) %>% filter(! duplicated(.))

Full_percent3.5<- left_join(MyDF2, Full_percent3.25) %>% select(-Notes, -EventNumber, -EP)

Full_percent3.7555<- Full_percent3.5 %>% mutate(EventDate = as.character(EventDate)) %>% mutate(EventDate = as.Date(EventDate, format = "%d/%m/%Y")) %>% mutate(
  EventDate = ymd(EventDate),
  Month_Yr = format_ISO8601(EventDate, precision = "ym")
)

Full_percent3.75<- Full_percent3.5 %>% mutate(EventDate = as.character(EventDate)) %>% mutate(EventDate = as.Date(EventDate, format = "%d/%m/%Y")) %>% mutate(
  EventDate = ymd(EventDate))

##Determine when extra pair males had broods with their social partner
Full_percent3.755<-Full_percent3.75 %>% filter(Sire == SocialDadID)%>% select(SocialDadID, BroodName, Cohort, EventDate)%>% filter(! duplicated(.))%>%rename(Sire = SocialDadID)%>% rename(Brood_date = EventDate)%>% 
  rename(BroodName2 = BroodName) 

Full_percent3.756<-Full_percent3.75 %>% filter(Sire != SocialDadID)

Full_percent3.756<-full_join(Full_percent3.756, Full_percent3.755)
#Calulate the number of Brood EPO for males


Full_percent3.9<- Full_percent3.756 %>% filter(Sire != SocialDadID) %>%rowwise() %>% mutate(start= Brood_date - 2, end = Brood_date + 30) %>% filter(EventDate >= start & EventDate <= end)


Full_percent3.9<- Full_percent3.9 %>% select(-Offspring, -start, - end, -Dam, -EventDate, -BroodName, -BroodRef, -SocialDadID) %>% group_by(Sire, BroodName2)%>% mutate(count = n())%>%
  ungroup() %>%filter(! duplicated(.)) %>% rename(SocialDadID= Sire)%>% rename(male_brood_EPO= count)%>% rename(EventDate = Brood_date)%>% rename(BroodName = BroodName2)
  

#Calulate the number of Brood WPO for males

Full_percent3.9.5<- Full_percent3.75 %>% filter(Sire == SocialDadID)%>% group_by(SocialDadID, BroodName)%>% select(-Offspring) %>% mutate(count = n()) %>% rename(male_brood_WPO= count) %>% ungroup() %>% filter(! duplicated(.))

Full_percent4.5 <-full_join(Full_percent3.9.5, Full_percent3.9) %>% group_by(.)%>%
  filter(! duplicated(.))%>% replace(is.na(.), 0) %>% select(-Sire)



#Calculate the number of Annual EPO for males

Full_percent4 <- MyDF2 %>% select(-Notes) %>% na.omit(SocialDadID)%>% filter(Sire != SocialDadID) %>%
select(Sire, Cohort) %>% group_by(Sire, Cohort)%>% count()%>% rename(Male_Year_EPO = n) %>% rename(SocialDadID = Sire) 

#Calulate the number of Annual WPO for males

Full_percent5<- MyDF2 %>% filter(Sire == SocialDadID) %>% select(SocialDadID, Cohort) %>% group_by(SocialDadID, Cohort)%>% count()%>% rename(Male_Year_WPO = n)


Full_percent5.5<- left_join(Full_percent5, Full_percent4) %>% replace(is.na(.), 0) 


#join Male Year and Brood EPO and WPO together
Full_percent6 <-left_join(Full_percent4.5, Full_percent5.5) 


Full_percent6.5 <- Full_percent6%>% select(SocialDadID, Cohort, male_brood_EPO, Male_Year_EPO) %>% group_by(SocialDadID, Cohort) %>%summarize(male_brood_EPO2 =sum(male_brood_EPO)) %>% inner_join(Full_percent6) %>% select(SocialDadID, Cohort, Male_Year_EPO, male_brood_EPO2)

Full_percent6.55<- Full_percent6.5 %>% filter(male_brood_EPO2 > Male_Year_EPO)

###Add bond duration

stuff<- Full_percent2 %>% select(SocialDadID, BroodName, ID, Cohort, Number_Broods_with_Partner) %>% rename(Dam = ID)

##Add a sex column and a column saying whether each male had extra pair offspring each year or not (both binary traits)

Full_percent7<- left_join(Full_percent6, stuff)%>% distinct() %>% rename(ID = SocialDadID)%>% mutate(M_EPP_Year = case_when(Male_Year_EPO == 0 ~ 0, Male_Year_EPO > 0 ~ 1)) %>%
  mutate(M_EPP_brood = case_when(male_brood_EPO == 0 ~ 0, male_brood_EPO > 0 ~ 1))%>% mutate(Sex = "1") 

###determine agee of the male for every brood


ageDF <-MyDF2 %>% select(Offspring, Cohort)%>%rename(ID = Offspring) %>% rename(birthyear = Cohort)

Full_percent2<- left_join(Full_percent2, ageDF) 

Full_percent2<- Full_percent2 %>% mutate(Age = Cohort - birthyear)%>% select(-birthyear)



Full_percent7<- left_join(Full_percent7, ageDF)

Full_percent7 <- Full_percent7 %>% mutate(Age = Cohort - birthyear)%>% select(-birthyear)


###combine male and female measurments #####
Full_percent8<-Full_percent2 %>% rename(Partner =SocialDadID)
Full_percent9<-Full_percent7 %>% rename(Partner = Dam)
Data4<- full_join(Full_percent8, Full_percent9)

###Looking at data


table(Full_binary2$EP)
table(Full_binary2$EPP_brood)

table(Data2$EP)
hist(Full_percent$Female_total_EPO_clutches)

hist(Full_percent2$FPercentEP)

hist(Full_percent2$F_Percent_clutch_EP)

table(Full_percent2$F_EPP_brood)
table(Full_percent7$M_EPP_brood)

n_distinct(Full_percent7$ID)
n_distinct(Full_percent2$ID)
n_distinct(MyDF2$Offspring)

hist(Full_percent7$Male_Year_EPO)

table(Full_percent7$Male_Year_EPO)

table(Full_percent7$male_brood_EPO)
hist(Full_percent7$male_brood_EPO)

hist(Full_percent7$Male_Year_EPO)

hist(Full_percent7$Male_Year_WPO)

hist(Full_percent7$male_brood_WPO)

hist(Full_percent7$male_brood_EPO)
hist(Data2$Number_Broods_with_Partner)


Check<-Data2%>% select(ID, Dam, SocialDadID, Cohort, BroodName, Number_Broods_with_Partner, F_total_Brood_number) 
Check3<-Check %>% filter(ID == 646)

Check2<-Data2%>% select(ID, Dam, SocialDadID, Cohort, BroodName, Number_Broods_with_Partner, F_total_Brood_number) 
Check4<-Check2 %>% filter(ID == 646)

CheckA<- left_join(Check, Check2, by = c("BroodName","F_total_Brood_number"))
C<-CheckA %>% group_by(ID.x, ID.y) %>% filter(Number_Broods_with_Partner.x != Number_Broods_with_Partner.y)

table(Check$F_total_Brood_number)
table(Check2$F_total_Brood_number)
table(Check$Number_Broods_with_Partner)
table(Check2$Number_Broods_with_Partner)

####save dataframes as .csv files####

write.csv(Full_percent2,"../data/FemaleInterPleiotropy.csv", row.names = FALSE)
write.csv(Full_percent7,"../data/MaleInterPleiotropy.csv", row.names = FALSE)
write.csv(Pedigree,"../data/Pedigree.csv", row.names = FALSE)
write.csv(DF4,"../data/InterPleiotropy4.csv", row.names = FALSE)









