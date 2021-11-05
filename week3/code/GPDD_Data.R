#AUTHOR: Sarah Dobson
#DATE: 5th November 2021
#DESCRIPTION: demonstrates how to create a world map and superimpose on the map all the locations from which we have data in the GPDD dataframe using the maps poackage.

rm(list = ls())


require(maps)
require(ggplot2)
require(mapdata)





load("../data/GPDDFiltered.RData")


worldmap<-map_data("world") #gives a dataframe of points outlining the world


connect_world<-ggplot()+  #connect all the dots to make polgons (the shapes outlining the countries)
  geom_polygon(data = worldmap,
               aes(x= long, y =lat, group = group),
               fill = NA, colour = "black") + coord_fixed(1.3)

connect_world

dotted_world <- connect_world + geom_point(data = gpdd, aes(x = long, y = lat), colour = "red")

dotted_world



##the data provided may be biased because most of the data was collected in north America and Europe#####



print("Script complete!")
