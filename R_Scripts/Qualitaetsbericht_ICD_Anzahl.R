# library(dplyr)
# library(readr)
# library(tidyr)
# 
# # Set working directory
# setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/")
# 
# # Load the CSV file
# df <- read_csv(
#   "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23.csv",
#   col_types = cols(
#     PLZ = col_character()
#   )
# )
# 
# # Spaltennamen filtern, die mit "I7" anfangen
# i71_spalten <- grep("^I71", names(df), value = TRUE)
# 
# # Berechnungen durchführen
# df <- df %>%
#   rowwise() %>%
#   mutate(
#     Anzahl_I71_NA = sum(is.na(c_across(all_of(i71_spalten)))),
#     Anzahl_I71 = sum(ifelse(is.na(c_across(all_of(i71_spalten))), 0, as.numeric(c_across(all_of(i71_spalten))))),
#     Min_Anzahl_I71 = Anzahl_I71 + Anzahl_I71_NA,
#     Max_Anzahl_I71 = Anzahl_I71 + 3 * Anzahl_I71_NA,
#     GC_Fallzahlen = GC_Vollstationaere_Fallzahl + GC_Teilstationaere_Fallzahl,
#     Min_Anteil_I71_GC_Fallzahlen = Min_Anzahl_I71 / GC_Fallzahlen,
#     Max_Anteil_I71_GC_Fallzahlen = Max_Anzahl_I71 / GC_Fallzahlen
#     
#   ) %>%
#   ungroup()
# 
# # Ergebnis anzeigen
# head(df)
# 
# # Optional: Neue Datei speichern
# write.csv(df, "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23_Anzahl_ICD.csv", row.names = FALSE)


# Für alle rupturierten Aortenaneurysmen 

library(dplyr)
library(readr)
library(tidyr)

# Set working directory
setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/")

# Load the CSV file
df <- read_csv(
  "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23_Anzahl_I71_mit_ARS.csv",
  col_types = cols(
    PLZ = col_character(),
    ARS = col_character(),
    AGS = col_character()
  )
)
head(df)

# Spalten, die du aufsummieren willst
Aneurysmen_rupt <- c('I71.1', 'I71.3', 'I71.5', 'I71.8')
Dissektionen_rupt <- c('I71.04', 'I71.05', 'I71.06', 'I71.07')

df_Aorten <- df %>%
  rowwise() %>%
  mutate(
    Aneurysma_rupturiert_NA = sum(is.na(c_across(all_of(Aneurysmen_rupt)))),
    Aneurysma_rupturiert = sum(replace_na(as.numeric(c_across(all_of(Aneurysmen_rupt))), 0)),
    Min_Anzahl_Aneurysma_rupturiert = Aneurysma_rupturiert + Aneurysma_rupturiert_NA,
    Max_Anzahl_Aneurysma_rupturiert = Aneurysma_rupturiert + 3 * Aneurysma_rupturiert_NA,
    
    Dissektion_rupturiert_NA = sum(is.na(c_across(all_of(Dissektionen_rupt)))),
    Dissektion_rupturiert = sum(replace_na(as.numeric(c_across(all_of(Dissektionen_rupt))), 0)),
    Min_Anzahl_Dissektion_rupturiert = Dissektion_rupturiert + Dissektion_rupturiert_NA,
    Max_Anzahl_Dissektion_rupturiert = Dissektion_rupturiert + 3 * Dissektion_rupturiert_NA
  ) %>%
  ungroup()

colnames(df_Aorten)
# Optional: Neue Datei speichern
write.csv(df_Aorten, "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_rupt_23.csv", row.names = FALSE)

