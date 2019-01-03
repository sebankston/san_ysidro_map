library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title %>% str_subset("North Fork")

nfm_all <- gs_title("North Fork Matilija Creek Inventory")

gs_ws_ls(nfm_all)

nfm_data <- gs_read(ss = nfm_all, ws = "Sheet1") %>% clean_names()

nfm_nr <- nfm_data %>% filter(barrier_type == "NR") 
nfm_r <- nfm_data %>% filter(barrier_type == "R") 
nfm_r2 <- nfm_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = nfm_r2, label = nfm_r2$barrier_id, popup = ~paste0(nfm_r2$barrier_id, "<br/>", nfm_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>%
  
  # addCircleMarkers(data = nfm_nr, label = nfm_nr$barrier_id, popup = ~paste0(nfm_nr$barrier_id, "<br/>", rnc_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  
  addCircleMarkers(data = nfm_r, label = nfm_r$barrier_id, popup = ~paste0(nfm_r$barrier_id, "<br/>", nfm_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
