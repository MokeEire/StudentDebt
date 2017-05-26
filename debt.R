library(tidyverse)
library(readxl)
library(maps)
library(ggmap)
library(ggthemes)

# Data
# Institute for College Access & Success: http://ticas.org/posd/state-state-data-2015
debt <- read_xlsx("C:/Users/Mark/Downloads/studentdebtclean.xlsx")
debt <- debt[1:51,]

# Remove Asterisks

for(i in 2:7){
  debt[9,i] <- gsub("\\*", "", debt[9,i])
  debt[32,i] <- gsub("\\*", "", debt[9,i])
  debt[35,i] <- gsub("\\*", "", debt[9,i])
  
}

# Change to numeric
debt$tenyrpercchange <- as.numeric(debt$tenyrpercchange)
debt$avgdebt2014<- as.numeric(debt$avgdebt2014)
debt$avgdebt2004<- as.numeric(debt$avgdebt2004)
debt$percdebt2014<- as.numeric(debt$percdebt2014)
debt$percdebt2004<- as.numeric(debt$percdebt2004)

# Get lat and lon

for(i in 1:51){
  latlon = geocode(debt$State[i])
  debt$lon[i] <- as.numeric(latlon[1])
  debt$lat[i] <- as.numeric(latlon[2])
}


## Make a map
# Align the dataframes first
colnames(debt)[1] <- "region" 
debt$region <- tolower(debt$region) 

# Get longitude/latitude data
states <- map_data("state") 

# merge together
total <- merge(states, debt, by = "region")

# Plot: what are the geoms?? (good question)
# Polygon = map
# text = labels for each state
# theme_538 = makes it look pretty/I'm a 538 fanboy
# scale_fill_gradient = colour scale
# theme = make various aesthetic adjustments
# all the annotations, why?  Because without them, the labels
#   are all bunched up in the small states.  Needed to make lines and labels
# FYI: I made a (somewhat) arbitrary cutoff for longitude around Washington DC
#   because the states seem to get smaller east of DC
ggplot()+geom_polygon( data=total, aes(x=long, y=lat.x, group = group, fill = avgdebt2014),colour="white" )+
  geom_text(aes(x = debt$lon, y = debt$lat, label = ifelse(!is.na(debt$tenyrpercchange) & debt$lon < -77, paste("+",debt$tenyrpercchange*100, "%", sep = ""), NA), hjust = ifelse(debt$region =="arkansas"|debt$region=="louisiana"|debt$region=="pennsylvania"|debt$region=="wisconsin"|debt$region=="missouri"|debt$region=="georgia"|debt$region=="west virginia", .8, ifelse(debt$region =="michigan"|debt$region=="washington"|debt$region=="montana"|debt$region=="south carolina", 0,0.5)), vjust = ifelse(debt$region =="mississippi"|debt$region=="tennessee"|debt$region=="south dakota"|debt$region=="alabama"|debt$region=="wisconsin"|debt$region=="missouri"|debt$region=="georgia"|debt$region=="oklahoma", -.3, ifelse(debt$region =="colorado"|debt$region=="pennsylvania"|debt$region=="michigan"|debt$region=="kansas", 1.3,0.5))), size = 4.5, fontface = "bold")+
  theme_fivethirtyeight()+labs(caption = "Source: Institute for College Access & Success")+
  scale_fill_distiller(type = "seq", direction = 1, palette = "YlOrRd", guide_colorbar("Average student loan debt in 2014", subtitle = "Labels indicate $ amount increase in debt from 2004-2014"))+
  theme(axis.ticks = element_blank(),  axis.text = element_blank(), legend.title = element_text(size = 18, margin = margin(t = 0, b = 50)), legend.key.width = unit(2, "cm"),legend.key.height = unit(.5,"cm"))+
  ggtitle("US College Debt in 2014", subtitle = "Average $ amount of debt and the % change from 2004-2014")+
  annotate("text", x = -68, y = 40.25, label = paste("+", debt[debt$region == "connecticut", 2]*100, "%", sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "connecticut", 10], y = debt[debt$region == "connecticut", 11], xend = -68.8, yend = 40.25))+
  annotate("text", x = -69.75, y = 37.25, label = paste("+", debt[debt$region == "delaware", 2]*100, "%", sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "delaware", 10], y = debt[debt$region == "delaware", 11], xend = -70.9, yend = 37.25))+
  annotate("text", x = -73, y = 36, label = paste("+", debt[debt$region == "maryland", 2]*100, "%", sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "maryland", 10], y = debt[debt$region == "maryland", 11], xend = -74, yend = 36.1))+
  annotate("text", x = -68, y = 42.25, label = paste("+", debt[debt$region == "massachusetts", 2]*100, "%", sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "massachusetts", 10], y = debt[debt$region == "massachusetts", 11], xend = -69, yend = 42.25))+
  annotate("text", x = -68, y = 43.25, label = paste("+", debt[debt$region == "new hampshire", 2]*100, "%", sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "new hampshire", 10], y = debt[debt$region == "new hampshire", 11], xend = -69, yend = 43.25))+
  annotate("text", x = -70, y = 38.25, label = paste("+", debt[debt$region == "new jersey", 2]*100, "%", sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "new jersey", 10], y = debt[debt$region == "new jersey", 11], xend = -70.8, yend = 38.25))+
  annotate("text", x = -75, y = 43, label = paste("+",debt[debt$region == "new york", 2]*100, "%", sep = ""), size = 4, fontface = "bold")+
  annotate("text", x = -68, y = 41.25, label = paste("+", debt[debt$region == "rhode island", 2]*100, "%", sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "rhode island", 10], y = debt[debt$region == "rhode island", 11], xend = -68.9, yend = 41.25))+
  annotate("text", x = -72, y = 47, label = paste("+", debt[debt$region == "vermont", 2]*100, "%", sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "vermont", 10], y = debt[debt$region == "vermont", 11], xend = -72, yend = 46.5))+
  annotate("text", x = -69, y = 45.5, label = paste("+", debt[debt$region == "maine", 2]*100, "%", sep = ""), size = 4, fontface = "bold")
  

