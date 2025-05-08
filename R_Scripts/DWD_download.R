# Pakete installieren und laden
if (!requireNamespace("rdwd", quietly = TRUE)) install.packages("rdwd")
library(rdwd)
library(terra)
# install.packages("viridis")
library(viridis)


# Basisverzeichnis
base_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten"
dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)

# Funktion zum Herunterladen von Rasterdaten (DWD)
download_raster_data <- function(pattern, years, subdir) {
  data("gridIndex")
  gridbase <- "https://opendata.dwd.de/climate_environment/CDC/grids_germany/"
  index_all <- grep(pattern, gridIndex, value = TRUE)
  print(index_all)  # zeigt dir alle Treffer
  index_years <- grep(paste(years, collapse = "|"), index_all, value = TRUE)
  print(index_years)  # zeigt dir, was wirklich übrig bleibt
  target_dir <- file.path(base_dir, subdir)
  dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)
  dataDWD(index_years, base = gridbase, joinbf = TRUE, dir = target_dir)
}

# Daten herunterladen
precip <- download_raster_data("monthly/precipitation", 2022:2024, "Niederschlag/Monatlich")

precip <- download_raster_data("seasonal/precipitation", 2022:2024, "Niederschlag/Saisonal")

precip <- download_raster_data("annual/precipitation", 2022:2024, "Niederschlag/Jaehrlich")


# Plot der Niederschlagsdaten mit der 'viridis' Farbpalette
plot(precip, 
     main = "Jährliche Niederschlagsmenge in mm (2022)", 
     col = turbo(100), 
     zlim = c(min(precip[], na.rm = TRUE), max(precip[], na.rm = TRUE)))




temp_min <- download_raster_data("monthly/air_temperature_min", 2022:2024, "Temperatur/Monatlich")

temp_max <- download_raster_data("monthly/air_temperature_max", 2022:2024, "Temperatur/Monatlich")

temp_mean <- download_raster_data("monthly/air_temperature_mean", 2022:2024, "Temperatur/Monatlich")


temp_min <- download_raster_data("seasonal/air_temperature_min", 2022:2024, "Temperatur/Saisonal")

temp_max <- download_raster_data("seasonal/air_temperature_max", 2022:2024, "Temperatur/Saisonal")

temp_mean <- download_raster_data("seasonal/air_temperature_mean", 2022:2024, "Temperatur/Saisonal")


temp_min <- download_raster_data("annual/air_temperature_min", 2022:2024, "Temperatur/Jaehrlich")

temp_max <- download_raster_data("annual/air_temperature_max", 2022:2024, "Temperatur/Jaehrlich")

temp_mean <- download_raster_data("annual/air_temperature_mean", 2022:2024, "Temperatur/Jaehrlich")

# Plot der Temperaturdaten mit der 'viridis' Farbpalette
plot(temp_mean, 
     main = "Jährliche Durchschnittstemperatur in °C (2022)", 
     col = turbo(100), 
     zlim = c(min(temp_mean[], na.rm = TRUE), max(temp_mean[], na.rm = TRUE)))



drought <- download_raster_data("monthly/drought_index", 2022:2024, "Dürreindex/Monatlich")

drought <- download_raster_data("seasonal/drought_index", 2022:2024, "Dürreindex/Saisonal")

drought <- download_raster_data("annual/drought_index", 2022:2024, "Dürreindex/Jaehrlich")


# Plot mit der 'Turbo' Farbpalette
plot(drought, 
     main = "Jährlicher Dürreindex (2022)", 
     col = turbo(100), 
     zlim = c(min(drought[], na.rm = TRUE), max(drought[], na.rm = TRUE)))


# Funktion zum Herunterladen von UHI-Daten
download_uhi_data <- function(years, months, subdir, var_name, time_res, clc = "1990") {
  dir_path <- file.path(base_dir, "UHI", subdir)
  dir.create(dir_path, recursive = TRUE, showWarnings = FALSE)
  
  for (year in years) {
    for (month in months) {
      file_name <- paste0("uhi-map_v7_clc", clc, "_", var_name, "_", time_res, "_", year, "-", month, "-01.nc")
      url <- paste0(
        "https://opendata.dwd.de/climate_environment/CDC/grids_germany/",
        switch(time_res,
               "p1m" = "monthly/",
               "p3m" = "seasonal/",
               "p1y" = "annual/"),
        "Project_UHI-MAP/", 
        gsub("-", "_", var_name), "/",  # Pfadname anders als Dateiname
        file_name
      )
      destfile <- file.path(dir_path, file_name)
      message("Downloading: ", file_name)
      tryCatch({
        download.file(url, destfile, mode = "wb")
      }, error = function(e) {
        message("Fehler bei: ", file_name, " — ", e$message)
      })
    }
  }
}

# Tropische Nächte (monatlich)
download_uhi_data(2022:2024, sprintf("%02d", 1:12), "Tropische_Naechte/Monatlich", "tropical-nights_diff", "p1m", clc = "2012")


# Tropische Nächte (saisonal)
download_uhi_data(2022:2024, c("03", "06", "09", "12"), "Tropische_Naechte/Saisonal", "tropical-nights_diff", "p3m")


# Tropische Nächte (jährlich)
download_uhi_data(2022:2024, sprintf("%02d", 1:12), "Tropische_Naechte/Jaehrlich", "tropical-nights_diff", "p1y", clc = "2018")


# UHI daymax mean (monatlich)
download_uhi_data(2022:2024, sprintf("%02d", 1:12), "UHI_daymax_mean", "uhi_daymax-mean", "p1m")


library(terra)
library(viridis)

# Pfad zur Jahresdatei für 2022 (Tropische Nächte, CLC 2018)
file_2022 <- file.path(base_dir, "UHI", "Tropische_Naechte/Jaehrlich", 
                       "uhi-map_v7_clc2018_tropical-nights_diff_p1y_2022-01-01.nc")

# Laden als SpatRaster
tropennacht_2022 <- rast(file_2022)
plot(tropennacht_2022, 
     main = "Jährliche Tropennächte (2022)", 
     col = turbo(100),
     zlim = c(min(tropennacht_2022[], na.rm = TRUE), 
              max(tropennacht_2022[], na.rm = TRUE)))

