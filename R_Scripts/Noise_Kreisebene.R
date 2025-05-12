library(terra)
library(sf)
library(dplyr)

# Lade das Raster
raster_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Noise2AOI/NOISE2AOI_LDEN2017_Germany_BKG25STA_ValuesMapped_COG.tif"
raster_data <- rast(raster_path)

# Lade die Bundesländer (als sf)
shapefile_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
landkreise_sf <- st_read(shapefile_path)

# Filter auf GF == "4"
landkreise_sf <- landkreise_sf %>% filter(GF == "4")

# Transformiere CRS, falls notwendig
if (st_crs(landkreise_sf) != crs(raster_data)) {
  landkreise_sf <- st_transform(landkreise_sf, crs = crs(raster_data))
}

# Konvertiere zu SpatVector
landkreise <- vect(landkreise_sf)

# Speicherpfad für Export
output_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Noise2AOI/processed"
dir.create(output_dir, showWarnings = FALSE)


# # Hilfsfunktion: Namen säubern für Dateinamen
# sanitize_name <- function(name) {
#   name <- gsub(" ", "_", name)             # Leerzeichen → Unterstriche
#   name <- gsub("[^A-Za-z0-9_]", "", name)  # Sonderzeichen entfernen
#   name <- iconv(name, from = "UTF-8", to = "ASCII//TRANSLIT")  # Umlaute umwandeln
#   return(name)
# }

# Schleife über Bundesländer mit Export
for (i in 1:nrow(landkreise)) {
  land <- landkreise[i, ]
  land_ARS <- land$ARS

  # Zuschneiden und maskieren
  cropped <- crop(raster_data, land)
  masked <- mask(cropped, land)
  
  # Exportiere mit sauberem Dateinamen
  out_path <- file.path(output_dir, paste0("NOISE_", land_ARS, ".tif"))
  writeRaster(masked, out_path, overwrite = TRUE)
  cat("Exportiert:", out_path, "\n")
}







