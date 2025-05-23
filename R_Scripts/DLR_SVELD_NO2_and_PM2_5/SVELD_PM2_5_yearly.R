library(terra)
library(fs)

# Ordner mit den ZIP-Dateien und Entpacken
zip_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DLR_S_VELD_NO2_PM2_5/MODIS_SLSTR_PM25SURF"
zip_files <- dir_ls(zip_dir, glob = "*.zip")

for (zip_file in zip_files) {
  unzip(zip_file, exdir = zip_dir)
  cat("Entpackt:", zip_file, "\n")
}

# Variable im NetCDF
pm25_var <- "mass_concentration_of_pm2p5_ambient_aerosol_particles_in_air"
years <- c("2018", "2019")

for (year in years) {
  nc_files <- dir_ls(zip_dir, regexp = paste0(year, ".*\\.nc$"))
  
  rasters <- list()
  
  for (file in nc_files) {
    r_all <- rast(file)
    # Mittelwert über Variable pro Datei (Layer)
    r <- mean(r_all[[pm25_var]], na.rm = TRUE)
    rasters[[length(rasters) + 1]] <- r
    
    rm(r_all)
    gc()
  }
  
  if (length(rasters) == 0) {
    warning("Keine Dateien für Jahr ", year)
    next
  }
  
  r_stack <- rast(rasters)
  
  # Mean und Median berechnen
  r_year_mean <- mean(r_stack, na.rm = TRUE)
  r_year_median <- app(r_stack, median, na.rm = TRUE)
  
  # Speichern
  out_mean <- file.path(zip_dir, paste0("PM25_AnnualMean_", year, ".tif"))
  out_median <- file.path(zip_dir, paste0("PM25_AnnualMedian_", year, ".tif"))
  
  writeRaster(r_year_mean, out_mean, overwrite = TRUE)
  writeRaster(r_year_median, out_median, overwrite = TRUE)
  
  message("Jahresmittel gespeichert für ", year, " unter ", out_mean)
  message("Jahresmedian gespeichert für ", year, " unter ", out_median)
  
  rm(r_stack, r_year_mean, r_year_median, rasters)
  gc()
}

# Raster laden und plotten
r2018_mean <- rast(file.path(zip_dir, "PM25_AnnualMean_2018.tif"))
r2019_mean <- rast(file.path(zip_dir, "PM25_AnnualMean_2019.tif"))
r2018_median <- rast(file.path(zip_dir, "PM25_AnnualMedian_2018.tif"))
r2019_median <- rast(file.path(zip_dir, "PM25_AnnualMedian_2019.tif"))

# Plot Mean nebeneinander
par(mfrow = c(1, 2))
plot(r2018_mean, main = "PM2.5 Jahresmittel 2018 (Mean)", col = terrain.colors(20))
plot(r2019_mean, main = "PM2.5 Jahresmittel 2019 (Mean)", col = terrain.colors(20))

# Plot Median nebeneinander
par(mfrow = c(1, 2))
plot(r2018_median, main = "PM2.5 Jahresmittel 2018 (Median)", col = terrain.colors(20))
plot(r2019_median, main = "PM2.5 Jahresmittel 2019 (Median)", col = terrain.colors(20))
