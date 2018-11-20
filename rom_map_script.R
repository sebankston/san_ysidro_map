library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

rom_all <- gs_title("Romero_Creek_inventory")

gs_ws_ls(rom_all)

rom_data <- gs_read(ss = rom_all, ws = "Sheet1") %>% clean_names()

rom_nr <- rom_data %>% filter(barrier_type_road_non_road == "NR") 
rom_r <- rom_data %>% filter(barrier_type_road_non_road == "R") 
rom_r2 <- rom_data %>% filter(barrier_type_road_non_road == "R" & x2nd_pass == "Y" | x2nd_pass == "M") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = rom_r2, label = rom_r2$barrier_id, popup = ~paste0(rom_r2$barrier_id, "<br/>", rom_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>% 
  addCircleMarkers(data = rom_nr, label = rom_nr$barrier_id, popup = ~paste0(rom_nr$barrier_id, "<br/>", rom_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  addCircleMarkers(data = rom_r, label = rom_r$barrier_id, popup = ~paste0(rom_r$barrier_id, "<br/>", rom_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
