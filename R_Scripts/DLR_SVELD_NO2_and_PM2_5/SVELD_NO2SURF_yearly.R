library(ncdf4)
library(terra)
library(fs)

# Ordner mit den ZIP-Dateien und Entpacken
zip_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DLR_S_VELD_NO2_PM2_5/S5P_TROPOMI_NO2SURF"
zip_files <- dir_ls(zip_dir, glob = "*.zip")

for (zip_file in zip_files) {
  unzip(zip_file, exdir = zip_dir)
  cat("Entpackt:", zip_file, "\n")
}

# Variable im NetCDF
no2surf_var <- "no2_concentration"
years <- c("2018", "2019", "2020")

# Funktion zum Invertieren der y-Achse (wenn nötig)
flip_y <- function(r) {
  ext <- ext(r)
  r_flipped <- flip(r, direction = "vertical")
  ext(r_flipped) <- ext
  return(r_flipped)
}

for (year in years) {
  nc_files <- dir_ls(zip_dir, regexp = paste0(year, ".*\\.nc$"))
  
  rasters <- list()
  
  for (file in nc_files) {
    # NetCDF öffnen
    nc <- nc_open(file)
    
    # Variable auslesen
    var_data <- ncvar_get(nc, no2surf_var)
    lat <- ncvar_get(nc, "latitude")   # ggf. anpassen, je nach NetCDF Struktur
    lon <- ncvar_get(nc, "longitude")  # ggf. anpassen
    
    nc_close(nc)
    
    # t() ist oft nötig, da NetCDF Daten oft (lon, lat) oder (x,y) gespeichert sind
    # Prüfe das genau bei deinen Daten und passe ggf. an
    r <- rast(t(var_data))
    
    # Extent setzen
    ext(r) <- c(min(lon), max(lon), min(lat), max(lat))
    
    # CRS setzen
    crs(r) <- "EPSG:4326"
    
    rasters[[length(rasters) + 1]] <- r
    
    rm(r)
    gc()
  }
  
  if (length(rasters) == 0) {
    warning("Keine Dateien für Jahr ", year)
    next
  }
  
  r_stack <- rast(rasters)
  
  r_year_mean <- mean(r_stack, na.rm = TRUE)
  r_year_median <- app(r_stack, median, na.rm = TRUE)
  
  # Falls notwendig y-Achse invertieren
  r_year_mean <- flip_y(r_year_mean)
  r_year_median <- flip_y(r_year_median)
  
  out_mean <- file.path(zip_dir, paste0("processed/NO2SURF_AnnualMean_", year, ".tif"))
  out_median <- file.path(zip_dir, paste0("processed/NO2SURF_AnnualMedian_", year, ".tif"))
  
  writeRaster(r_year_mean, out_mean, overwrite = TRUE)
  writeRaster(r_year_median, out_median, overwrite = TRUE)
  
  message("Jahresmittel gespeichert für ", year, " unter ", out_mean)
  message("Jahresmedian gespeichert für ", year, " unter ", out_median)
  
  rm(r_stack, r_year_mean, r_year_median, rasters)
  gc()
}


# Raster laden und plotten
r2018_mean <- rast(file.path(zip_dir, "processed/NO2SURF_AnnualMean_2018.tif"))
r2019_mean <- rast(file.path(zip_dir, "processed/NO2SURF_AnnualMean_2019.tif"))
r2020_mean <- rast(file.path(zip_dir, "processed/NO2SURF_AnnualMean_2020.tif"))

r2018_median <- rast(file.path(zip_dir, "processed/NO2SURF_AnnualMedian_2018.tif"))
r2019_median <- rast(file.path(zip_dir, "processed/NO2SURF_AnnualMedian_2019.tif"))
r2020_median <- rast(file.path(zip_dir, "processed/NO2SURF_AnnualMedian_2020.tif"))


# 2 Reihen, 3 Spalten
par(mfrow = c(2, 3), mar = c(4, 4, 3, 2))

# Mean Reihe
plot(r2018_mean, main = "NO2SURF Jahresmittel 2018 (Mean)", col = terrain.colors(20))
plot(r2019_mean, main = "NO2SURF Jahresmittel 2019 (Mean)", col = terrain.colors(20))
plot(r2020_mean, main = "NO2SURF Jahresmittel 2020 (Mean)", col = terrain.colors(20))

# Median Reihe
plot(r2018_median, main = "NO2SURF Jahresmittel 2018 (Median)", col = terrain.colors(20))
plot(r2019_median, main = "NO2SURF Jahresmittel 2019 (Median)", col = terrain.colors(20))
plot(r2020_median, main = "NO2SURF Jahresmittel 2020 (Median)", col = terrain.colors(20))

ext(r2018_median)
