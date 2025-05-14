read_xml("Gemeinsamer_Bundesausschluss/Test/260100023-773287000-2023-xml.xml")


# Pakete laden
# install.packages("xml2")
# install.packages("XML")

library(xml2)
library(XML)
library(dplyr)
library(stringr)

# Arbeitsverzeichnis setzen
setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/")

# Pfad zu XML-Dateien
ordnerpfad <- "Gemeinsamer_Bundesausschluss/Test"
xml_files <- list.files(ordnerpfad, pattern = "-xml\\.xml$", full.names = TRUE)

# Leere Vektor- und Listenobjekte vorbereiten
gefaess_files <- c()
df_liste <- list()

# 1. Dateien filtern: Nur wenn "gefäß" in Abteilungsnamen vorkommt
for (xml_file in xml_files) {
  qb_first <- read_xml(xml_file)
  
  namen <- xml_text(xml_find_all(qb_first, ".//Organisationseinheit_Fachabteilung/Name"))
  
  if (any(str_detect(namen, regex("gefäß", ignore_case = TRUE)))) {
    gefaess_files <- c(gefaess_files, xml_file)
  }
}

# Ausgabe: Gefäß-relevante Dateien
cat("✅ Gefäß-relevante Dateien gefunden:", length(gefaess_files), "\n\n")
print(basename(gefaess_files))


# Einmalig alle OPS-Codes mit "5-" sammeln
alle_ops_5_codes <- c()

for (file in gefaess_files) {
  qb <- read_xml(file)
  fachabteilungen <- xml_find_all(qb, ".//Organisationseinheit_Fachabteilung")
  
  gefaeß_node <- fachabteilungen[
    str_detect(xml_text(xml_find_first(fachabteilungen, "./Name")), regex("gefäß", ignore_case = TRUE))
  ][1]
  
  prozeduren <- xml_find_all(gefaeß_node, ".//Prozedur")
  ops_codes <- xml_text(xml_find_all(prozeduren, ".//OPS_301"))
  
  ops_5 <- ops_codes[str_starts(ops_codes, "5-")]
  alle_ops_5_codes <- c(alle_ops_5_codes, ops_5)
}

# Duplikate entfernen und sortieren
alle_ops_5_codes <- sort(unique(alle_ops_5_codes))


# Einmalig alle ICD-Codes mit "I71" sammeln
alle_i71_codes <- c()
for (file in gefaess_files) {
  qb <- read_xml(file)
  fachabteilungen <- xml_find_all(qb, ".//Organisationseinheit_Fachabteilung")
  
  gefaeß_node <- fachabteilungen[
    str_detect(xml_text(xml_find_first(fachabteilungen, "./Name")), regex("gefäß", ignore_case = TRUE))
  ][1]
  
  Hauptdiagnose <- xml_find_all(gefaeß_node, ".//Hauptdiagnose")
  icd_codes <- xml_text(xml_find_all(Hauptdiagnose, ".//ICD_10"))
  
  icd_i71 <- icd_codes[str_starts(icd_codes, "I71")]
  alle_i71_codes <- c(alle_i71_codes, icd_i71)
}

# Duplikate entfernen und sortieren
alle_i71_codes <- sort(unique(alle_i71_codes))


# Leere Listen erstellen
df_liste <- list()                
icd_liste <- list()
ops_liste <- list()




