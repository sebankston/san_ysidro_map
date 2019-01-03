library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title %>% str_subset("Thacher")

thc_all <- gs_title("Thacher Creek Inventory")

gs_ws_ls(thc_all)

thc_data <- gs_read(ss = thc_all, ws = "Sheet1") %>% clean_names()

thc_nr <- thc_data %>% filter(barrier_type == "NR") 
thc_r <- thc_data %>% filter(barrier_type == "R") 
thc_r2 <- thc_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = thc_r2, label = thc_r2$barrier_id, popup = ~paste0(thc_r2$barrier_id, "<br/>", thc_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>%
  
  # addCircleMarkers(data = thc_nr, label = thc_nr$barrier_id, popup = ~paste0(thc_nr$barrier_id, "<br/>", rnc_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  
  addCircleMarkers(data = thc_r, label = thc_r$barrier_id, popup = ~paste0(thc_r$barrier_id, "<br/>", thc_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
