library(raster)
library(sf)
library(dplyr)
library(tools)
library(raster)
library(sf)
library(dplyr)

var_name <- "Niederschlag"
zeitrahmen <- "Jaehrlich" # oder "Monatlich", "Saisonal"

process_data <- function(base_dir, var_name, zeitrahmen, shp_path) {
  # Dynamischer Pfad zum ASC-Verzeichnis
  asc_file_path <- file.path(base_dir, var_name, zeitrahmen)
  message("ASC-Dateipfad: ", asc_file_path)
  
  # Kreise laden
  kreise <- st_read(shp_path) %>%
    st_transform(31467) %>%
    mutate(ID = row_number())
  
  base_df <- kreise %>%
    dplyr::select(ID, ARS, AGS, GEN, BEZ) %>%
    st_set_geometry(NULL)
  
  # ASC-Dateien einlesen
  asc_files <- list.files(asc_file_path, pattern = "\\.asc$", full.names = TRUE)
  
  # Jahre extrahieren
  years <- gsub(".*_(20[0-9]{2})[0-9]{2}\\.asc$", "\\1", basename(asc_files))
  years <- years[!is.na(years)]
  valid_years <- years[years %in% sprintf("%04d", 2000:2099)]
  message("Jahre extrahiert: ", paste(valid_years, collapse = ", "))
  
  if (length(valid_years) == 0) {
    stop("Es wurden keine gültigen Jahre extrahiert!")
  }
  
  min_year <- min(as.numeric(valid_years))
  max_year <- max(as.numeric(valid_years))
  
  # Kürzel für Zeitrahmen
  zeitrahmen_kurz <- switch(
    zeitrahmen,
    "Jaehrlich" = "J",
    "Monatlich" = "M",
    "Saisonal" = "S",
    stop("Unbekannter Zeitrahmen: ", zeitrahmen)
  )
  
  # Output-Pfad & -Dateiname
  out_dir <- file.path(base_dir, "Kreisebene")
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = TRUE)
  }
  out_csv <- file.path(out_dir, paste0(var_name, "_", zeitrahmen_kurz, "_", min_year, "_", max_year, ".csv"))
  
  # Schleife über ASC-Dateien
  final_df <- base_df
  for (file in asc_files) {
    fn <- basename(file)
    r <- raster(file)
    crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
                   +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
                   +units=m +no_defs")
    r2 <- mask(crop(r, extent(kreise)), kreise)
    
    # Zeitstempel für Spaltenname generieren
    if (zeitrahmen == "Jaehrlich") {
      jahr <- sub(".*_(20[0-9]{2})[0-9]{2}\\.asc$", "\\1", fn)
      prefix <- paste0(var_name, "_J_", jahr)
      
    } else if (zeitrahmen == "Monatlich") {
      date_string <- gsub(".*_(\\d{6})\\.asc", "\\1", fn)
      jahr <- substr(date_string, 1, 4)
      monat <- substr(date_string, 5, 6)
      prefix <- paste0(var_name, "_M_", jahr, "_", monat)
      
    } else if (zeitrahmen == "Saisonal") {
      stem <- tools::file_path_sans_ext(fn)
      saison_code <- gsub(".*_(DJF|MAM|JJA|SON)_.*", "\\1", stem)
      jahr <- substr(gsub(".*_(\\d{6})\\.asc", "\\1", fn), 1, 4)
      prefix <- paste0(var_name, "_S_", jahr, "_", saison_code)
    }
    
    # Rasterwerte extrahieren
    stats <- raster::extract(r2, kreise, fun = function(x, ...) {
      x <- x[!is.na(x)]
      if (length(x) == 0) return(c(mean = NA, median = NA))
      c(mean = mean(x), median = median(x))
    }, df = TRUE)
    
    names(stats)[2:3] <- paste0(prefix, c("_mean", "_median"))
    final_df <- left_join(final_df, stats, by = "ID")
    message("Fertig: ", prefix)
  }
  
  # CSV exportieren
  message("Ausgabepfad CSV: ", out_csv)
  write.csv(final_df, out_csv, row.names = FALSE)
  message("CSV geschrieben nach: ", out_csv)
}