# 2. Daten extrahieren und DataFrame aufbauen
for (xml_file in gefaess_files) {
  qb_first <- read_xml(xml_file)

  # --- A Struktur- und Leistungsdaten des Krankenhauses bzw. des Krankenhausstandorts ---
  # -- A-1 Allgemeine Kontaktdaten des Krankenhauses -------------------------------------

  Name <- xml_text(xml_find_first(qb_first, ".//Name"))
  IK <- xml_text(xml_find_first(qb_first, ".//IK"))
  PLZ <- xml_text(xml_find_first(qb_first, ".//Postleitzahl"))
  Ort <- xml_text(xml_find_first(qb_first, ".//Ort"))
  Standortnummer <- xml_text(xml_find_first(qb_first, ".//Standortnummer"))

  # -- A-9 Anzahl der Betten -------------------------------------------------------------

  Anzahl_Betten <- xml_text(xml_find_first(qb_first, ".//Anzahl_Betten"))

  # --A-10 Gesamtfallzahlen --------------------------------------------------------------

  Vollstationaere_Fallzahl <- xml_text(xml_find_first(qb_first, ".//Fallzahlen/Vollstationaere_Fallzahl"))
  Teilstationaere_Fallzahl <- xml_text(xml_find_first(qb_first, ".//Fallzahlen/Teilstationaere_Fallzahl"))
  Ambulante_Fallzahl <- xml_text(xml_find_first(qb_first, ".//Fallzahlen/Ambulante_Fallzahl"))

  # --- B Struktur- und Leistungsdaten der Organisationseinheiten/Fachabteilungen -------
  # --- GEFÄßCHIRURGIE ------------------------------------------------------------------
  fachabteilungen <- xml_find_all(qb_first, ".//Organisationseinheit_Fachabteilung")

  Gefäßchirurgie <- fachabteilungen[
    str_detect(xml_text(xml_find_first(fachabteilungen, "./Name")), regex("gefäß", ignore_case = TRUE))
  ][1]

  # -- B-[X].1 Name der Organisationseinheit/Fachabteilung ------------------------------
  GC_Name <- xml_text(xml_find_first(Gefäßchirurgie, ".//Name"))


  # -- B-[X].5 Fallzahlen der Organisationseinheit/Fachabteilung

  GC_Vollstationaere_Fallzahl <- xml_text(xml_find_all(Gefäßchirurgie, ".//Fallzahlen_OE/Vollstationaere_Fallzahl"))
  GC_Fallzahlen_OE_Teilstationaere_Fallzahl <- xml_text(xml_find_all(Gefäßchirurgie, ".//Fallzahlen_OE/Teilstationaere_Fallzahl"))

  # -- B-[X].6 Hauptdiagnosen nach ICD -----------------------------------------------
  
  # --- I71. Aortenaneurysma und -dissektion -----------------------------------------
   # ICD-10 extrahieren
  hauptdiagnosen <- xml_find_all(Gefäßchirurgie, ".//Hauptdiagnose")
  
  # 1. Hauptdiagnosen parsen
  icd_codes <- xml_text(xml_find_all(hauptdiagnosen, ".//ICD_10"))
  fallzahlen <- xml_text(xml_find_all(hauptdiagnosen, ".//Fallzahl"))
  
  # Filter auf "I71"
  maske_i71 <- str_starts(icd_codes, "I71")
  icd_i71 <- icd_codes[maske_i71]
  fallzahl_i71 <- as.integer(fallzahlen[maske_i71])
  
  # Nur gültige I71-Codes behalten (aus deiner Liste)
  valid_i71 <- icd_i71 %in% alle_i71_codes
  icd_i71 <- icd_i71[valid_i71]
  fallzahl_i71 <- fallzahl_i71[valid_i71]
  
  # DataFrame mit vorhandenen Werten
  icd_df <- setNames(as.data.frame(t(fallzahl_i71), stringsAsFactors = FALSE), icd_i71)
  
  # Fehlende ICDs auffüllen mit 0
  fehlende <- setdiff(alle_icd_codes, names(icd_df))
  if (length(fehlende) > 0) {
    icd_df[fehlende] <- 0
  }
  
  # Reihenfolge angleichen
  icd_df <- icd_df[alle_i71_codes]
  
  # Datei-Name anhängen
  icd_df$Datei <- basename(xml_file)
  icd_df <- icd_df[, c("Datei", alle_i71_codes)]
  
  # Speichern
  icd_liste[[length(icd_liste) + 1]] <- icd_df
  
  #   # -- B-[X].7 Durchgeführte Prozeduren nach OPS -------------------------------------
  # --------------------------------------------------------------------------------------
  # Prozedur <- xml_find_all(Gefäßchirurgie, ".//Prozedur")
  # 
  # # 1. Hauptdiagnosen parsen
  # ops_codes <- xml_text(xml_find_all(Prozedur, ".//OPS_301"))
  # Anzahl <- xml_text(xml_find_all(Prozedur, ".//Anzahl"))
  # 
  # # Filter auf "I71"
  # maske_ops_5 <- str_starts(ops_codes, "5-")
  # ops_5 <- ops_codes[maske_ops_5]
  # Anzahl_ops_5 <- as.integer(Anzahl[maske_ops_5])
  # 
  # # Nur gültige ops-5-Codes behalten (aus deiner Liste)
  # valid_ops_5 <- ops_5 %in% alle_ops_5_codes
  # ops_5 <- ops_5[valid_ops_5]
  # anzahl_ops_5 <- Anzahl_ops_5[valid_ops_5]
  # 
  # # DataFrame mit vorhandenen Werten
  # ops_df <- setNames(as.data.frame(t(anzahl_ops_5), stringsAsFactors = FALSE), ops_5)
  # 
  # # Fehlende ICDs auffüllen mit 0
  # fehlende <- setdiff(alle_ops_5_codes, names(ops_df))
  # if (length(fehlende) > 0) {
  #   ops_df[fehlende] <- 0
  # }
  # 
  # # Reihenfolge angleichen
  # ops_df <- ops_df[alle_ops_5_codes]
  # 
  # # Datei-Name anhängen
  # ops_df$Datei <- basename(xml_file)
  # ops_df <- ops_df[, c("Datei", alle_ops_5_codes)]
  # 
  # # Speichern
  # ops_liste[[length(ops_liste) + 1]] <- ops_df
  # 
  
  # DataFrame-Zeile anhängen
  df_liste[[length(df_liste) + 1]] <- data.frame(
    Datei = basename(xml_file),
    Name = Name,
    IK = IK,
    PLZ = PLZ,
    Ort = Ort,
    Standortnummer = as.numeric(Standortnummer),
    Anzahl_Betten = as.numeric(Anzahl_Betten),
    Vollstationaere_Fallzahl = as.numeric(Vollstationaere_Fallzahl),
    Teilstationaere_Fallzahl = as.numeric(Teilstationaere_Fallzahl),
    Ambulante_Fallzahl = as.numeric(Ambulante_Fallzahl),
    GC_Name = GC_Name,
    GC_Vollstationaere_Fallzahl = as.numeric(GC_Vollstationaere_Fallzahl),
    GC_Fallzahlen_OE_Teilstationaere_Fallzahl = as.numeric(GC_Fallzahlen_OE_Teilstationaere_Fallzahl),
    stringsAsFactors = FALSE
  )
}


df_info <- bind_rows(df_liste)     # enthält ebenfalls Spalte 'Datei'
df_icd  <- bind_rows(icd_liste)    # enthält Spalte 'Datei'
df_ops  <- bind_rows(ops_liste)    # enthält Spalte 'Datei'

# Zusammenführen über "Datei"
df_komplett <- left_join(df_info, df_icd, by = "Datei")
# df_komplett <- left_join(df_komplett, df_ops, by = "Datei")



write_csv(df_komplett, "Gemeinsamer_Bundesausschluss/processed/Qualitaetsbericht_i71_23.csv")
