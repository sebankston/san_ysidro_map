library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title %>% str_subset("Buena")

bv_all <- gs_title("Buena_Vista_Creek_Inventory")

gs_ws_ls(bv_all)

bv_data <- gs_read(ss = bv_all, ws = "Sheet1") %>% clean_names()

bv_nr <- bv_data %>% filter(barrier_type == "NR") 
bv_r <- bv_data %>% filter(barrier_type == "R") 
bv_r2 <- bv_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = bv_r2, label = bv_r2$barrier_id, popup = ~paste0(bv_r2$barrier_id, "<br/>", bv_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>%
  
  # addCircleMarkers(data = bv_nr, label = bv_nr$barrier_id, popup = ~paste0(bv_nr$barrier_id, "<br/>", rnc_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  
  addCircleMarkers(data = bv_r, label = bv_r$barrier_id, popup = ~paste0(bv_r$barrier_id, "<br/>", bv_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
