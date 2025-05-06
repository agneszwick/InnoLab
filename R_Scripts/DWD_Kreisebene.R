library(raster)
library(sf)
library(dplyr)


# 0. Konfiguration --------------------------------------------------------

# Pfad zum Shapefile der Kreise
shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/
             vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp" %>%
  gsub("\\s+","",.)  # remove stray whitespace

# Ordner mit den .asc-Dateien
asc_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/
            Temperatur/Saisonal" %>%
  gsub("\\s+","",.)

# Ausgabe-CSV
out_csv <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/Temperatur/Saisonal/Stats_Temp_Saisonal.csv" %>%
  gsub("\\s+","",.)

# 1. Kreise laden & projizieren ------------------------------------------

kreise <- st_read(shp_path) %>%
  st_transform(31467) %>%
  mutate(ID = row_number())  # eindeutige ID für jeden Kreis

# Basistabelle mit ARS, AGS, GEN, BEZ
# Data.frame ohne Geometrie
base_df <- kreise
sf::st_geometry(base_df) <- NULL   # entfernt die geometry-Spalte

# Nur die gewünschten Spalten behalten
keep_cols <- c("ID", "ARS", "AGS", "GEN", "BEZ")
base_df <- base_df[, keep_cols]

head(base_df)



# 2. ASC‑Dateien auflisten ------------------------------------------------

asc_files <- list.files(asc_dir, pattern = "\\.asc$", full.names = TRUE)

# 3. Loop über alle Dateien
final_df <- base_df
for(file in asc_files){
  # a) Roh‑Name aus dem Pfad
  fn   <- basename(file)                         # seasonal_air_temperature_…_202316.asc
  stem <- tools::file_path_sans_ext(fn)          # seasonal_air_temperature_…_202316

  # b) alles nach "...seasonal_" abtrennen
  short <- sub("^.*seasonal_", "", stem)         # z.B. "air_temperature_min_202316"
  # optional noch illegal chars weg:
  short <- gsub("[^A-Za-z0-9]+","_", short)      # "air_temperature_min_202316"

  # c) Raster laden + CRS setzen + Umrechnung
  r <- raster(file)
  crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
                 +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
                 +units=m +no_defs")
  r <- r / 10

  # d) Crop + Mask
  r2 <- mask(crop(r, extent(kreise)), kreise)

  # e) mean + median extrahieren
  stats <- extract(r2, kreise, fun=function(x, ...){
    x <- x[!is.na(x)]
    if(length(x)==0) return(c(mean=NA,median=NA))
    c(mean=mean(x), median=median(x))
  }, df=TRUE)

  # f) Spalten automatisch umbenennen
  names(stats)[2:3] <- paste0(short, c("_mean","_median"))

  # g) join an final_df
  final_df <- left_join(final_df, stats, by="ID")

  message("fertig: ", short)
}

# 4. Als CSV speichern
write.csv(final_df, out_csv, row.names=FALSE)
message("fertig – CSV: ", out_csv)



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
# nc_file <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/UHI/Tropische_Naechte/Saisonal/uhi-map_v7_clc1990_tropical-nights_diff_p3m_2022-03-01.nc" %>% 
#   gsub("\\s+","",.)
# 
# # Ausgabe-CSV
# out_csv <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/UHI/Tropische_Naechte/Stats_Tropical_Nights.csv" %>% 
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
# 
# # Um die Namen der Variablen in der NetCDF-Datei zu sehen:
# print(names(r))  # Dies gibt alle Variablen in der NetCDF-Datei zurück
# 
# 
# r <- projectRaster(r, crs = crs(kreise))
# 
# # 4. Crop + Mask ----------------------------------------------------------
# 
# r2 <- mask(crop(r, extent(kreise)), kreise)  # Schneidet den Rasterbereich auf die Kreise zu
# 
# # 5. Statistiken extrahieren ---------------------------------------------
# 
# # Extrahiert den Mittelwert und Median innerhalb der Kreise
# stats <- extract(r2, kreise, fun=function(x, ...){
#   x <- x[!is.na(x)]  # Entfernt NA-Werte
#   if(length(x)==0) return(c(mean=NA, median=NA))  # Falls keine Werte vorhanden sind
#   c(mean=mean(x), median=median(x))
# }, df=TRUE)
# 
# # 6. Umbenennen der Spalten ---------------------------------------------
# 
# # Falls die Variable aus der NetCDF-Datei benötigt wird, um die Spaltennamen zu generieren
# var_name <- "tropical_nights_diff"  # Hier kann der tatsächliche Variablenname aus der NetCDF-Datei verwendet werden
# 
# names(stats)[2:3] <- paste0(var_name, c("_mean", "_median"))
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
