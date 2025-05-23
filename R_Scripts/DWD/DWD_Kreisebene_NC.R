# --- Pakete laden --------------------------------------------------------
library(raster)
library(sf)
library(dplyr)
library(ncdf4)
library(stringr)
library(purrr)

target_year <- "2023"

# --- Konfiguration -------------------------------------------------------
shp_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
input_dir <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Jaehrlich/Tropische_Naechte"
output_csv <- paste0("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DWDdaten/Kreisebene/DWD_Tropische_Naechte_J_", target_year, ".csv")

# --- Kreise laden und vorbereiten ----------------------------------------
kreise <- st_read(shp_path) %>%
  filter(GF == "4") %>%
  mutate(ID = row_number(),
         AGS = as.character(AGS),
         ARS = as.character(ARS),
         SDV_ARS = as.character(SDV_ARS)) %>%
  st_transform(31467)

base_df <- kreise
sf::st_geometry(base_df) <- NULL
base_df <- base_df[, c("ID", "ARS", "AGS", "GF", "GEN", "BEZ", "SDV_ARS")]

# --- Hilfsfunktion: Stats für eine einzelne Datei extrahieren ------------
process_nc_file <- function(nc_path) {
  file_base <- tools::file_path_sans_ext(basename(nc_path))
  message(">> Verarbeite Datei: ", file_base)
  
  # Lade Raster
  r <- raster(nc_path)
  message("   - Raster geladen")
  
  crs(r) <- CRS("+proj=lcc +lat_1=35 +lat_2=65 +lat_0=52 +lon_0=10 +x_0=4000000 +y_0=2800000 +ellps=GRS80 +units=m +no_defs")
  # message("   - CRS gesetzt")
  
  r_proj <- projectRaster(r, crs = st_crs(kreise)$wkt)
  message("   - Wertebereich: ", paste(range(values(r_proj), na.rm = TRUE), collapse = " - "))
  
  r_crop <- mask(crop(r_proj, extent(kreise)), kreise)
  message("   - Nach crop/mask: ", paste(range(values(r_crop), na.rm = TRUE), collapse = " - "))
  
  # Statistik berechnen
  stats <- raster::extract(r_crop, kreise, fun=function(x, ...) {
    x <- x[!is.na(x)]
    if(length(x)==0) return(c(mean=NA, median=NA, max=NA))
    c(mean=mean(x), median=median(x), max=max(x))
  }, df=TRUE)
  message("   - Statistiken berechnet")
  
  # Spalten benennen
  names(stats)[2:4] <- paste0(file_base, c("_mean", "_median", "_max"))

  return(stats)
}


# --- Nur passende NetCDF-Dateien des Zieljahrs laden ---------------------
nc_files_all <- list.files(input_dir, pattern = "\\.nc$", full.names = TRUE)
nc_files <- nc_files_all[grepl(target_year, nc_files_all)]

# --- Dateien verarbeiten -------------------------------------------------
all_stats_list <- map(nc_files, process_nc_file)

# --- Zusammenführen und speichern ----------------------------------------
final_df <- reduce(all_stats_list, left_join, by = "ID")
final_df <- left_join(base_df, final_df, by = "ID")

names(final_df) <- gsub(
  paste0(".*", target_year, "-01-01_mean"),
  paste0("Tropische_Naechte_", target_year, "_mean"),
  names(final_df)
)

names(final_df) <- gsub(
  paste0(".*", target_year, "-01-01_median"),
  paste0("Tropische_Naechte_", target_year, "_median"),
  names(final_df)
)

names(final_df) <- gsub(
  paste0(".*", target_year, "-01-01_max"),
  paste0("Tropische_Naechte_", target_year, "_max"),
  names(final_df)
)

View(final_df)

# --- Als CSV speichern ----------------------------------------------------
dir.create(dirname(output_csv), recursive = TRUE, showWarnings = FALSE)
write.csv(final_df, output_csv, row.names=FALSE)
message("Fertig – CSV gespeichert unter: ", output_csv)


# library(sf)
# library(tmap)
# 
# # Kreise laden
# kreise <- st_read(shp_path) %>%
#   st_transform(31467)
# 
# library(sf)
# library(ggplot2)
# 
# # Kreise laden
# kreise <- st_read(shp_path) %>%
#   st_transform(31467)  # UTM Zone 32N
# 
# # Nur die Umrisse plotten
# ggplot(kreise) +
#   geom_sf(fill = NA, color = "black", size = 0.3) +
#   theme_minimal() +
#   labs(title = "Umrisse der Landkreise in Deutschland")
# 
# 
