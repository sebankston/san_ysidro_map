library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title %>% str_subset("Oak")

oak_all <- gs_title("Oak Creek Inventory")

gs_ws_ls(oak_all)

oak_data <- gs_read(ss = oak_all, ws = "Sheet1") %>% clean_names()

oak_nr <- oak_data %>% filter(barrier_type == "NR") 
oak_r <- oak_data %>% filter(barrier_type == "R") 
oak_r2 <- oak_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = oak_r2, label = oak_r2$barrier_id, popup = ~paste0(oak_r2$barrier_id, "<br/>", oak_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>%
  
  # addCircleMarkers(data = oak_nr, label = oak_nr$barrier_id, popup = ~paste0(oak_nr$barrier_id, "<br/>", rnc_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  
  addCircleMarkers(data = oak_r, label = oak_r$barrier_id, popup = ~paste0(oak_r$barrier_id, "<br/>", oak_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
