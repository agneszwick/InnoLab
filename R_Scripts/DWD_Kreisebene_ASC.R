library(raster)
library(sf)
library(dplyr)

# FÜR TEMP UND NIEDERSCHLAG

# 0. Konfiguration --------------------------------------------------------

# Pfad zum Shapefile der Kreise
shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/
             vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp" %>%
  gsub("\\s+","",.)  # remove stray whitespace

# Ordner mit den .asc-Dateien
asc_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/
            Niederschlag/Jaehrlich" %>%
  gsub("\\s+","",.)

# Ausgabe-CSV
out_csv <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/Niederschlag/Jaehrlich/Stats_Prec_Jaehrlich.csv" %>%
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
  
  # r <- r / 10 # nur bei Temoeraturdaten

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


# 5. Karte plotten --------------------------------------------------------

# Pakete laden
library(raster)
library(sf)
library(dplyr)
library(viridis)

# 0. Konfiguration --------------------------------------------------------

# Pfad zur .asc-Datei (Jährliche Niederschlagsdaten)
prec_file <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Niederschlag/Jaehrlich/annual_precipitation_grids_germany_annual_precipitation_202217.asc"
temp_file <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Temperatur/Jaehrlich/annual_air_temperature_max_grids_germany_annual_air_temp_max_202217.asc"

# 2. Raster laden und projizieren --------------------------------------------

# Rasterdatei laden
r <- raster(temp_file)

# Setze das Koordinatensystem (CRS) für das Raster
crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
                 +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
                 +units=m +no_defs")

r <- r / 10 # nur bei Temoeraturdaten


# 3. Zuschneiden und Maskieren des Rasters ------------------------------------

# Beispiel: Wähle einen bestimmten Landkreis, z.B. ID 1 (ändern nach Bedarf)
# selected_landkreis <- kreise[kreise$GEN == 'Würzburg', ]
selected_landkreis <- kreise[kreise$ID == 1, ]

plot(selected_landkreis)

r2 <- mask(crop(r, extent(selected_landkreis)), selected_landkreis)



# 4. Visualisierung des Rasters mit Landkreisbgrenzung -----------------------

# Plot des zugeschnittenen Rasters
plot(r2, main = "Jährliche Durchschnittstemperatur - Landkreis ID=1",
     col = turbo(100), 
     zlim = c(min(r2[], na.rm = TRUE), max(r2[], na.rm = TRUE)))

# Umriss des Landkreises hinzufügen
plot(st_geometry(selected_landkreis), add = TRUE, border = "red", lwd = 2)


