library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title %>% str_subset(pattern = "ory$")

gob_all <- gs_title("GOB_Gobernador creek Inventory")

gs_ws_ls(gob_all)

gob_data <- gs_read(ss = gob_all, ws = "Sheet1") %>% clean_names()

gob_r2 <- gob_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = gob_r2, label = gob_r2$barrier_id, popup = ~paste0(gob_r2$barrier_id, "<br/>", gob_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>% 
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Detailed Required"))
