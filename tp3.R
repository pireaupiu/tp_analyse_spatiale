##### TP 3 #####

## Chargement des packages ##

# install.packages("mapsf")

library(dplyr)
library(sf)
library(mapsf)
library(classInt)
library(leaflet)
library(readxl)

### Exercice 1 ###

# Chargement des donnees 
# Fond communes France metropolitaine
communes_fm <- st_read("fonds/commune_francemetro_2021.shp", options = "ENCODING=WINDOWS-1252") %>% 
  select(code,libelle,surf)
# Import des population légales des communes en 2019
pop_com_2019<-read_excel("donnees/Pop_legales_2019.xlsx")

## Question 1 ##

# Correction pour la ville de Paris
pop_com_2019<-pop_com_2019 %>% 
  mutate(COM=if_else(substr(COM,1,3)=="751","75056",COM)) %>% 
  group_by(code=COM) %>% 
  summarise(pop=sum(PMUN19))
# Jointure
communes_fm<-communes_fm %>% 
  left_join(pop_com_2019,
            by="code") %>% 
  mutate(densite=pop/surf)


## Question 2 ## 
summary(communes_fm$densite)
hist(communes_fm$densite)

## Question 3 ## 
plot(communes_fm['densite'], border = FALSE) 

## Question 4 ##
plot(communes_fm["densite"], breaks = "quantile", border = FALSE)

plot(communes_fm["densite"], breaks = "jenks", border = FALSE )

plot(communes_fm["densite"], breaks = "sd", border = FALSE)

plot(communes_fm["densite"], breaks = "pretty", border = FALSE)


