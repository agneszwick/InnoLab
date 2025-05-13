# Pakete installieren und laden
if (!requireNamespace("rdwd", quietly = TRUE)) install.packages("rdwd")
library(rdwd)
library(terra)
library(viridis)

# Basisverzeichnis für Downloads
base_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten"
dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)

# Funktion zum Herunterladen von Rasterdaten (DWD)
download_raster_data <- function(pattern, years, subdir) {
  data("gridIndex")
  gridbase <- "https://opendata.dwd.de/climate_environment/CDC/grids_germany/"
  
  # Finde alle passenden Dateien im DWD-Index
  index_all <- grep(pattern, gridIndex, value = TRUE)
  index_years <- grep(paste(years, collapse = "|"), index_all, value = TRUE)
  
  message("🔍 ", pattern, ": ", length(index_years), " Dateien gefunden")
  
  # Zielverzeichnis erstellen
  target_dir <- file.path(base_dir, subdir)
  dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)
  
  # Daten herunterladen
  dataDWD(index_years, base = gridbase, joinbf = TRUE, dir = target_dir)
}

# Variablen und zugehörige deutsche Hauptordner
variables <- list(
  # precipitation = "Niederschlag",
  # air_temperature_min = "Lufttemperatur_min",
  air_temperature_max = "Lufttemperatur_max",
  air_temperature_mean = "Lufttemperatur_mean"
  # drought_index = "Dürreindex",
  # sunshine_duration = "Sonnenscheindauer",
  # hot_days = "Hitzetage"
)

# Deutsche Bezeichnungen für Zeitauflösungen
resolutions_de <- c(
  monthly = "Monatlich",
  seasonal = "Saisonal",
  annual = "Jaehrlich"
)

# Zeitraum
years <- 2020:2024

# Hauptschleife: Lade alle gewünschten Datensätze herunter
for (var in names(variables)) {
  for (res in names(resolutions_de)) {
    
    # Sonderfall: hot_days gibt es nur jährlich
    if (var == "hot_days" && res != "annual") next
    
    pattern <- paste0(res, "/", var)
    subdir <- file.path(variables[[var]], resolutions_de[[res]])
    
    message("⬇️ Lade Daten für: ", var, " (", res, ") → ", subdir)
    download_raster_data(pattern, years, subdir)
  }
}


#  UHI nc. files herunterladen ------------------------------------------------

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
download_uhi_data(2020:2024, sprintf("%02d", 1:12), "Tropische_Naechte/Jaehrlich", "tropical-nights_diff", "p1y", clc = "2018")


# UHI daymax mean (monatlich)
download_uhi_data(2022:2024, sprintf("%02d", 1:12), "UHI_daymax_mean", "uhi_daymax-mean", "p1m")

