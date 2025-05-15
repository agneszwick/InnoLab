# Falls noch nicht installiert
devtools::install_github("jessecambon/tidygeocoder")

library(tidygeocoder)
library(dplyr)
library(tidyr)
library(readr)

setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/")

df <- read_csv(
  "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23_Anzahl_ICD.csv",
  col_types = cols(PLZ = col_character()
))

df <- df %>%
  mutate(adresse = paste(PLZ, Ort, "Deutschland", sep = ", ")) %>%
  geocode(address = adresse, method = "osm", lat = latitude, long = longitude)


head(df)
# Optional speichern
write.csv(df, "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23_Anzahl_ICD_geocodiert.csv", row.names = FALSE)


# library(tidygeocoder)
# library(dplyr)
# 
# # Beispiel Data Frame mit Adressen
# df_test <- tibble(address = "20246, Hamburg, Deutschland")
# 
# # Geokodieren
# result <- df_test %>%
#   geocode(address = address, method = "osm")
# 
# print(result)