# library(terra)
# library(sf)
# library(dplyr)
# library(tidyr)
# 
# 
# # Lade das Raster (tif-Datei)
# raster_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Noise2AOI/NOISE2AOI_LDEN2017_Germany_BKG25STA_ValuesMapped_COG.tif"
# raster_data <- rast(raster_path)
# 
# # Lade das Shapefile der Bundesländer
# shapefile_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_LAN.shp"
# bundeslaender <- st_read(shapefile_path)
# 
# landkreise <- st_read("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp")
# 
# 
# # CRS des Rasters und der Bundesländer prüfen
# raster_crs <- crs(raster_data)
# shapefile_crs <- st_crs(bundeslaender)
# 
# 
# # Wenn die CRS nicht übereinstimmen, projiziere das Shapefile
# if (!st_crs(bundeslaender) == raster_crs) {
#   bundeslaender <- st_transform(bundeslaender, crs = raster_crs)
#   cat("Das Shapefile wurde auf das CRS des Rasters projiziert.\n")
# } else {
#   cat("Das CRS des Shapefiles stimmt bereits mit dem des Rasters überein.\n")
# }
# 
# # Wenn die CRS nicht übereinstimmen, projiziere das Shapefile
# if (!st_crs(landkreise) == raster_crs) {
#   landkreise <- st_transform(landkreise, crs = raster_crs)
#   cat("Das Shapefile wurde auf das CRS des Rasters projiziert.\n")
# } else {
#   cat("Das CRS des Shapefiles stimmt bereits mit dem des Rasters überein.\n")
# }
# 
# 
# # Konvertiere zu SpatVector
# bundeslaender <- vect(bundeslaender)
# landkreise <- vect(landkreise)
# 
# 
# # Liste zur Speicherung der zugeschnittenen Raster
# z_cut_rasters <- list()
# 
# # Schleife über die Bundesländer
# for (i in 1:nrow(bundeslaender)) {
#   # Einzelnes Bundesland extrahieren
#   land_polygon <- bundeslaender[i, ]
#   
#   # Raster zuschneiden und maskieren
#   cropped <- crop(raster_data, land_polygon)
#   masked <- mask(cropped, land_polygon)
#   
#   # Speichern
#   z_cut_rasters[[i]] <- masked
# }
# 
# # Ergebnisliste
# results_list <- list()
# 
# for (i in 1:nrow(landkreise)) {
#   
#   kreis <- landkreise[i, ]
#   kreis_id <- kreis$ARS
#   
#   # Bounding Box des Landkreises
#   kreis_ext <- ext(kreis)
#   
#   # Finde passenden Rasterausschnitt
#   raster_match <- NULL
#   for (j in seq_along(z_cut_rasters)) {
#     r <- z_cut_rasters[[j]]
#     if (relate(kreis_ext, ext(r), "intersects")) {
#       raster_match <- r
#       break
#     }
#   }
#   
#   if (is.null(raster_match)) {
#     warning(paste("Kein Raster für Landkreis", kreis_id, "gefunden."))
#     next
#   }
#   
#   # Zuschneiden und maskieren
#   cropped <- crop(raster_match, kreis)
#   masked <- mask(cropped, kreis)
#   
#   # Zähle Pixelwerte
#   freq_table <- freq(masked)
#   df <- as.data.frame(freq_table)
#   df$ARS <- kreis_id
#   results_list[[i]] <- df
# }
# 
# # Zusammenführen
# results_df <- bind_rows(results_list)
# 
# # In weites Format: eine Spalte pro Pixelwert
# results_wide <- pivot_wider(
#   results_df,
#   names_from = value,
#   values_from = count,
#   values_fill = 0
# )
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# # library(terra)
# # library(sf)
# # library(dplyr)
# # library(tidyr)
# # library(terra)
# # 
# # # Raster laden
# # noise_raster <- rast("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Noise2AOI/NOISE2AOI_LDEN2017_Germany_BKG25STA_ValuesMapped_COG.tif")
# # 
# # # 1. Nur Pixel behalten, die NICHT 254 sind
# # noise_valid <- classify(noise_raster, matrix(c(254, NA), ncol=2, byrow=TRUE))  # setzt 254 auf NA
# # 
# # # Anzahl gültiger (nicht-NA) Pixel
# # valid_pixel_count <- global(!is.na(noise_valid), fun = "sum", na.rm = TRUE)
# # print(valid_pixel_count)
# # 
# # # Optional: nur im relevanten Bereich clippen (z.B. mit Verwaltungsgrenzen)
# # # noise_valid <- crop(noise_valid, vect(krs))  # falls du möchtest
# # 
# # # 2. Vektorisieren (nur gültige Pixel) – jetzt viel kleiner!
# # noise_vect <- as.polygons(noise_valid, dissolve = TRUE)
# # names(noise_vect) <- "ldenv"
# # 
# # # 2. KRS- oder Gemeindegrenzen laden
# # gemeinden <- st_read("C:/.../VG250_GEM.shp")  # falls du wirklich auf Gemeindeebene willst
# # gemeinden <- st_transform(gemeinden, crs(noise_vect))
# # 
# # # 3. Konvertiere Rasterpolygone in sf
# # noise_sf <- st_as_sf(noise_vect)
# # 
# # # 4. Flächenschnitt: Lärmpolygone mit Gemeinden überschneiden
# # intersection <- st_intersection(gemeinden, noise_sf)
# # 
# # # 5. Fläche berechnen in m²
# # intersection$area_m2 <- st_area(intersection)
# # intersection$area_km2 <- as.numeric(intersection$area_m2) / 1e6
# # 
# # # 6. Summieren: Fläche je Gemeinde & Lärmklasse
# # result <- intersection %>%
# #   group_by(AGS, ldenv) %>%  # AGS oder ein anderer eindeutiger Gemeindeschlüssel
# #   summarise(area_km2 = sum(area_km2), .groups = "drop")
# # 
# # # 7. Prozentuale Fläche je Gemeinde
# # result <- result %>%
# #   group_by(AGS) %>%
# #   mutate(percent = round(100 * area_km2 / sum(area_km2), 2)) %>%
# #   ungroup()
# # 
# # # 8. Pivot breites Format (optional)
# # result_wide <- result %>%
# #   select(AGS, ldenv, percent) %>%
# #   pivot_wider(names_from = ldenv, values_from = percent, names_prefix = "noise_")
# # 
# # # 9. Exportieren
# # write.csv(result_wide, "noise_percent_per_gemeinde.csv", row.names = FALSE)
# # 
# # 
# # 
# # 
# # 
# # # library(terra)
# # # library(sf)
# # # library(exactextractr)
# # # library(dplyr)
# # # library(tidyr)
# # # 
# # # # 1. Daten laden
# # # noise_raster <- rast("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Noise2AOI/NOISE2AOI_LDEN2017_Germany_BKG25STA_ValuesMapped_COG.tif")
# # # krs <- st_read("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp")
# # # 
# # # # 2. Projektionen abgleichen
# # # krs <- st_transform(krs, crs(noise_raster))
# # # 
# # # # 3. Pixelwerte pro KRS extrahieren
# # # # returns a list of data.frames (value + coverage_fraction)
# # # extracted <- exact_extract(noise_raster, krs, include_cols = "AGS")
# # # 
# # # # 4. Histogramme manuell berechnen
# # # # Für jede Region: Lärmwert zählen, gewichtet nach Flächenanteil (coverage_fraction)
# # # hist_list <- lapply(seq_along(extracted), function(i) {
# # #   df <- extracted[[i]]
# # #   if (nrow(df) == 0) return(NULL)
# # #   
# # #   ags <- krs$AGS[i]
# # #   df <- df[!is.na(df$value), ]
# # #   
# # #   # Gewichtete Zählung
# # #   counts <- df %>%
# # #     group_by(value) %>%
# # #     summarise(weighted_area = sum(coverage_fraction), .groups = "drop")
# # #   
# # #   total <- sum(counts$weighted_area)
# # #   
# # #   counts <- counts %>%
# # #     mutate(percent = round(100 * weighted_area / total, 2),
# # #            AGS = ags)
# # #   
# # #   return(counts)
# # # })
# # # 
# # # # 5. Alle Einzeltabellen zusammenführen
# # # hist_df <- bind_rows(hist_list)
# # # 
# # # # 6. In breites Format (jede Lärmklasse als Spalte)
# # # result_wide <- hist_df %>%
# # #   select(AGS, value, percent) %>%
# # #   pivot_wider(names_from = value, values_from = percent, names_prefix = "noise_")
# # # 
# # # # 7. Optional: Exportieren
# # # write.csv(result_wide, "noise_percent_per_KRS.csv", row.names = FALSE)
