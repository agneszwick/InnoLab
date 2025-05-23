library(raster)
library(sf)
library(dplyr)
library(stringr)
library(tools)
library(R.utils)


build_file_pattern <- function(var_name, target_year) {
  patterns <- list(
    Lufttemperatur_min  = paste0("grids_germany_annual_air_temp_min_", target_year, "[0-9]{2}\\.asc(\\.gz)?$"),
    Lufttemperatur_max  = paste0("grids_germany_annual_air_temp_max_", target_year, "[0-9]{2}\\.asc(\\.gz)?$"),
    Lufttemperatur_mean = paste0("grids_germany_annual_air_temp_mean_", target_year, "[0-9]{2}\\.asc(\\.gz)?$"),
    Dürreindex         = paste0("grids_germany_annual_drought_index_", target_year, "[0-9]{2}\\.asc(\\.gz)?$"),
    Sonnenscheindauer  = paste0("grids_germany_annual_sunshine_duration_", target_year, "[0-9]{2}\\.asc(\\.gz)?$"),
    Hitzetage          = paste0("grids_germany_annual_hot_days_", target_year, "_[0-9]{2}\\.asc(\\.gz)?$"),
    Niederschlag       = paste0("grids_germany_annual_precipitation_", target_year, "[0-9]{2}\\.asc(\\.gz)?$")
  )
  
  pattern <- patterns[[var_name]]
  if (is.null(pattern)) stop("❌ Kein gültiges Muster für Variable: ", var_name)
  return(pattern)
}


process_data <- function(base_dir, var_name, zeitrahmen, shp_path, target_year) {
  # Pfad zur Variable + Zeitrahmen
  asc_file_path <- file.path(base_dir, zeitrahmen, var_name)
  message("ASC-Dateipfad: ", asc_file_path)
  
  # Kreise laden – nur GF == "4"
  kreise <- st_read(shp_path) %>%
    filter(GF == "4") %>%
    st_transform(31467) %>%
    mutate(ID = row_number())
  
  base_df <- kreise %>%
    dplyr::select(ID, ARS, AGS, GEN, BEZ, GF, SDV_ARS) %>%
    sf::st_set_geometry(NULL)
  
  pattern <- build_file_pattern(var_name, target_year)
  asc_files <- list.files(asc_file_path, pattern = pattern, full.names = TRUE)
  
  message("✅ ASC-Dateien gefunden: ", length(asc_files))
  
  # Kürzel für Zeitrahmen
  zeitrahmen_kurz <- switch(
    zeitrahmen,
    "Jaehrlich" = "J",
    "Monatlich" = "M",
    "Saisonal" = "S",
    stop("Unbekannter Zeitrahmen: ", zeitrahmen)
  )
  
  # Output-Verzeichnis und Dateiname
  out_dir <- file.path(base_dir, "Kreisebene")
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out_csv <- file.path(out_dir, paste0("DWD_", var_name, "_", zeitrahmen_kurz, "_", target_year, ".csv"))
  
  # Ergebnis-Datenrahmen vorbereiten
  final_df <- base_df
  
  for (file in asc_files) {
    fn <- basename(file)
    
    # Entpacken nur, wenn Datei .gz ist
    if (grepl("\\.gz$", file)) {
      unzipped_file <- sub("\\.gz$", "", file)
      if (!file.exists(unzipped_file)) {
        R.utils::gunzip(file, destname = unzipped_file, overwrite = FALSE)
      }
    } else {
      unzipped_file <- file  # bereits entpackt
    }
    
    # Raster laden
    r <- raster(unzipped_file)
    
    # Falls Variable mit "Lufttemperatur" beginnt, Werte skalieren
    if (startsWith(var_name, "Lufttemperatur")) {
      r <- r / 10
    }
    
    # Projektion setzen
    crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
                   +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
                   +units=m +no_defs")
    
    r2 <- mask(crop(r, extent(kreise)), kreise)
    
    # Prefix erzeugen
    prefix <- paste0(var_name, "_", zeitrahmen_kurz, "_", target_year)
    
    # Werte extrahieren
    stats <- raster::extract(r2, kreise, fun = function(x, ...) {
      x <- x[!is.na(x)]
      if (length(x) == 0) return(c(mean = NA, median = NA))
      c(mean = mean(x), median = median(x))
    }, df = TRUE)
    
    names(stats)[2:3] <- paste0(prefix, c("_mean", "_median"))
    
    final_df <- left_join(final_df, stats, by = "ID")
    message("✅ Fertig verarbeitet: ", fn)
  }
  
  # Export
  message("📁 Schreibe CSV nach: ", out_csv)
  write.csv(final_df, out_csv, row.names = FALSE)
  message("✅ CSV geschrieben.")
}


var_name = "Lufttemperatur_min"
zeitrahmen = "Jaehrlich"
target_year <- 2023

process_data(
  base_dir = "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten", 
  zeitrahmen = zeitrahmen,
  var_name = var_name,
  shp_path = "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp",
  target_year = target_year
)

