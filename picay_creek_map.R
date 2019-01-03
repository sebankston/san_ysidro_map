library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title %>% str_subset("Picay")

pcy_all <- gs_title("Picay Inventory")

gs_ws_ls(pcy_all)

pcy_data <- gs_read(ss = pcy_all, ws = "Sheet1") %>% clean_names()

pcy_nr <- pcy_data %>% filter(barrier_type == "NR") 
pcy_r <- pcy_data %>% filter(barrier_type == "R") 
pcy_r2 <- pcy_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = pcy_r2, label = pcy_r2$barrier_id, popup = ~paste0(pcy_r2$barrier_id, "<br/>", pcy_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>%
  
  # addCircleMarkers(data = pcy_nr, label = pcy_nr$barrier_id, popup = ~paste0(pcy_nr$barrier_id, "<br/>", rnc_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  
  addCircleMarkers(data = pcy_r, label = pcy_r$barrier_id, popup = ~paste0(pcy_r$barrier_id, "<br/>", pcy_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
