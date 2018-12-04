library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(googlesheets)
library(janitor)
library(htmlwidgets)

all_sheets <- as_tibble(gs_ls())

all_sheets$sheet_title

ayp_all <- gs_title("Arroyo_Paredon_Creek_inventory")

gs_ws_ls(ayp_all)

ayp_data <- gs_read(ss = ayp_all, ws = "Sheet1") %>% clean_names()

# ayp_nr <- ayp_data %>% filter(barrier_type == "NR") 
ayp_r <- ayp_data %>% filter(barrier_type == "R") 
ayp_r2 <- ayp_data %>% filter(barrier_type == "R" & x2nd_pass == "Y") 

leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap", group = "Street Map") %>% 
  addProviderTiles("Esri.WorldImagery",group = "World Imagery") %>% 
  addCircleMarkers(data = ayp_r2, label = ayp_r2$barrier_id, popup = ~paste0(ayp_r2$barrier_id, "<br/>", ayp_r2$pad_id), color = "red", group = "Detailed Required", radius = 5, fillOpacity = .5) %>%
  
  # addCircleMarkers(data = ayp_nr, label = ayp_nr$barrier_id, popup = ~paste0(ayp_nr$barrier_id, "<br/>", rnc_nr$pad_id), color = "dodgerblue", group = "Non-Road Barrier", radius = 3, fillOpacity = 1) %>%
  
  addCircleMarkers(data = ayp_r, label = ayp_r$barrier_id, popup = ~paste0(ayp_r$barrier_id, "<br/>", ayp_r$pad_id), color = "green", group = "Road Barrier", radius = 3, fillOpacity = 1) %>%
  addLayersControl(baseGroups = c("Street Map", "World Imagery"), overlayGroups = c("Non-Road Barrier", "Road Barrier", "Detailed Required"))
