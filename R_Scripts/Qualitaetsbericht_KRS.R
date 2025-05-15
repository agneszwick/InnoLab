# Pakete laden
library(sf)
library(readr)
library(dplyr)

# Arbeitsverzeichnis setzen
setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/")

# CSV-Datei laden
csv_path <- "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23_Anzahl_ICD_geocodiert.csv"
df_csv <- read_csv(csv_path, col_types = cols(PLZ = col_character()))

# Shapefile laden
shapefile_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
gdf_shp <- st_read(shapefile_path) %>%
  mutate(AGS = as.character(AGS), ARS = as.character(ARS))

# DataFrame zu sf-Objekt mit Punkten machen (WGS84)
gdf_punkte <- st_as_sf(df_csv, coords = c("longitude", "latitude"), crs = 4326)

# Umprojizieren auf GK3 (entspricht EPSG:31467)
gdf_punkte <- st_transform(gdf_punkte, st_crs(gdf_shp))

# Filter: nur Landflächen (GF == 4)
gdf_shp <- gdf_shp %>% filter(GF == 4)

# 7. Räumlicher Join (innerhalb der Polygone)
qb_mit_ARS <- st_join(gdf_punkte, gdf_shp, join = st_within, left = TRUE)

# Optional: Entferne Punkte außerhalb aller Polygone (analog zu unary_union in Python)
qb_mit_ARS <- qb_mit_ARS %>%
  filter(st_within(geometry, st_union(gdf_shp), sparse = FALSE))


# 8. Als CSV exportieren (ohne Geometrie-Spalte)
# export_df <- punkte_mit_attributen %>% st_drop_geometry()
write_csv(qb_mit_ARS, "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23_Anzahl_I71_mit_ARS.csv")


# 2. Gruppieren nach ARS und Summieren der gewünschten Spalten
qb_KRS <- qb_mit_ARS %>%
  group_by(ARS) %>%
  summarise(
    GC_Fallzahlen = sum(GC_Fallzahlen, na.rm = FALSE),
    Min_Anzahl_I71 = sum(Min_Anzahl_I71, na.rm = FALSE),
    Max_Anzahl_I71 = sum(Max_Anzahl_I71, na.rm = FALSE),
    Min_Anteil_I71_GC_Fallzahlen = Min_Anzahl_I71 / GC_Fallzahlen,
    Max_Anteil_I71_GC_Fallzahlen = Max_Anzahl_I71 / GC_Fallzahlen
  ) %>%
  ungroup()

qb_KRS <- qb_KRS %>% st_drop_geometry()


# 3. Ergebnis prüfen
print(qb_KRS)

# Optional: als CSV speichern
write_csv(qb_KRS, "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23_Anzahl_I71_KRS_aggregiert.csv")

