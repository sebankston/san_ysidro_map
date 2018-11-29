library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title

rnc_all <- gs_title("Rincon_Creek_inventory")

gs_ws_ls(rnc_all)

rnc_data <- gs_read(ss = rnc_all, ws = "Sheet1") %>% clean_names()

rnc_nr <- rnc_data %>% filter(barrier_type == "NR") 
rnc_r <- rnc_data %>% filter(barrier_type == "R") 
rnc_r2 <- rnc_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = rnc_r2, label = rnc_r2$barrier_id, popup = ~paste0(rnc_r2$barrier_id, "<br/>", rnc_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>% 
  addCircleMarkers(data = rnc_nr, label = rnc_nr$barrier_id, popup = ~paste0(rnc_nr$barrier_id, "<br/>", rnc_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  addCircleMarkers(data = rnc_r, label = rnc_r$barrier_id, popup = ~paste0(rnc_r$barrier_id, "<br/>", rnc_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
