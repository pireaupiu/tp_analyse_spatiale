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

# Dans population_19, Paris est renseigné par arrondissement. 
# Mais il existe qu'une seule ligne dans le fond communal.
# Il faut donc homogénéiser la commune de Paris en une seule ligne. 

# On crée une table avec uniquement Paris pour avoir sa population totale : 
paris <- population_19 %>% 
  filter(COM %in% c(as.character(75101:75120))) %>% 
  summarise('COM' = '75056', 
            'NCC' = 'Paris',
            'PMUN19' = sum(PMUN19))

# On supprime tous les arrondissements de Paris dans poipulation_19 : 
population_19_sans_paris <- population_19 %>% 
  filter(!(COM %in% c(as.character(75101:75120))))

# On joint les deux tables précedemment créer et on ordonne par ordre croissant de code commune : 
pop_19_homogene <- rbind(population_19_sans_paris, paris)
pop_19_homogene <- pop_19_homogene %>% 
  arrange(COM)

# Jointure du fond de communes et de la table de population : 
communes_pop <- pop_19_homogene %>%
  rename("code" ="COM") %>% 
  select(code, PMUN19) %>% 
  left_join(communes, by = "code")


  
