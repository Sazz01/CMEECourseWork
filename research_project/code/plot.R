rm(list = ls())
#AUTHOR: Sarah Dobson
#DATE: 24th January 2022
#DESCRIPTION: making plots of model results that are used in Thesis

####required packages###
require("tidyverse")


#####observed scale heritability estimates#####
herit<-data.frame(
  "sex" = c("male", "female", "male", "female", "male", "female"),
  "group" = c("Hd", "Hd", "Ht", "Ht","Ht + cov", "Ht + cov"),
  "p_mean" = c(0.004, 0.012, 0.028,0.022, 0.017, 0.019 ),
  "upper_ci" = c(0.016, 0.042, 0.056, 0.056, 0.040, 0.052),
  "lower_ci" = c(0,0,0,0,0, 0)
)



herit<-data.frame(
  "sex" = c("male", "female", "male", "female", "male", "female"),
  "group" = c("No IGEs", "No IGEs", "IGEs", "IGEs","IGEs + cov", "IGEs + cov"),
  "p_mean" = c(0.004, 0.012, 0.028,0.022, 0.017, 0.019 ),
  "upper_ci" = c(0.016, 0.042, 0.056, 0.056, 0.040, 0.052),
  "lower_ci" = c(0,0,0,0,0, 0)
)



herit$group <- factor(herit$group, levels = c("No IGEs", "IGEs","IGEs + cov" ))
p<-ggplot(herit) +
  aes(x= group, y = p_mean, ymin = lower_ci, ymax = upper_ci, group = sex , colour = sex)+ geom_point(position = position_dodge(width = .5), size = 3)+ 
  geom_linerange(position = position_dodge(width = .5), size = 1) +
  geom_hline(aes(yintercept = 0))  + 
  labs(colour="Sex", shape="Sex", x = " ", y = "EPR Heritability") +    
  theme(axis.title = element_text(face="bold", size="12"),
        axis.text = element_text(size=12, face="bold"))+theme_bw()+
  theme(panel.border = element_blank(), panel.grid.minor = element_blank(), axis.ticks.x = element_blank(),panel.grid.major = element_blank(), axis.line.y = element_line(color="black"))+
  scale_y_continuous(expand = c(0, 0), limits = c(0, 0.06)) +
  facet_wrap( ~ sex, strip.position = "bottom")+ 
  theme(strip.placement = "outside", panel.spacing= grid::unit(-0.30, "lines"), strip.background = element_blank(), strip.text = element_text(size = 14, face = "bold" ))+ 
  theme(axis.title = element_text(face="bold", size="14"),
        axis.text = element_text(size=10))+ guides(fill=guide_legend(title=""))+
  theme(legend.key.size = unit(1, 'cm'))+
  theme(legend.position = "none")
p

ggsave(filename = "Uni_herit_plot.tif" , height = 7, width = 5.5, plot= p, path = "../results/", device='tiff', dpi=300)



#####observed scale genetic correlation estimates#####

corr<-data.frame(
  "group" = c("No IGEs", "IGEs"),
  "p_mean" = c(0.09, -0.066),
  "upper_ci" = c(0.94, 0.55),
  "lower_ci" = c(-0.84, -0.67)
)

corr$group <- factor(corr$group, levels = c("No IGEs", "IGEs"))


p<-ggplot(corr) +
  aes(x= group, y = p_mean, ymin = lower_ci, ymax = upper_ci, colour= "red")+ geom_point(size = 3)+ 
  geom_linerange(size = 1) +
  geom_hline(aes(yintercept = 0))  + 
  labs(x = " ", y = "Genetic Correlation") +    
  theme(axis.title = element_text(face="bold", size="12"),
        axis.text = element_text(size=12, face="bold")) +theme_bw()+
  theme(panel.border = element_blank(), panel.grid.minor = element_blank(), axis.ticks.x = element_blank(),panel.grid.major = element_blank(), axis.line.y = element_line(color="black"))+
  scale_y_continuous(expand= c(0,0), limits = c(-1, 1)) + 
  theme(axis.title = element_text(face="bold", size="14"),
        axis.text = element_text(size=10, face = "bold"), legend.position = "none")+ theme(aspect.ratio = 2/1) + scale_color_manual(values= "purple")

p

ggsave(filename = "corr_plot.tif" , height = 7, width = 5.5, plot= p, path = "../results/", device='tiff', dpi=300)



###proportion of variance plots - latent scale########

dt <- data.frame(
  "sex" = c("female", "female", "female", "male","male", "male",  "female", "female","female","male", "male", "male"),
  "model" = c("no IGE", "no IGE", "no IGE",  "no IGE", "no IGE", "no IGE", "IGE", "IGE", "IGE", "IGE", "IGE", "IGE"),
  "r" = c("Va", "Vse", "Vpe", "Va", "Vse", "Vpe", "Va", "Vse", "Vpe", "Va", "Vse", "Vpe"),
  "values" = c(1.999, 0, 14.06, 2.11, 0, 24.85, 3.5, 3.77, 11.8, 14.03, 8.12, 10.543))

dt$model <- factor(dt$model, levels = c("no IGE", "IGE"))
dt$r <- factor(dt$r, levels = c("Vpe", "Va", "Vse"))

ggplot(dt[order(dt$r, decreasing = T),], aes(fill=factor(r, levels=c("Vse","Va", "Vpe" )), y=values, x=model)) + 
  geom_bar(position="stack", stat="identity")+
  facet_wrap( ~ sex, strip.position = "bottom")+ theme(strip.placement = "outside")+ theme(panel.spacing= grid::unit(-1.25, "lines"))+ 
  labs(x = " ", y = "Posterior Mean Estimate") +    
  theme(axis.title = element_text(face="bold", size="12"),
        axis.text = element_text(size=12, face="bold")) 


p<-ggplot(dt[order(dt$r, decreasing = T),], aes(fill=factor(r, levels=c("Vse","Va", "Vpe" )), y=values, x=model)) + 
  geom_bar(position="stack", stat="identity")+ theme_bw()+theme(panel.border = element_blank(), panel.grid.minor = element_blank(), axis.ticks.x = element_blank(),panel.grid.major = element_blank(), axis.line.y = element_line(color="black"))+ 
  scale_y_continuous(expand = c(0, 0), limits = c(0, 40))+
  facet_wrap( ~ sex, strip.position = "bottom")+ 
  theme(strip.placement = "outside", panel.spacing= grid::unit(-0.30, "lines"), strip.background = element_blank(), strip.text = element_text(size = 14, face = "bold" ))+ 
  labs(x = " ", y = "Proportion of variance explained") +    
  theme(axis.title = element_text(face="bold", size="14"),
        axis.text = element_text(size=10, face="bold"))+ guides(fill=guide_legend(title=""))+
  theme(legend.key.size = unit(1., 'cm'))+
  theme(legend.text = element_text(size=10, face = "bold"), legend.background = element_rect(linetype = 1, size = 0.5, colour = 1), legend.position = c(.1,.85))

p

ggsave(filename = "variance_lat.tif" , height = 7, width = 5.5, plot= p, path = "../results/", device='tiff', dpi=300)
