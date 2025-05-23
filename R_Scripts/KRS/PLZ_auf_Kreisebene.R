# Nur nötige Pakete
library(readr)  # bietet kontrolliertes Einlesen mit Spaltentypen

# CSV einlesen – nur relevante Spalten, 'kreis code' als character
krs_uebersicht <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/KRS_Uebersicht.csv")

df_kreise <- read_csv2("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Postleitzahlen/georef-germany-postleitzahl.csv")
df_kreise_kurz <- df_kreise[, c("Name", "Kreis code")]
names(df_kreise_kurz)[names(df_kreise_kurz) == "Kreis code"] <- "ARS"
names(df_kreise_kurz)[names(df_kreise_kurz) == "Name"] <- "PLZ"


head(df_kreise_kurz)
# Ergebnis prüfen

# ---- 6. Anreichern mit Metadaten und Export ----
df_final <- df_kreise_kurz %>%
  left_join(krs_uebersicht, by = "ARS") %>%
  select(AGS, ARS, GF, GEN, BEZ, everything())

head(df_final)
write_csv(df_final, "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Postleitzahlen/processed/PLZ_mit_ARS.csv")