process_data(
  base_dir = "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten", 
  var_name,
  zeitrahmen,
  shp_path = "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
)

















## -- OLD SCRIPT -----------------------------------


# 
# process_data <- function(base_dir, var_name, zeitrahmen, shp_path) {
#   # Dynamischer Pfad zum ASC-Verzeichnis
#   asc_file_path <- file.path(base_dir, var_name, zeitrahmen)
#   message("ASC-Dateipfad: ", asc_file_path)
#   
#   # 1. Kreise laden
#   kreise <- st_read(shp_path) %>%
#     st_transform(31467) %>%
#     mutate(ID = row_number())
#   
#   # Basis-Dataframe ohne Geometrie
#   base_df <- kreise %>%
#     select(ID, ARS, AGS, GEN, BEZ) %>%
#     st_set_geometry(NULL)
#   
#   # 2. ASC-Dateien einlesen (aus dem dynamisch erstellten Pfad)
#   asc_files <- list.files(asc_file_path, pattern = "\\.asc$", full.names = TRUE)
#   
#   # 3. Jahre und ggf. Saison aus Dateinamen extrahieren (nur gültige Jahre extrahieren)
#   years <- gsub(".*_(20[0-9]{2})[0-9]{2}\\.asc$", "\\1", basename(asc_files))
#   
#   # Nur Jahre extrahieren, die wirklich existieren und gültig sind
#   years <- years[!is.na(years)]  # Ungültige Jahre entfernen
#   
#   valid_years <- years[years %in% sprintf("%04d", 2000:2099)]  # Filtert Jahre, die von 2000 bis 2099 reichen
#   message("Jahre extrahiert: ", paste(valid_years, collapse = ", "))
#   
#   if (length(valid_years) == 0) {
#     stop("Es wurden keine gültigen Jahre extrahiert!")
#   }
#   
#   min_year <- min(as.numeric(valid_years))
#   max_year <- max(as.numeric(valid_years))
#   
#   # Dynamischer Output-Pfad erstellen (direkt im "Kreisebene" Ordner)
#   out_dir <- file.path(dirname(asc_file_path), "Kreisebene")
#   if (!dir.exists(out_dir)) {
#     tryCatch({
#       dir.create(out_dir, recursive = TRUE)
#     }, error = function(e) {
#       message("Fehler beim Erstellen des Zielverzeichnisses: ", e$message)
#     })
#   }
#   
#   # Dynamischer Output-Dateiname (direkt im "Kreisebene" Ordner)
#   out_csv <- file.path(out_dir, paste0(var_name, "_", min_year, "_", max_year, ".csv"))
#   
#   # 4. Schleife über Dateien und Berechnungen
#   final_df <- base_df
#   for (file in asc_files) {
#     # Dateiname analysieren
#     fn <- basename(file)
#     jahr <- sub(".*_(20[0-9]{2})[0-9]{2}\\.asc$", "\\1", fn)
#     
#     # Spaltennamen vorbereiten
#     spalten_prefix <- paste0(var_name, "_", jahr)
#     
#     # Raster laden & CRS setzen
#     r <- raster(file)
#     crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
#                    +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
#                    +units=m +no_defs")
#     
#     # Zuschneiden und Berechnung durchführen
#     r2 <- mask(crop(r, extent(kreise)), kreise)
#     
#     # Saison und Jahr extrahieren (falls vorhanden)
#     saison_code <- gsub(".*_(DJF|MAM|JJA|SON)_.*", "\\1", fn)  # Extrahiert Saison wie DJF, MAM etc.
#     
#     # Statistiken berechnen (mean & median) mit Funktionsaufruf
#     stats <- raster::extract(r2, kreise, fun = function(x, ...) {
#       x <- x[!is.na(x)]  # Entfernt NA-Werte
#       if(length(x) == 0) return(c(mean = NA, median = NA))  # Wenn keine Werte vorhanden, NA zurückgeben
#       c(mean = mean(x), median = median(x))  # Mittelwert und Median berechnen
#     }, df = TRUE)
#     
#     # Spalten umbenennen und Saison hinzufügen
#     names(stats)[2:3] <- paste0(spalten_prefix, c("_mean", "_median"))
#     
#     # Join mit final_df
#     final_df <- left_join(final_df, stats, by = "ID")
#     
#     message("Fertig: ", spalten_prefix)
#   }
#   
#   # 5. CSV schreiben
#   message("Ausgabepfad CSV: ", out_csv)
#   write.csv(final_df, out_csv, row.names = FALSE)
#   message("CSV geschrieben nach: ", out_csv)
# }
# 
# # Beispielaufruf: Lufttemperatur_max (jährlich)
# var_name <- "Dürreindex"  # Beispielvariable
# zeitrahmen <- "Jaehrlich"  # Beispielzeitrahmen
# 
# base_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten"  # Basisverzeichnis für alle Daten
# shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
# process_data(base_dir, var_name, zeitrahmen, shp_path)