## Handy notes as I'm coding

# States to push right: Michigan, Washington, Montana
# States to push left: Louisiana, Pennsylvania, West Virginia, Wisconsin, Arkansas

# States to push up: South dakota, wisconsin, tennesee, mississippi, alabama, georgia, missouri






# Same graph with $ amount change from 2004-2014

ggplot()+geom_polygon( data=total, aes(x=long, y=lat.x, group = group, fill = avgdebt2014),colour="white" )+
  geom_text(aes(x = debt$lon, y = debt$lat, label = ifelse(!is.na(debt$avgdebt2014) & debt$lon < -77, paste("$",debt$avgdebt2014-debt$avgdebt2004, sep = ""), NA), hjust = ifelse(debt$region =="arkansas"|debt$region=="louisiana"|debt$region=="pennsylvania"|debt$region=="wisconsin"|debt$region=="missouri"|debt$region=="georgia"|debt$region=="west virginia", .9, ifelse(debt$region =="michigan"|debt$region=="washington"|debt$region=="montana"|debt$region=="south carolina", 0,0.5)), vjust = ifelse(debt$region =="mississippi"|debt$region=="tennessee"|debt$region=="south dakota"|debt$region=="alabama"|debt$region=="wisconsin"|debt$region=="missouri"|debt$region=="georgia"|debt$region=="oklahoma", -.3, ifelse(debt$region =="colorado"|debt$region=="pennsylvania"|debt$region=="michigan"|debt$region=="kansas", 1.3,0.5))), size = 4.5, fontface = "bold")+
  theme_fivethirtyeight()+labs(caption = "Labels indicate $ amount increase in debt from 2004-2014\nSource: Institute for College Access & Success")+
  scale_fill_distiller(type = "seq", direction = 1, palette = "YlOrRd", guide_colorbar("Average Student Loan Debt in 2014"))+
  theme(axis.ticks = element_blank(), plot.caption = element_text(hjust = 0),  axis.text = element_blank(), legend.title = element_text(size = 18, margin = margin(t = 0, b = 50)), legend.key.width = unit(2, "cm"),legend.key.height = unit(.5,"cm"))+
  ggtitle("US College Debt in 2014", subtitle = "Average $ amount of debt and the $ change from 2004-2014")+
  annotate("text", x = -68, y = 40.25, label = paste("+", "$",debt[debt$region == "connecticut", 4]-debt[debt$region == "connecticut", 5], sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "connecticut", 10], y = debt[debt$region == "connecticut", 11], xend = -68.8, yend = 40.25))+
  annotate("text", x = -69.75, y = 37.25, label = paste( "$",debt[debt$region == "delaware", 4]-debt[debt$region == "delaware", 5], sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "delaware", 10], y = debt[debt$region == "delaware", 11], xend = -70.9, yend = 37.25))+
  annotate("text", x = -73, y = 36, label = paste( "$",debt[debt$region == "maryland", 4]-debt[debt$region == "maryland", 5], sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "maryland", 10], y = debt[debt$region == "maryland", 11], xend = -74, yend = 36.1))+
  annotate("text", x = -68, y = 42.25, label = paste( "$",debt[debt$region == "massachusetts", 4]-debt[debt$region == "massachusetts", 5], sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "massachusetts", 10], y = debt[debt$region == "massachusetts", 11], xend = -69, yend = 42.25))+
  annotate("text", x = -68, y = 43.25, label = paste( "$",debt[debt$region == "new hampshire", 4]-debt[debt$region == "new hampshire", 5], sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "new hampshire", 10], y = debt[debt$region == "new hampshire", 11], xend = -69, yend = 43.25))+
  annotate("text", x = -70, y = 38.25, label = paste( "$",debt[debt$region == "new jersey", 4]-debt[debt$region == "new jersey", 5], sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "new jersey", 10], y = debt[debt$region == "new jersey", 11], xend = -70.8, yend = 38.25))+
  annotate("text", x = -75, y = 43, label = paste("$",debt[debt$region == "new york", 4]-debt[debt$region == "new york", 5], sep = ""), size = 4, fontface = "bold")+
  annotate("text", x = -68, y = 41.25, label = paste( "$",debt[debt$region == "rhode island", 4]-debt[debt$region == "rhode island", 5], sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "rhode island", 10], y = debt[debt$region == "rhode island", 11], xend = -68.9, yend = 41.25))+
  annotate("text", x = -72, y = 47, label = paste( "$",debt[debt$region == "vermont", 4]-debt[debt$region == "vermont", 5], sep = ""), size = 4, fontface = "bold")+
  geom_segment(aes(x = debt[debt$region == "vermont", 10], y = debt[debt$region == "vermont", 11], xend = -72, yend = 46.5))+
  annotate("text", x = -69, y = 45.5, label = paste( "$",debt[debt$region == "maine", 4]-debt[debt$region == "maine", 5], sep = ""), size = 4, fontface = "bold")


### Future plans

# 1. Use recent graduate income data to give the debt as a percentage of income
#     Currently can't find this data in a usable format
#
# 2. Create an image as a label that translates value of debt simply
#     Cars? Rents? Something else?

