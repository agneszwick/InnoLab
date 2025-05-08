# 
# ## NC DATEN GEHT NOCH NICHT!!!
# # install.packages("ncdf4")
# library(raster)
# library(sf)
# library(dplyr)
# library(ncdf4)
# 
# # 0. Konfiguration --------------------------------------------------------
# 
# # Pfad zum Shapefile der Kreise
# shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/
#              vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp" %>%
#   gsub("\\s+","",.)  # Entferne Leerzeichen
# 
# # Pfad zur spezifischen NetCDF-Datei
# nc_file <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/UHI/Tropische_Naechte/Saisonal/uhi-map_v7_clc1990_tropical-nights_diff_p3m_2022-06-01.nc" %>%
#   gsub("\\s+","",.)
# 
# # Ausgabe-CSV
# out_csv <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/UHI/Tropische_Naechte/Saisonal/Stats_Tropical_Nights_Saisonal.csv" %>%
#   gsub("\\s+","",.)
# 
# # 1. Kreise laden & projizieren ------------------------------------------
# 
# kreise <- st_read(shp_path) %>%
#   st_transform(31467) %>%
#   mutate(ID = row_number())  # Eindeutige ID für jeden Kreis
# 
# # Basistabelle mit ARS, AGS, GEN, BEZ
# # Data.frame ohne Geometrie
# base_df <- kreise
# sf::st_geometry(base_df) <- NULL   # Entfernt die Geometrie-Spalte
# 
# # Nur die gewünschten Spalten behalten
# keep_cols <- c("ID", "ARS", "AGS", "GEN", "BEZ")
# base_df <- base_df[, keep_cols]
# 
# head(base_df)
# 
# # 2. NetCDF-Datei laden --------------------------------------------------
# 
# # NetCDF-Datei einlesen
# r <- raster(nc_file)  # Lädt die NetCDF-Datei
# plot(r)
# 
# # Um die Namen der Variablen in der NetCDF-Datei zu sehen:
# print(names(r))  # Dies gibt alle Variablen in der NetCDF-Datei zurück
# 
# # 3. Rasterdaten projizieren ---------------------------------------------
# 
# crs(r) <- CRS("+proj=lcc +lat_1=35 +lat_2=65 +lat_0=52 +lon_0=10 +x_0=4000000 +y_0=2800000 +ellps=GRS80 +units=m +no_defs")
# r_proj <- projectRaster(r, crs = st_crs(kreise)$proj4string)  # auf EPSG:31467
# 
# 
# # 4. Crop + Mask ----------------------------------------------------------
# r2 <- mask(crop(r_proj, extent(kreise)), kreise)
# 
# # 5. Statistiken extrahieren ---------------------------------------------
# 
# # Extrahiert den Mittelwert, Median und Max innerhalb der Kreise
# stats <- extract(r2, kreise, fun=function(x, ...){
#   x <- x[!is.na(x)]  # Entfernt NA-Werte
#   if(length(x)==0) return(c(mean=NA, median=NA, max=NA))  # Falls keine Werte vorhanden sind
#   c(mean=mean(x), median=median(x), max=max(x))
# }, df=TRUE)
# 
# # 6. Umbenennen der Spalten ---------------------------------------------
# 
# # Falls die Variable aus der NetCDF-Datei benötigt wird, um die Spaltennamen zu generieren
# var_name <- "tropical-nights_diff_p3m_2022-06"  # Hier kann der tatsächliche Variablenname aus der NetCDF-Datei verwendet werden
# 
# names(stats)[2:4] <- paste0(var_name, c("_mean", "_median", "_max"))
# 
# # 7. Joinen der Daten mit der Basis-Tabelle --------------------------------
# 
# # Füge die extrahierten Statistiken mit der Basis-Tabelle zusammen
# final_df <- left_join(base_df, stats, by="ID")
# 
# # 8. Als CSV speichern ---------------------------------------------------
# 
# write.csv(final_df, out_csv, row.names=FALSE)
# message("fertig – CSV: ", out_csv)



# --- Pakete laden --------------------------------------------------------
library(raster)
library(sf)
library(dplyr)
library(ncdf4)
library(stringr)
library(purrr)

# --- Konfiguration -------------------------------------------------------
shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
input_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/UHI/Tropische_Naechte/Jaehrlich"
output_csv <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/UHI/Tropische_Naechte/Jaehrlich/Stats_Tropical_Nights_Jaehrlich.csv"

# --- Kreise laden und vorbereiten ----------------------------------------
kreise <- st_read(shp_path) %>%
  st_transform(31467) %>%
  mutate(ID = row_number())

base_df <- kreise
sf::st_geometry(base_df) <- NULL
base_df <- base_df[, c("ID", "ARS", "AGS", "GEN", "BEZ")]

# --- Hilfsfunktion: Stats für eine einzelne Datei extrahieren ------------
process_nc_file <- function(nc_path) {
  # Extrahiere Basisnamen ohne Pfad & Endung
  file_base <- tools::file_path_sans_ext(basename(nc_path))
  
  # Lade Raster
  r <- raster(nc_path)
  crs(r) <- CRS("+proj=lcc +lat_1=35 +lat_2=65 +lat_0=52 +lon_0=10 +x_0=4000000 +y_0=2800000 +ellps=GRS80 +units=m +no_defs")
  r_proj <- projectRaster(r, crs = st_crs(kreise)$proj4string)
  r_crop <- mask(crop(r_proj, extent(kreise)), kreise)
  
  # Statistik berechnen
  stats <- extract(r_crop, kreise, fun=function(x, ...) {
    x <- x[!is.na(x)]
    if(length(x)==0) return(c(mean=NA, median=NA, max=NA))
    c(mean=mean(x), median=median(x), max=max(x))
  }, df=TRUE)
  
  # Spalten benennen
  names(stats)[2:4] <- paste0(file_base, c("_mean", "_median", "_max"))
  
  return(stats)
}

# --- Alle NetCDF-Dateien verarbeiten -------------------------------------
nc_files <- list.files(input_dir, pattern="\\.nc$", full.names=TRUE)

# Für jede Datei Stats extrahieren
all_stats_list <- map(nc_files, process_nc_file)

# Liste zu Data Frame zusammenführen (über ID joinen)
final_df <- reduce(all_stats_list, left_join, by="ID")
final_df <- left_join(base_df, final_df, by="ID")

# --- Als CSV speichern ----------------------------------------------------
write.csv(final_df, output_csv, row.names=FALSE)
message("Fertig – CSV gespeichert unter: ", output_csv)



# --- Landkreise in Karte darstellen ----------------------------------------------------

library(sf)
library(tmap)

# Kreise laden
kreise <- st_read(shp_path) %>%
  st_transform(31467)

library(sf)
library(ggplot2)

# Kreise laden
kreise <- st_read(shp_path) %>%
  st_transform(31467)  # UTM Zone 32N

# Nur die Umrisse plotten
ggplot(kreise) +
  geom_sf(fill = NA, color = "black", size = 0.3) +
  theme_minimal() +
  labs(title = "Umrisse der Landkreise in Deutschland")


