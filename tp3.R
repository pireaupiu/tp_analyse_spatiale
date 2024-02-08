##### TP 3 #####

## Chargement des packages ##

# install.packages("mapsf")

library(dplyr)
library(sf)
library(mapsf)
library(classInt)
library(leaflet)
library(readxl)

## Exercice 1 ##

#Chargement des données : 
communes <- st_read("fonds/commune_francemetro_2021.shp", options = "ENCODING=WINDOWS-1252")
population_19 <- read_excel("donnees/Pop_legales_2019.xlsx")
