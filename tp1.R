# TP1 # 

## Exercice 1 :

### Question 1 :

library(sf)

communes <- st_read("fonds/commune_francemetro_2021.shp", options = "ENCODING=WINDOWS-1252")

summary(communes)

View(communes[0:10,])

# Système de projection :
st_crs(communes)

library(dplyr)

communes_Bretagne <- communes %>% 
  filter(reg == 53) %>% 
  select(c("code", "libelle", "epc", "dep", "surf"))

plot(st_geometry(communes_Bretagne))

communes_Bretagne <- communes_Bretagne %>%
  mutate("surf2" = st_area(geometry))

# Conversion de surf2 en km2 
communes_Bretagne <- communes_Bretagne %>% 
  mutate("surf2" =units::set_units(surf2, "km^2"))

# Création d'une table départementale : 
dept_bretagne <- communes_Bretagne %>% 
  group_by(dep) %>% 
  summarise(superficie = sum(surf)) %>% 
  select(c("dep", "superficie")) %>% 
  distinct()

plot(st_geometry(dept_bretagne))


