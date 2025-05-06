# Pakete installieren und laden
if (!requireNamespace("rdwd", quietly = TRUE)) install.packages("rdwd")
library(rdwd)
library(terra)

# Basisverzeichnis
base_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten"
dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)

# Funktion zum Herunterladen von Rasterdaten (DWD)
download_raster_data <- function(pattern, years, subdir) {
  data("gridIndex")
  gridbase <- "https://opendata.dwd.de/climate_environment/CDC/grids_germany/"
  index <- grep(pattern, gridIndex, value = TRUE)
  index <- grep(paste(years, collapse = "|"), index, value = TRUE)
  target_dir <- file.path(base_dir, subdir)
  dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)
  dataDWD(index, base = gridbase, joinbf = TRUE, dir = target_dir)
}

# Daten herunterladen
precip <- download_raster_data("monthly/precipitation", 2022:2024, "Niederschlag/Monatlich")

precip <- download_raster_data("seasonal/precipitation", 2022:2024, "Niederschlag/Saisonal")

# plotRadar(precip[[1]], proj = "seasonal", main = names(precip)[1])


temp <- download_raster_data("monthly/air_temperature_min", 2022:2024, "Temperatur/Monatlich")

temp <- download_raster_data("monthly/air_temperature_max", 2022:2024, "Temperatur/Monatlich")

temp <- download_raster_data("monthly/air_temperature_mean", 2022:2024, "Temperatur/Monatlich")

temp <- download_raster_data("seasonal/air_temperature_min", 2022:2024, "Temperatur/Saisonal")

temp <- download_raster_data("seasonal/air_temperature_max", 2022:2024, "Temperatur/Saisonal")

temp <- download_raster_data("seasonal/air_temperature_mean", 2022:2024, "Temperatur/Saisonal")


drought <- download_raster_data("monthly/drought_index", 2022:2024, "Dürreindex/Monatlich")

drought <- download_raster_data("seasonal/drought_index", 2022:2024, "Dürreindex/Saisonal")




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

# UHI daymax mean (monatlich)
download_uhi_data(2022:2024, sprintf("%02d", 1:12), "UHI_daymax_mean", "uhi_daymax-mean", "p1m")

# Tropische Nächte (saisonal)
download_uhi_data(2022:2024, c("03", "06", "09", "12"), "Tropische_Naechte/Saisonal", "tropical-nights_diff", "p3m")
