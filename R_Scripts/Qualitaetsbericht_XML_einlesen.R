read_xml("Gemeinsamer_Bundesausschluss/Qualitaetsbericht_2023/261401052-771392000-2023-xml.xml")

# Benötigte Skripte
source("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/InnoLab/R_Scripts/filter_gefaess_files.R")
source("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/InnoLab/R_Scripts/extrahiere_ICD.R")
source("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/InnoLab/R_Scripts/extrahiere_OPS.R")
source("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/InnoLab/R_Scripts/extrahiere_allg_Krankenhausdaten.R")
source("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/InnoLab/R_Scripts/extrahiere_Fachabteilungsdaten.R")


# Benötigte Pakete
library(dplyr)

# Arbeitsverzeichnis setzen
setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/")

# Ordnerpfad definieren
ordner <- "Gemeinsamer_Bundesausschluss/Qualitaetsbericht_2023"

# Gefäß-relevante Dateien
gefaess_files <- filter_gefaess_dateien(ordner)

# Ausgabe
cat("Gefäß-relevante Dateien gefunden:", length(gefaess_files), "\n")
# print(basename(gefaess_files))


alle_i71_codes <- extrahiere_icd_codes(gefaess_files, icd_prefix = "I71")
alle_ops_5_codes <- extrahiere_ops_codes(gefaess_files, ops_prefix = "5-")

krankenhausdaten_list <- lapply(gefaess_files, extrahiere_allgemeine_krankenhausdaten)
krankenhausdaten_df <- bind_rows(krankenhausdaten_list)
head(krankenhausdaten_df)


fachabteilungsdaten <- lapply(gefaess_files, extrahiere_Fachabteilungsdaten,
                          schluessel_liste = schluessel_liste,
                          alle_icd_codes = alle_i71_codes)

fachabteilungsdaten_df <- dplyr::bind_rows(fachabteilungsdaten)


Qualitätsbericht <- fachabteilungsdaten_df %>%
  left_join(krankenhausdaten_df, by = "Datei")

# Spaltennamen aus krankenhausdaten_df außer "Datei"
kh_spalten <- setdiff(names(krankenhausdaten_df), "Datei")

# Neue Spaltenreihenfolge anwenden
Qualitätsbericht <- Qualitätsbericht %>%
  select(Datei, all_of(kh_spalten), everything())


View(Qualitätsbericht)

# # Exportieren
# write_csv(df_komplett, "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23.csv")
