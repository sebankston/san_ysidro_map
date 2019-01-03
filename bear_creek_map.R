library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title %>% str_subset("Bear")

ber_all <- gs_title("Bear_Creek_Inventory")

gs_ws_ls(ber_all)

ber_data <- gs_read(ss = ber_all, ws = "Sheet1") %>% clean_names()

ber_nr <- ber_data %>% filter(barrier_type == "NR") 
ber_r <- ber_data %>% filter(barrier_type == "R") 
ber_r2 <- ber_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = ber_r2, label = ber_r2$barrier_id, popup = ~paste0(ber_r2$barrier_id, "<br/>", ber_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>%
  
  # addCircleMarkers(data = ber_nr, label = ber_nr$barrier_id, popup = ~paste0(ber_nr$barrier_id, "<br/>", rnc_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  
  addCircleMarkers(data = ber_r, label = ber_r$barrier_id, popup = ~paste0(ber_r$barrier_id, "<br/>", ber_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
