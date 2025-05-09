# Lade benötigte Bibliotheken
library(terra)
library(viridis)
library(tools)

# Pfad zur Rasterdatei
file_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Niederschlag/Jaehrlich/annual_precipitation_grids_germany_annual_precipitation_202017.asc"

# Lade das Raster
r <- raster(file_path)

# Extrahiere und formatiere den Dateinamen als Titel
file_name <- file_path_sans_ext(basename(file_path))
plot_title <- gsub("_", " ", file_name)  # Ersetze Unterstriche durch Leerzeichen

# Bestimme minimale und maximale Werte für Farbschema
z_range <- range(r[], na.rm = TRUE)

# Plot mit schöner Farbpalette und automatisch generiertem Titel
plot(
  r,
  main = plot_title,
  col = turbo(100),
  zlim = z_range
)


# Auf Landkreisebene plotten --------------------------------------------------------
# Pakete laden
library(raster)
library(sf)
library(dplyr)
library(viridis)

shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/
             vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp" %>%
  gsub("\\s+","",.)  # remove stray whitespace

kreise <- st_read(shp_path) %>%
  st_transform(31467) %>%
  mutate(ID = row_number())  # eindeutige ID für jeden Kreis

# Pfade zur Rasterdatei (Beispiel: jährliche Temperaturdaten)
prec_file <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Niederschlag/Jaehrlich/annual_precipitation_grids_germany_annual_precipitation_202217.asc"
temp_file <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Temperatur/Jaehrlich/annual_air_temperature_max_grids_germany_annual_air_temp_max_202217.asc"

# Raster laden
r <- raster(temp_file)

# Projektion setzen (Gauß-Krüger Zone 3, Bessel-Ellipsoid mit Helmert-Transformation)
crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
               +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
               +units=m +no_defs")

# Optional: Temperaturdaten skalieren (z. B. durch 10 teilen)
# r <- r / 10

# Landkreis auswählen (nach ID oder Name)
# selected_landkreis <- kreise[kreise$GEN == "Würzburg", ]
selected_landkreis <- kreise[kreise$ID == 1, ]

# Raster auf Landkreis beschränken
r_crop <- crop(r, extent(selected_landkreis))
r_masked <- mask(r_crop, selected_landkreis)

# Plot erstellen
plot(
  r_masked,
  main = "Jährliche Maximaltemperatur – Landkreis ID = 1",
  col = turbo(100),
  zlim = range(r_masked[], na.rm = TRUE),
  axes = FALSE,
  box = FALSE
)

# Landkreis-Umriss hinzufügen
plot(st_geometry(selected_landkreis), add = TRUE, border = "red", lwd = 2)
