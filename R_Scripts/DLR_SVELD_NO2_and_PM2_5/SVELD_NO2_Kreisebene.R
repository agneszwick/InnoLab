library(terra)
library(sf)
library(dplyr)
library(readr)
library(tidyr)
library(reshape2)
library(purrr)


### 1. Setup & Daten laden


# Pfade zu den Jahresmittel-Rastern
paths <- list(
  "2018" = "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DLR_S_VELD_NO2_PM2_5/S5P_TROPOMI_NO2/processed/NO2_AnnualMedian_2018.tif",
  "2019" = "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DLR_S_VELD_NO2_PM2_5/S5P_TROPOMI_NO2/processed/NO2_AnnualMedian_2019.tif",
  "2020" = "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DLR_S_VELD_NO2_PM2_5/S5P_TROPOMI_NO2/processed/NO2_AnnualMedian_2020.tif"
  
)

# Shapefile Landkreise
shapefile_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
landkreise_sf <- st_read(shapefile_path) %>% filter(GF == "4")  # nur Landkreise
landkreise <- vect(landkreise_sf)
landkreise <- project(landkreise, "EPSG:4326")


# Metadaten
krs_uebersicht <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/KRS_Uebersicht.csv")

# Ordner für Zwischenergebnisse
output_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DLR_S_VELD_NO2_PM2_5/S5P_TROPOMI_NO2/processed/"
dir.create(output_dir, showWarnings = FALSE)

### 2. Zonal Statistics für PM2.5 je Jahr
results <- list()

for (year in names(paths)) {
  message("Verarbeite Jahr ", year)
  r <- rast(paths[[year]])
  
  # Mittelwert
  m <- terra::extract(r, landkreise, fun = mean, na.rm = TRUE, ID = FALSE)
  colnames(m) <- paste0("NO2_Median_J_", year, "_mean")
  m$ARS <- landkreise$ARS
  
  # Median
  med <- terra::extract(r, landkreise, fun = median, na.rm = TRUE, ID = FALSE)
  colnames(med) <- paste0("NO2_Median_J_", year, "_median")
  med$ARS <- landkreise$ARS
  
  # Kombinieren
  stats_df <- left_join(m, med, by = "ARS")
  # Speichern
  results[[year]] <- stats_df
  terra::tmpFiles(remove = TRUE)
  gc()  # Speicher bereinigen
  
}

### 3.  Zusammenführen & Anreichern mit Metadaten
#Zusammenführen
df <- reduce(results, full_join, by = "ARS")

# Optional: anreichern mit Kreisnamen etc.
krs_uebersicht <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/KRS_Uebersicht.csv")
stats_all <- left_join(df, krs_uebersicht, by = "ARS") %>%
  select(AGS, ARS, GF, GEN, BEZ, everything())

View(stats_all)
# Export
write_csv(stats_all, file.path(output_dir, "DLR_NO2_Median_J_2018_2020.csv"))

