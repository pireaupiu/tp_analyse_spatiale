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

dept_bretagne2 <- communes_Bretagne %>% 
  group_by(dep) %>% 
  summarise(geometry = st_union(geometry))
 
plot(dept_bretagne2)

centroid_dept_bretagne <- st_centroid(dept_bretagne2)

plot(st_geometry(dept_bretagne))
plot(centroid_dept_bretagne, add = TRUE)

centroid_dept_bretagne <- centroid_dept_bretagne %>% 
  mutate("dept_lib" = case_when(dep == 22 ~ "Côtes-d'Armor",
                                dep == 29 ~ "Finistère", 
                                dep == 35 ~ "Ille-et-Vilaine", 
                                dep == 56 ~ "Morbihan"))

centroid_coords <- as.data.frame(st_coordinates(centroid_dept_bretagne))

centroid_coords <- st_drop_geometry(bind_cols(centroid_dept_bretagne, centroid_coords))

plot(st_geometry(dept_bretagne))
plot(centroid_dept_bretagne, add = TRUE)
text(centroid_coords$X, centroid_coords$Y, centroid_coords$dept_lib, pos = 3, cex = 0.7, col = "blue")


st_intersects(centroid_dept_bretagne, communes_Bretagne)

communes_Bretagne$libelle[c(148, 476, 647, 1092)]

intersection <- st_intersection(centroid_dept_bretagne, communes_Bretagne)

intersection2 <- st_within(centroid_dept_bretagne, communes_Bretagne)

chef_lieu <- communes_Bretagne %>% 
  filter(libelle %in% c("Saint-Brieuc", "Quimper", "Rennes", "Vannes"))
  
## Distance en mètre :
distance_22 <- st_distance(centroid_dept_bretagne[1,], chef_lieu[1,])
distance_29 <- st_distance(centroid_dept_bretagne[2,], chef_lieu[2,])
distance_35 <- st_distance(centroid_dept_bretagne[3,], chef_lieu[3,])
distance_56 <- st_distance(centroid_dept_bretagne[4,], chef_lieu[4,])

zone_20km <- st_buffer(centroid_dept_bretagne, 20000)

plot(st_geometry(communes_Bretagne))
plot(zone_20km, add = TRUE)

intersect_20km <- st_intersection(zone_20km, communes_Bretagne)

nb_a_20km <- intersect_20km %>% 
  group_by(dep) %>% 
  summarise("nb de communes" = n())

communes_Bretagne2 <- st_transform(communes_Bretagne, 4326)
plot(st_geometry(communes_Bretagne2))
plot(st_geometry(communes_Bretagne)