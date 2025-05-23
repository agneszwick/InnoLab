library(terra)
library(raster)
library(sf)
library(dplyr)
library(ggplot2)
library(viridis)

# Shapefile-Pfad (bereinigt)
shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"

# Kreise laden & transformieren
kreise <- st_read(shp_path) %>%
  st_transform(31467) %>%
  mutate(ID = row_number())

# Sentinel-5P Raster
file_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/MODIS/MODIS_061_MOD13A3/NDVI_Median_2022.tif"
r <- raster(file_path)
# r <- r * 1e6 # Scaling sentinel-5P
r <- r * 0.0001 # Scaling MODIS


# OPTIONAL: tatsächliches CRS prüfen (statt manuell setzen)
# print(crs(r))

# Transformiere Kreise auf das CRS des Rasters (statt Raster zu verändern!)
kreise <- st_transform(kreise, crs(r))

# Beispiel-Landkreis auswählen
selected_landkreis <- kreise[kreise$ID == 1, ]

# Sicherstellen, dass `selected_landkreis` als Spatial* vorliegt (für mask())
selected_landkreis_sp <- as_Spatial(selected_landkreis)

# Raster zuschneiden und maskieren
r2 <- crop(r, selected_landkreis_sp)
r2 <- mask(r2, selected_landkreis_sp)

# Visualisieren
plot(r2, main = "NDVI - Landkreis ID = 1",
     col = turbo(100), 
     zlim = c(min(r2[], na.rm = TRUE), max(r2[], na.rm = TRUE)))

# Landkreisgrenze hinzufügen
plot(st_geometry(selected_landkreis), add = TRUE, border = "red", lwd = 2)


# # --- Plot no2 ---
# plot(no2_umol,
#      main = expression("Jährlicher Mittelwert von O"[3]*" (2022) [µmol/m²]"),
#      col = viridis::turbo(100),
#      zlim = c(min(values(no2_umol), na.rm = TRUE),
#               max(values(no2_umol), na.rm = TRUE)))






















# # ---  MODIS ---
# ndvi_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/MODIS/NDVI_Median_2022.tif"
# ndvi <- rast(ndvi_path)
# # --- NDVI-Skalierung ---
# ndvi_scaled <- ndvi * 0.0001
# # NDVI-typische Farben (MODIS-inspiriert)
# ndvi_colors_modis <- colorRampPalette(c(
#   "#FFFFCC",  # sehr helles Beige
#   "#C2E699",  # gelbgrün
#   "#78C679",  # mittelgrün
#   "#31A354",  # sattgrün
#   "#006837"   # dunkelgrün
# ))(100)
# plot(ndvi_scaled,
#      main = expression("Jährlicher Mittelwert von NDVI (2022)"),
#      col = ndvi_colors_modis,
#      zlim = c(min(values(ndvi_scaled), na.rm = TRUE),
#               max(values(ndvi_scaled), na.rm = TRUE)))
