# # Pakete installieren und laden
# if (!requireNamespace("rdwd", quietly = TRUE)) install.packages("rdwd")
# library(rdwd)
# library(terra)
# library(viridis)

library(httr)

base_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Jaehrlich"

variables <- list(
  air_temperature_min = "Lufttemperatur_min",
  air_temperature_max = "Lufttemperatur_max",
  air_temperature_mean = "Lufttemperatur_mean",
  drought_index = "Dürreindex",
  sunshine_duration = "Sonnenscheindauer",
  hot_days = "Hitzetage",
  precipitation = "Niederschlag"
)


download_annual_data <- function(var_eng, var_de) {
  url <- paste0("https://opendata.dwd.de/climate_environment/CDC/grids_germany/annual/", var_eng, "/")
  target_dir <- file.path(base_dir, var_de)
  dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)
  
  res <- httr::GET(url)
  if (res$status_code != 200) {
    message("Fehler beim Zugriff auf ", url)
    return(NULL)
  }
  content <- httr::content(res, as = "text")
  
  # Regex für Dateinamen anpassen
  if (var_eng %in% c("air_temperature_min", "air_temperature_max", "air_temperature_mean")) {
    suffix <- switch(var_eng,
                     air_temperature_min = "min",
                     air_temperature_max = "max",
                     air_temperature_mean = "mean")
    pattern <- paste0("grids_germany_annual_air_temp_", suffix, "_[0-9]{6}\\.asc\\.gz")
  } else if (var_eng == "hot_days") {
    pattern <- paste0("grids_germany_annual_", var_eng, "_[0-9]{4}_[0-9]{2}\\.asc\\.gz")
  } else {
    pattern <- paste0("grids_germany_annual_", var_eng, "_[0-9]{6}\\.asc\\.gz")
  }
  
  files <- regmatches(content, gregexpr(pattern, content))[[1]]
  
  message(length(files), " Dateien gefunden für ", var_de)
  
  for (file_name in files) {
    destfile <- file.path(target_dir, file_name)
    download_url <- paste0(url, file_name)
    
    if (!file.exists(destfile)) {
      message("Lade herunter: ", file_name)
      tryCatch({
        download.file(download_url, destfile, mode = "wb")
      }, error = function(e) {
        message("Fehler bei Datei ", file_name, ": ", e$message)
      })
    } else {
      message("Datei existiert bereits: ", file_name)
    }
  }
}

for (var_eng in names(variables)) {
  var_de <- variables[[var_eng]]
  message("Starte Download für: ", var_de)
  download_annual_data(var_eng, var_de)
}






#  UHI nc. files herunterladen ------------------------------------------------

# Funktion zum Herunterladen von UHI-Daten
download_uhi_data <- function(years, months, subdir, var_name, time_res, clc = "1990") {
  dir_path <- file.path(base_dir, subdir)
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
download_uhi_data(2023:2024, sprintf("%02d", 1:12), "Tropische_Naechte/Monatlich", "tropical-nights_diff", "p1m", clc = "2012")


# Tropische Nächte (saisonal)
download_uhi_data(2023, c("03", "06", "09", "12"), "Tropische_Naechte/Saisonal", "tropical-nights_diff", "p3m")


# Tropische Nächte (jährlich)
download_uhi_data(1990:2024, "01", "Tropische_Naechte", "tropical-nights_diff", "p1y", clc = "2018")



