library(magrittr)
library(dplyr)

# Teste com estrutura JSON simplificada #######################################################################

# O pacote sf não é capaz de ler os dados pois não possuem todos os campos padrão GeoJSON
sf::read_sf("data/valladares.json", driver = "geojson")

# Os dados precisam ser lidos como JSON.
soil_profile <- 
  jsonlite::read_json("data/valladares.json") %>% 
  # unname() %>%
  unlist(recursive = FALSE) %>% 
  lapply(function (x) unlist(x, recursive = FALSE)) %>%
  lapply(function (x) unlist(x, recursive = FALSE)) %>% 
  lapply(function (x) unlist(x, recursive = FALSE) %>% data.frame)
soil_profile %>% str(2)
  
  

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
