gctorture (FALSE)
rm(list = ls(all.names = TRUE))
setwd('~/OneDrive/r-files/od_sp/Banco de Dados da Pesquisa de Mobilidade Urbana 2012/Banco de Dados/')
#https://www.gps-latitude-longitude.com/gps-coordinates-of-porto-alegre
library(foreign)
library(proj4)
library(leaflet.extras)


proj4string <- "+proj=utm +zone=23 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs "
# Source data
dados = read.dbf('Mobilidade_2012_v0.dbf')
head(dados)
xy = dados[, 3:4]
head(xy)
#xy <- data.frame(x=333132, y=7394597)

# Transformed data
pj <- project(xy, proj4string, inverse=TRUE)
latlon <- data.frame(lat=pj$y, lon=pj$x)                       
head(latlon)
map <- leaflet(data = xy) %>%
  addTiles() %>%
  addCircles(~latlon$lon, ~latlon$lat, popup=~paste("<br>Lat", latlon$lat, "<p>Long", latlon$lon,  sep = " "),
             weight = 1, radius=50, color= 'red', stroke = TRUE, fillOpacity = 0.5)
map




xy = dados[, 58:59]
head(xy)
#xy <- data.frame(x=333132, y=7394597)

# Transformed data
pj <- project(xy, proj4string, inverse=TRUE)
latlon2 <- data.frame(lat=pj$y, lon=pj$x)                       
head(latlon)
map <- leaflet(data = xy) %>%
  addTiles() %>%
  addCircles(group="Origens", ~latlon$lon, ~latlon$lat, popup=~paste("<br>Lat", latlon$lat, "<p>Long", latlon$lon,  sep = " "),
             weight = 1, radius=50, color= 'red', stroke = TRUE, fillOpacity = 0.5)  %>%
  addCircles(group="Destinos", ~latlon2$lon, ~latlon2$lat, popup=~paste("<br>Lat", latlon2$lat, "<p>Long", latlon2$lon,  sep = " "),
           weight = 1, radius=50, color= 'blue', stroke = TRUE, fillOpacity = 0.5)  %>% 
  addLayersControl(overlayGroups = c("Origens", "Destinos"),
                   options = layersControlOptions(collapsed = FALSE))
map