# library(raster)
# library(sf)
# library(dplyr)
# library(tools)
# 
# 
# ## Temperatur (Monatlich) ---------------------------------
# 
# # Pfade
# asc_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Lufttemperatur_max/Monatlich"
# shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
# out_csv <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/Lufttemperatur_max/Monatlich/Lufttemperatur_max_M_2020_2024" %>%
#   gsub("\\s+","",.)
# 
# # 2. Verzeichnis extrahieren
# out_dir <- dirname(out_csv)
# 
# # 3. Verzeichnis erstellen (falls nicht vorhanden)
# dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
# 
# 
# # Shapefile laden
# kreise <- st_read(shp_path) %>%
#   st_transform(31467) %>%
#   mutate(ID = row_number())
# 
# # Basisdaten ohne Geometrie
# base_df <- kreise
# sf::st_geometry(base_df) <- NULL
# base_df <- base_df[, c("ID", "ARS", "AGS", "GEN", "BEZ")]
# 
# # ASC-Dateien auflisten
# asc_files <- list.files(asc_dir, pattern = "\\.asc$", full.names = TRUE)
# 
# # Ordnername extrahieren → z. B. "Lufttemperatur_max"
# ordnername <- basename(dirname(asc_dir))
# 
# # Ausgabe-DF
# final_df <- base_df
# 
# for (file in asc_files) {
#   r <- raster(file)
#   
#   # Koordinatensystem setzen
#   crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
#                  +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
#                  +units=m +no_defs")
#   
#   r2 <- mask(crop(r, extent(kreise)), kreise)
#   
#   # Jahr & Monat extrahieren
#   date_string <- gsub(".*_(\\d{6})\\.asc", "\\1", basename(file))  # "202211"
#   jahr <- substr(date_string, 1, 4)
#   monat <- substr(date_string, 5, 6)
#   
#   # Spaltennamen zusammenbauen
#   prefix <- paste0(ordnername, "_M_", jahr, "_", monat)
#   
#   stats <- extract(r2, kreise, fun = function(x, ...) {
#     x <- x[!is.na(x)]
#     if(length(x) == 0) return(c(mean = NA, median = NA))
#     c(mean = mean(x), median = median(x))
#   }, df = TRUE)
#   
#   names(stats)[2:3] <- paste0(prefix, c("_mean", "_median"))
#   
#   final_df <- left_join(final_df, stats, by = "ID")
#   message("Fertig: ", prefix)
# }
# 
# 
# # 
# # # 4. Als CSV speichern
# 
# write.csv(final_df, out_csv, row.names=FALSE)
# message("fertig – CSV: ", out_csv)
# 
# 
# 
# ## Niederschlag (Monatlich) ---------------------------------
# 
# # === 1. Konfiguration ===
# 
# asc_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Niederschlag/Monatlich"
# shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
# out_csv <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/Niederschlag/Monatlich/Niederschlag_M_2020_2024" %>%
#   gsub("\\s+","",.)
# 
# # 2. Verzeichnis extrahieren
# out_dir <- dirname(out_csv)
# 
# # 3. Verzeichnis erstellen (falls nicht vorhanden)
# dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
# 
# 
# # === 2. Kreise laden ===
# 
# kreise <- st_read(shp_path) %>%
#   st_transform(31467) %>%
#   mutate(ID = row_number())
# 
# # Basis-Dataframe (ohne Geometrie)
# base_df <- kreise
# sf::st_geometry(base_df) <- NULL
# base_df <- base_df[, c("ID", "ARS", "AGS", "GEN", "BEZ")]
# 
# # === 3. ASC-Dateien ===
# 
# asc_files <- list.files(asc_dir, pattern = "\\.asc$", full.names = TRUE)
# 
# # Ordnername ermitteln → wird Bestandteil des Spaltennamens
# ordnername <- basename(dirname(asc_dir))  # "Niederschlag"
# 
# # Finales Ergebnis-DataFrame
# final_df <- base_df
# 
# # === 4. Loop über alle Dateien ===
# 
# for (file in asc_files) {
#   r <- raster(file)
#   
#   # Koordinatensystem setzen
#   crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
#                  +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
#                  +units=m +no_defs")
#   
#   r2 <- mask(crop(r, extent(kreise)), kreise)
#   
#   # Datum aus Dateinamen extrahieren
#   date_string <- gsub(".*_(\\d{6})\\.asc", "\\1", basename(file))  # z.B. "202101"
#   jahr <- substr(date_string, 1, 4)
#   monat <- substr(date_string, 5, 6)
#   
#   # Spaltennamen automatisch erstellen
#   prefix <- paste0(ordnername, "_M_", jahr, "_", monat)
#   
#   # Werte extrahieren
#   stats <- extract(r2, kreise, fun = function(x, ...) {
#     x <- x[!is.na(x)]
#     if(length(x) == 0) return(c(mean = NA, median = NA))
#     c(mean = mean(x), median = median(x))
#   }, df = TRUE)
#   
#   # Spaltennamen setzen
#   names(stats)[2:3] <- paste0(prefix, c("_mean", "_median"))
#   
#   # Anhängen an final_df
#   final_df <- left_join(final_df, stats, by = "ID")
#   message("Fertig: ", prefix)
# }
# 
# 
# # # 4. Als CSV speichern
# write.csv(final_df, out_csv, row.names=FALSE)
# message("fertig – CSV: ", out_csv)
# 
# 
# 
# 
# ## Temperatur (Saisonal) ---------------------------------
# library(raster)
# library(sf)
# library(dplyr)
# 
# # === 1. Konfiguration ===
# 
# asc_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Lufttemperatur_max/Saisonal"
# shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
# 
# # 1. Pfad definieren & Leerzeichen entfernen
# out_csv <- gsub("\\s+", "", "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/Lufttemperatur_max/Saisonal/Lufttemperatur_max_S_2020_2024")
# 
# # 2. Verzeichnis extrahieren
# out_dir <- dirname(out_csv)
# 
# # 3. Verzeichnis erstellen (falls nicht vorhanden)
# dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
# 
# # === 2. Kreise laden ===
# 
# kreise <- st_read(shp_path) %>%
#   st_transform(31467) %>%
#   mutate(ID = row_number())
# 
# # Basis-Dataframe ohne Geometrie
# base_df <- kreise
# sf::st_geometry(base_df) <- NULL
# base_df <- base_df[, c("ID", "ARS", "AGS", "GEN", "BEZ")]
# 
# # === 3. ASC-Dateien laden ===
# 
# asc_files <- list.files(asc_dir, pattern = "\\.asc$", full.names = TRUE)
# ordnername <- basename(dirname(asc_dir))  # z.B. "Lufttemperatur_max"
# 
# # === 4. Schleife über Dateien ===
# 
# final_df <- base_df
# 
# for (file in asc_files) {
#   r <- raster(file)
#   
#   # CRS setzen
#   crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
#                  +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
#                  +units=m +no_defs")
#   
#   r2 <- mask(crop(r, extent(kreise)), kreise)
#   
#   # Saison + Jahr extrahieren
#   stem <- tools::file_path_sans_ext(basename(file))
#   saison_code <- gsub(".*_(DJF|MAM|JJA|SON)_.*", "\\1", stem)  # z.B. "DJF"
#   jahr <- gsub(".*_(\\d{6})\\.asc", "\\1", basename(file))
#   jahr <- substr(jahr, 1, 4)
#   
#   prefix <- paste0(ordnername, "_S_", jahr, "_", saison_code)
#   
#   stats <- extract(r2, kreise, fun = function(x, ...) {
#     x <- x[!is.na(x)]
#     if (length(x) == 0) return(c(mean = NA, median = NA))
#     c(mean = mean(x), median = median(x))
#   }, df = TRUE)
#   
#   names(stats)[2:3] <- paste0(prefix, c("_mean", "_median"))
#   
#   final_df <- left_join(final_df, stats, by = "ID")
#   message("Fertig: ", prefix)
# }
# 
# 
# 
# 
# 
# 
# ## ---- Niederschlag (Saisonal) ---------------------------------
# 
# library(raster)
# library(sf)
# library(dplyr)
# library(tools)
# 
# # 0. Konfiguration --------------------------------------------------------
# asc_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Niederschlag/Saisonal"
# shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
# out_csv <- gsub("\\s+", "", "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/Niederschlag/Saisonal/Niederschlag_S_2020_2024")
# 
# # Ordner erstellen, falls nicht vorhanden
# out_dir <- dirname(out_csv)
# dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
# 
# 
# # 1. Kreise laden ---------------------------------------------------------
# kreise <- st_read(shp_path) %>%
#   st_transform(31467) %>%
#   mutate(ID = row_number())
# 
# # Attributtabelle ohne Geometrie
# base_df <- kreise %>%
#   select(ID, ARS, AGS, GEN, BEZ) %>%
#   st_set_geometry(NULL)
# 
# # 2. ASC-Dateien einlesen -------------------------------------------------
# asc_files <- list.files(asc_dir, pattern = "\\.asc$", full.names = TRUE)
# 
# # 3. Loop über Dateien -----------------------------------------------------
# final_df <- base_df
# for(file in asc_files) {
#   # Dateiname analysieren
#   fn <- basename(file)  # z.B. "seasonal_precipitation_13_MAM_...202113.asc"
#   year <- sub(".*_(20[0-9]{2})([0-9]{2})\\.asc$", "\\1", fn)
#   season_code <- sub(".*_(DJF|MAM|JJA|SON)_.*", "\\1", fn)
#   
#   # Spaltennamen vorbereiten
#   var_name <- "Niederschlag"
#   spalten_prefix <- paste0(var_name, "_S_", year, "_", season_code)
#   
#   # Raster laden & CRS setzen
#   r <- raster(file)
#   crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
#                  +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
#                  +units=m +no_defs")
#   
#   # Zuschneiden
#   r2 <- mask(crop(r, extent(kreise)), kreise)
#   
#   # Statistik berechnen (mean & median)
#   stats <- extract(r2, kreise, fun = function(x, ...) {
#     x <- x[!is.na(x)]
#     if(length(x) == 0) return(c(mean = NA, median = NA))
#     c(mean = mean(x), median = median(x))
#   }, df = TRUE)
#   
#   # Spalten umbenennen
#   names(stats)[2:3] <- paste0(spalten_prefix, c("_mean", "_median"))
#   
#   # Join mit final_df
#   final_df <- left_join(final_df, stats, by = "ID")
#   
#   message("Fertig: ", spalten_prefix)
# }
# 
# # 4. CSV schreiben --------------------------------------------------------
# write.csv(final_df, paste0(out_csv, ".csv"), row.names = FALSE)
# message("CSV geschrieben nach: ", paste0(out_csv, ".csv"))
# 
# 
# ## Temperatur (jährlich) ---------------------------------
# 
# # 0. Konfiguration --------------------------------------------------------
# asc_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Lufttemperatur_max/Jaehrlich"
# shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
# out_csv <- gsub("\\s+", "", "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/Lufttemperatur_max/Jaehrlich/Lufttemperatur_max_J_2020_2024")
# 
# # Zielverzeichnis anlegen, falls es nicht existiert
# out_dir <- dirname(out_csv)
# dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
# 
# # 1. Kreise laden ---------------------------------------------------------
# kreise <- st_read(shp_path) %>%
#   st_transform(31467) %>%
#   mutate(ID = row_number())
# 
# # Attributtabelle ohne Geometrie
# base_df <- kreise %>%
#   select(ID, ARS, AGS, GEN, BEZ) %>%
#   st_set_geometry(NULL)
# 
# # 2. ASC-Dateien einlesen -------------------------------------------------
# asc_files <- list.files(asc_dir, pattern = "\\.asc$", full.names = TRUE)
# 
# # 3. Loop über Dateien -----------------------------------------------------
# final_df <- base_df
# for(file in asc_files) {
#   # Dateiname analysieren
#   fn <- basename(file)  # z.B. "annual_air_temperature_max_grids_germany_annual_air_temp_max_202017.asc"
#   year <- sub(".*_(20[0-9]{2})[0-9]{2}\\.asc$", "\\1", fn)
#   
#   # Spaltennamen vorbereiten
#   var_name <- "Lufttemperatur_max"
#   spalten_prefix <- paste0(var_name, "_J_", year)
#   
#   # Raster laden & CRS setzen
#   r <- raster(file)
#   crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
#                  +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
#                  +units=m +no_defs")
#   
#   # r <- r / 10  # aktivieren, falls Daten skaliert sind
#   
#   # Zuschneiden
#   r2 <- mask(crop(r, extent(kreise)), kreise)
#   
#   # Statistik berechnen (mean & median)
#   stats <- extract(r2, kreise, fun = function(x, ...) {
#     x <- x[!is.na(x)]
#     if(length(x) == 0) return(c(mean = NA, median = NA))
#     c(mean = mean(x), median = median(x))
#   }, df = TRUE)
#   
#   # Spalten umbenennen
#   names(stats)[2:3] <- paste0(spalten_prefix, c("_mean", "_median"))
#   
#   # Join mit final_df
#   final_df <- left_join(final_df, stats, by = "ID")
#   
#   message("Fertig: ", spalten_prefix)
# }
# 
# # 4. CSV schreiben --------------------------------------------------------
# write.csv(final_df, paste0(out_csv, ".csv"), row.names = FALSE)
# message("CSV geschrieben nach: ", paste0(out_csv, ".csv"))
# 
# head(final_df)
# 
# 
# ## Niederschlag (jährlich) ---------------------------------
# 
# # 0. Konfiguration --------------------------------------------------------
# asc_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Niederschlag/Jaehrlich"
# shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
# out_csv <- gsub("\\s+", "", "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/Niederschlag/Jaehrlich/Niederschlag_J_2020_2024")
# 
# # Zielverzeichnis anlegen
# out_dir <- dirname(out_csv)
# dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
# 
# # 1. Kreise laden ---------------------------------------------------------
# kreise <- st_read(shp_path) %>%
#   st_transform(31467) %>%
#   mutate(ID = row_number())
# 
# # Attributtabelle ohne Geometrie
# base_df <- kreise %>%
#   select(ID, ARS, AGS, GEN, BEZ) %>%
#   st_set_geometry(NULL)
# 
# # 2. ASC-Dateien einlesen (multi_annual ausschließen) ---------------------
# asc_files <- list.files(asc_dir, pattern = "\\.asc$", full.names = TRUE)
# asc_files <- asc_files[!grepl("multi_annual", asc_files)]
# 
# # 3. Loop über Dateien -----------------------------------------------------
# final_df <- base_df
# for(file in asc_files) {
#   fn <- basename(file)  # z.B. annual_precipitation_202017.asc
#   year <- sub(".*_(20[0-9]{2})[0-9]{2}\\.asc$", "\\1", fn)
#   
#   var_name <- "Niederschlag"
#   spalten_prefix <- paste0(var_name, "_J_", year)
#   
#   r <- raster(file)
#   crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
#                  +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
#                  +units=m +no_defs")
#   
#   r2 <- mask(crop(r, extent(kreise)), kreise)
#   
#   stats <- extract(r2, kreise, fun = function(x, ...) {
#     x <- x[!is.na(x)]
#     if(length(x) == 0) return(c(mean = NA, median = NA))
#     c(mean = mean(x), median = median(x))
#   }, df = TRUE)
#   
#   names(stats)[2:3] <- paste0(spalten_prefix, c("_mean", "_median"))
#   final_df <- left_join(final_df, stats, by = "ID")
#   
#   message("Fertig: ", spalten_prefix)
# }
# 
# # 4. CSV speichern --------------------------------------------------------
# write.csv(final_df, paste0(out_csv, ".csv"), row.names = FALSE)
# message("CSV geschrieben nach: ", paste0(out_csv, ".csv"))


