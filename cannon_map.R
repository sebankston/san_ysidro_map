library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title %>% str_subset(pattern = "ory$")

can_all <- gs_title("Cannon_Creek_inventory")

gs_ws_ls(can_all)

can_data <- gs_read(ss = can_all, ws = "Sheet1") %>% clean_names()

can_nr <- can_data %>% filter(barrier_type == "NR") 
can_r <- can_data %>% filter(barrier_type == "R") 
can_r2 <- can_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = can_r2, label = can_r2$barrier_id, popup = ~paste0(can_r2$barrier_id, "<br/>", can_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>%
  
  # addCircleMarkers(data = can_nr, label = can_nr$barrier_id, popup = ~paste0(can_nr$barrier_id, "<br/>", rnc_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  
  addCircleMarkers(data = can_r, label = can_r$barrier_id, popup = ~paste0(can_r$barrier_id, "<br/>", can_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
