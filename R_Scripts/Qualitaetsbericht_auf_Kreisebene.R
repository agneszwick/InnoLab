# Arbeitsverzeichnis setzen
setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/")

library(readr)


PLZ <- read_csv(
  "Postleitzahlen/processed/PLZ_mit_ARS.csv",
  col_types = cols(
    "PLZ" = col_character(),
    "ARS" = col_character(),
    "GEN" = col_character(), 
    "BEZ" = col_character(),
    "PLZ" = col_character(),
  )
)

PLZ

qb <- read_csv(
  "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23.csv",
  col_types = cols(
    PLZ = col_character()
    )
)

str(qb)


# ---- 6. Anreichern mit Metadaten und Export ----
qb_joined <- left_join(qb, PLZ, by = "PLZ", relationship = "many-to-many")%>%
  select(AGS, ARS, GF, GEN, BEZ, everything())
colnames(qb_joined)

write_csv(qb_joined, "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_KRS_i71_23.csv")
