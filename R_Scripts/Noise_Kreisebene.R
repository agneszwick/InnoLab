# Lade benoetigte Pakete
library(terra)
library(sf)
library(dplyr)
library(readr)
library(tidyr)
library(reshape2)

# ---- 1. Daten laden ----

# Rasterdaten (Verkehrslaerm)
raster_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Noise2AOI/NOISE2AOI_LDEN2017_Germany_BKG25STA_ValuesMapped_COG.tif"
raster_data <- rast(raster_path)

# Verwaltungsgrenzen
shapefile_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
landkreise_sf <- st_read(shapefile_path) %>% filter(GF == "4")  # nur Landkreise

# Metadaten zu Kreisen
krs_uebersicht <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/KRS_Uebersicht.csv")

# CRS anpassen falls noetig
if (st_crs(landkreise_sf) != crs(raster_data)) {
  landkreise_sf <- st_transform(landkreise_sf, crs = crs(raster_data))
}

# Konvertiere Landkreise zu SpatVector (terra-kompatibel)
landkreise <- vect(landkreise_sf)

# Exportverzeichnis fuer geschnittene Raster
output_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Noise2AOI/processed"
dir.create(output_dir, showWarnings = FALSE)

# ---- 2. Raster zuschneiden und exportieren ----
batch_size <- 5
for (start in seq(1, nrow(landkreise), by = batch_size)) {
  end <- min(start + batch_size - 1, nrow(landkreise))
  cat("Verarbeite Landkreise", start, "bis", end, "\n")
  
  for (i in start:end) {
    land <- landkreise[i, ]
    land_ARS <- land$ARS
    
    masked <- mask(crop(raster_data, land), land)
    
    writeRaster(masked, file.path(output_dir, paste0("NOISE_", land_ARS, ".tif")), overwrite = TRUE)
    rm(masked)
    gc()
  }
  terra::tmpFiles(remove = TRUE)
}

# ---- 3. Zonal Statistics ----
raster_files <- list.files(output_dir, pattern = "\\.tif$", full.names = TRUE)
results <- data.frame()

for (file in raster_files) {
  r <- rast(file)
  freq_df <- as.data.frame(freq(r))
  freq_df$raster_id <- tools::file_path_sans_ext(basename(file))
  results <- bind_rows(results, freq_df)
  rm(r, freq_df)
  gc()
  terra::tmpFiles(remove = TRUE)
}

# ---- 4. Dataframe  ----
results_clean <- results %>%
  filter(value != 254) %>%
  mutate(
    ARS = gsub("NOISE_", "", raster_id),
    value = as.character(value),
    count = as.numeric(count)
  )

# Pivot in Wide-Format und Umbenennung der Spalten
wide_results <- dcast(
  results_clean,
  ARS ~ value,
  value.var = "count",
  fun.aggregate = sum,
  fill = 0
)
colnames(wide_results)[-1] <- paste0(colnames(wide_results)[-1], "_J_2017")

# ---- 5. Flaechenberechnung ----
# Pixel zu m2 umrechnen (1 Pixel = 100 m²)
wide_area_m2 <- wide_results
wide_area_m2[,-1] <- wide_area_m2[,-1] * 100

# Kreisflaeche in m² berechnen
landkreis_flaeche <- landkreise_sf %>%
  mutate(flaeche_m2 = st_area(geometry)) %>%
  st_drop_geometry() %>%
  select(ARS, flaeche_m2)

# Verknuepfung
wide_area_percent <- left_join(wide_area_m2, landkreis_flaeche, by = "ARS")

# Prozentuale Anteile berechnen
percent_cols <- setdiff(colnames(wide_area_m2), c("ARS", "253_J_2017"))
wide_percent <- wide_area_percent
wide_percent[percent_cols] <- lapply(
  percent_cols,
  function(col) (wide_area_percent[[col]] / as.numeric(wide_area_percent$flaeche_m2)) * 100
)

# Entferne ungewünschte Spalten
wide_percent <- wide_percent %>% select(-'flaeche_m2')
head(wide_percent)

# ---- 6. Anreichern mit Metadaten und Export ----
df_final <- wide_percent %>%
  left_join(krs_uebersicht, by = "ARS") %>%
  select(AGS, ARS, GF, GEN, BEZ, everything())

write_csv(df_final, "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Noise2AOI/processed/Road_Traffic_Noise_J_2018.csv")