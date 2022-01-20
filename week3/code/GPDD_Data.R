#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: demonstrates how to create a world map and superimpose the location data form the GPDD dataframe onto the map using the maps and mapdata packages.

rm(list = ls())

#load in required packages

require(maps)
require(ggplot2)
require(mapdata)

#load in the data
load("../data/GPDDFiltered.RData")

worldmap<-map_data("world") #gives a dataframe of points outlining the world


connect_world<-ggplot()+  #connect all the dots to make polgons (the shapes outlining the countries)
  geom_polygon(data = worldmap,
               aes(x= long, y =lat, group = group),
               fill = NA, colour = "black") + coord_fixed(1.3)

connect_world

dotted_world <- connect_world + geom_point(data = gpdd, aes(x = long, y = lat), colour = "red") #add GPDD datapoints to map

dotted_world



##the data provided may be biased because most of the data was collected in north America and Europe#####



print("Script complete!")
