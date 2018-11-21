library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

mon_all <- gs_title("Montecito_Creek_inventory")

gs_ws_ls(mon_all)

mon_data <- gs_read(ss = mon_all, ws = "Sheet1") %>% clean_names()

mon_nr <- mon_data %>% filter(barrier_type == "NR") 
mon_r <- mon_data %>% filter(barrier_type == "R") 
mon_r2 <- mon_data %>% filter(barrier_type == "R" & second_pass_reqd == "Yes") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = mon_r2, label = mon_r2$barrier_id, popup = ~paste0(mon_r2$barrier_id, "<br/>", mon_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>% 
  addCircleMarkers(data = mon_nr, label = mon_nr$barrier_id, popup = ~paste0(mon_nr$barrier_id, "<br/>", mon_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  addCircleMarkers(data = mon_r, label = mon_r$barrier_id, popup = ~paste0(mon_r$barrier_id, "<br/>", mon_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