# # --- Die AUTOMATISCHE NAMENSGEBUNG DER CSV FILE MIT JAHRESZAHL FUNKTIONIERT NOCH NICHT !! -> der export als csv funktioniert nichT!!!
# library(raster)
# library(sf)
# library(dplyr)
# library(tools)
# 
# # Funktion zur Verarbeitung der Daten
# process_data <- function(asc_file_path, shp_path, var_name) {
#   # 1. Kreise laden
#   kreise <- st_read(shp_path) %>%
#     st_transform(31467) %>%
#     mutate(ID = row_number())
#   
#   # Basis-Dataframe ohne Geometrie
#   base_df <- kreise %>%
#     select(ID, ARS, AGS, GEN, BEZ) %>%
#     st_set_geometry(NULL)
#   
#   # 2. ASC-Dateien einlesen
#   asc_files <- list.files(asc_file_path, pattern = "\\.asc$", full.names = TRUE)
#   
#   # 3. Jahre aus Dateinamen extrahieren
#   years <- gsub(".*_(20[0-9]{2})[0-9]{2}\\.asc$", "\\1", basename(asc_files))
#   message("Jahre extrahiert: ", paste(years, collapse = ", "))
#   
#   min_year <- min(as.numeric(years))
#   max_year <- max(as.numeric(years))
#   
#   # Dynamischer Output-Pfad erstellen: Kreisebene + Niederschlag/Saisonal (und ggf. Unterordner)
#   out_dir <- file.path(dirname(asc_file_path), "Kreisebene", "Niederschlag", "Saisonal")
#   if (!dir.exists(out_dir)) {
#     tryCatch({
#       dir.create(out_dir, recursive = TRUE)
#     }, error = function(e) {
#       message("Fehler beim Erstellen des Zielverzeichnisses: ", e$message)
#     })
#   }
#   
#   # Sicherstellen, dass der Zielordner existiert
#   if (!dir.exists(out_dir)) {
#     dir.create(out_dir, recursive = TRUE)
#   }
#   
#   # Dynamischer Output-Dateiname
#   out_csv <- file.path(out_dir, paste0(var_name, "_", min_year, "_", max_year, ".csv"))
#   
#   # 4. Loop über Dateien
#   final_df <- base_df
#   for (file in asc_files) {
#     # Dateiname analysieren
#     fn <- basename(file)  # z.B. "annual_precipitation_202017.asc"
#     year <- sub(".*_(20[0-9]{2})[0-9]{2}\\.asc$", "\\1", fn)
#     
#     # Spaltennamen vorbereiten
#     # spalten_prefix <- paste0(var_name, "_", year)
#     
#     # Raster laden & CRS setzen
#     r <- raster(file)
#     crs(r) <- CRS("+proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0
#                    +ellps=bessel +towgs84=598.1,73.7,418.2,0.202,0.045,-2.455,6.7
#                    +units=m +no_defs")
#     
#     # # Zuschneiden
#     # r2 <- mask(crop(r, extent(kreise)), kreise)
#     # 
#     # # Statistik berechnen (mean & median)
#     # stats <- extract(r2, kreise, fun = function(x, ...) {
#     #   x <- x[!is.na(x)]
#     #   if(length(x) == 0) return(c(mean = NA, median = NA))
#     #   c(mean = mean(x), median = median(x))
#     # }, df = TRUE)
#     # 
#     # # Spalten umbenennen
#     # names(stats)[2:3] <- paste0(spalten_prefix, c("_mean", "_median"))
#     # 
#     # # Join mit final_df
#     # final_df <- left_join(final_df, stats, by = "ID")
#     
#     message("Fertig: ", spalten_prefix)
#   }
#   
#   # 5. CSV schreiben
#   message("Ausgabepfad CSV: ", out_csv)
#   # write.csv(final_df, out_csv, row.names = FALSE)
#   message("CSV geschrieben nach: ", out_csv)
# }
# 
# # Beispielaufruf: Niederschlag (saisonal)
# asc_file_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Niederschlag/Jaehrlich"
# shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
# process_data(asc_file_path, shp_path, "Niederschlag")
