library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

sy_all <- gs_title("San_Ysidro_inventory")

gs_ws_ls(sy_all)

sy_data <- gs_read(ss = sy_all, ws = "Sheet1") %>% clean_names()

sy_nr <- sy_data %>% filter(barrier_type_road_non_road == "NR") 
sy_r <- sy_data %>% filter(barrier_type_road_non_road == "R") 
sy_r2 <- sy_data %>% filter(barrier_type_road_non_road == "R" & x2nd_pass_y_n == "Yes") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = sy_r2, label = sy_r2$barrier_id, popup = ~paste0(sy_r2$barrier_id, "<br/>", sy_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>% 
  addCircleMarkers(data = sy_nr, label = sy_nr$barrier_id, popup = ~paste0(sy_nr$barrier_id, "<br/>", sy_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  addCircleMarkers(data = sy_r, label = sy_r$barrier_id, popup = ~paste0(sy_r$barrier_id, "<br/>", sy_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
