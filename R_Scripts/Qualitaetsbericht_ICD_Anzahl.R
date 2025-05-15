library(dplyr)
library(readr)
library(tidyr)

# Set working directory
setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/")

# Load the CSV file
df <- read_csv(
  "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23.csv",
  col_types = cols(
    PLZ = col_character()
  )
)

# Spaltennamen filtern, die mit "I7" anfangen
i71_spalten <- grep("^I71", names(df), value = TRUE)

# Berechnungen durchführen
df <- df %>%
  rowwise() %>%
  mutate(
    Anzahl_I71_NA = sum(is.na(c_across(all_of(i71_spalten)))),
    Anzahl_I71 = sum(ifelse(is.na(c_across(all_of(i71_spalten))), 0, as.numeric(c_across(all_of(i71_spalten))))),
    Min_Anzahl_I71 = Anzahl_I71 + Anzahl_I71_NA,
    Max_Anzahl_I71 = Anzahl_I71 + 3 * Anzahl_I71_NA,
    GC_Fallzahlen = GC_Vollstationaere_Fallzahl + GC_Teilstationaere_Fallzahl,
    Min_Anteil_I71_GC_Fallzahlen = Min_Anzahl_I71 / GC_Fallzahlen,
    Max_Anteil_I71_GC_Fallzahlen = Max_Anzahl_I71 / GC_Fallzahlen
    
  ) %>%
  ungroup()

# Ergebnis anzeigen
head(df)

# Optional: Neue Datei speichern
write.csv(df, "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23_Anzahl_ICD.csv", row.names = FALSE)
