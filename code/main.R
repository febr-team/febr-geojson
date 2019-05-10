library(magrittr)
library(dplyr)

# Teste com estrutura JSON simplificada #######################################################################

# O pacote sf não é capaz de ler os dados pois não possuem todos os campos padrão GeoJSON
sf::read_sf("data/valladares.json", driver = "geojson")

# Os dados precisam ser lidos como JSON.
soil_profile <- 
  jsonlite::read_json("data/valladares.json") %>% 
  unlist(recursive = FALSE) %>% 
  lapply(function (x) unlist(x, recursive = FALSE)) %>%
  lapply(function (x) unlist(x, recursive = FALSE)) %>% 
  lapply(function (x) unlist(x, recursive = FALSE)) %>% 
  do.call(rbind, .)
soil_profile %>% str(2)

# Teste de exportação dos mesmos dados para GeoJSON ###########################################################
soil_profile <- 
  read.table("data/valladares.csv", header = T, dec = ",") %>% 
  sf::st_as_sf(coords = c("coordinates1", "coordinates2"))
sf::write_sf(
  soil_profile, "data/geo-valladares.json", driver = "geojson", 
  layer_options = c("ID_FIELD='ID_PONTO'"))
jsonlite::read_json("data/geo-valladares.json") %>% 
  jsonlite::write_json("data/geo-valladares.json", pretty = TRUE)

# Usano o pacote AQP ##########################################################################################
library(aqp)
soil_profile <- read.table("data/valladares.csv", header = T, dec = ",")
depths(soil_profile) <- ID_PONTO ~ coordinates1 + coordinates2
site(soil_profile) <- cbind(site(soil_profile), class = c("organossolo", "latossolo"))
soil_profile <- as(soil_profile, 'list')
soil_profile <- soil_profile[1:6]
jsonlite::write_json(soil_profile, "data/aqp-valladares.json", pretty = TRUE)





# soil_profile <- 
#   data.frame(
#     id = c("perfil 1"),
#     coord_x = c(25),
#     coord_y = c(15),
#     carbono = c('{"A":15, "E":1, "B":19}'),
#     profund_sup = c('{"A":0, "E":15, "B":30}'),
#     profund_inf = c('{"A":15, "E":30, "B":60}')
#   )
# soil_profile <- sf::st_as_sf(soil_profile, coords = c("coord_x", "coord_y"))
# soil_profile
# 
# sf::write_sf(
#   soil_profile, 
#   "tmp.json",
#   driver = "geojson", 
#   layer_options = c("ID_FIELD='id'", "DESCRIPTION=Repositório Brasileiro Livre para Dados Abertos do Solo"),
#   delete_dsn = TRUE)
# 
# jsonlite::read_json("tmp.json") %>% 
#   jsonlite::write_json("tmp.json", pretty = T)
# 
