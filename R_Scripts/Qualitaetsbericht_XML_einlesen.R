read_xml("Gemeinsamer_Bundesausschluss/Qualitaetsbericht_2023/261400621-773221000-2023-xml.xml")


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
ordnerpfad <- "Gemeinsamer_Bundesausschluss/Qualitaetsbericht_2023"
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

df_liste <- list()
df_icd <- list()


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
  
  alle_i71_codes <- c()  # Sammeln aller ICD-Spaltennamen
 
   # ICD-10 extrahieren
  hauptdiagnosen <- xml_find_all(qb_first, ".//Hauptdiagnose")
  icd_codes <- xml_text(xml_find_all(hauptdiagnosen, ".//ICD_10"))
  fallzahlen <- xml_text(xml_find_all(hauptdiagnosen, ".//Fallzahl"))
  Hauptdiagnosen <- xml_find_all(Gefäßchirurgie, ".//Hauptdiagnose")
  
  # Leere Fallzahlen durch "1" ersetzen
  fallzahlen_clean <- ifelse(fallzahlen == "" | is.na(fallzahlen), "1", fallzahlen)
  fallzahlen_num <- as.integer(fallzahlen_clean)
  
  # Nur ICDs mit I71
  maske_i71 <- str_starts(icd_codes, "I71")
  icd_i71 <- icd_codes[maske_i71]
  fallzahl_i71 <- fallzahlen_num[maske_i71]
  
  # Update alle_icd_codes (nur neue hinzufügen)
  alle_icd_codes <- union(alle_icd_codes, icd_i71)
  
  # ICD-Daten in DataFrame (nur für vorhandene)
  icd_df <- setNames(as.data.frame(t(fallzahl_i71)), icd_i71)
  
  
  # Fehlende ICD-Spalten ergänzen
  fehlende <- setdiff(alle_icd_codes, names(icd_df))
  if (length(fehlende) > 0) {
    icd_df[fehlende] <- 0
  }
  
  icd_df <- icd_df[sort(alle_icd_codes)]
  
  df_icd[[length(df_icd) + 1]] <- data.frame(icd_df)
  
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

head(df_icd)

# 6. Kombination aus Basisdaten und ICD-Fällen
df_komplett <- cbind(df_liste, icd_df)

# 7. Liste ergänzen
df_liste[[length(df_liste) + 1]] <- df_komplett

# # 
# # # Zusammenführen
# df_gefaess <- bind_rows(df_liste)
# # 
# # # Ergebnis anzeigen
# # head(df_gefaess)










  # --- B Struktur- und Leistungsdaten der Organisationseinheiten/Fachabteilungen -------

  # -- B-[X].6 Hauptdiagnosen nach ICD -----------------------------------------------

  # Alle <Eintrag>-Knoten finden (innerhalb deines Elements)
  Hauptdiagnosen <- xml_find_all(Gefäßchirurgie, ".//Hauptdiagnose")

  df <- lapply(Hauptdiagnosen, function(e) {
    ICD_10 <- xml_text(xml_find_first(e, "./ICD_10"))
    Fallzahl <- xml_text(xml_find_first(e, "./Fallzahl"))
    data.frame(
      ICD_10 = ICD_10,
      Haupdiagnose_Fallzahl = as.numeric(Fallzahl),
      stringsAsFactors = FALSE
    )
  }) %>%
    bind_rows()

  # Ausgabe
  print(df)


  # -- B-[X].7 Durchgeführte Prozeduren nach OPS -------------------------------------
  Prozeduren <- xml_find_all(Gefäßchirurgie, ".//Prozedur")

  df <- lapply(Prozeduren, function(e) {
    OPS_301 <- xml_text(xml_find_first(e, "./OPS_301"))
    Anzahl <- xml_text(xml_find_first(e, "./Anzahl"))
    data.frame(
      OPS_301 = OPS_301,
      Prozedur_Anzahl = as.numeric(Anzahl),
      stringsAsFactors = FALSE
    )
  }) %>%
    bind_rows()

  # Ausgabe
  print(df)



  # -- B-[X].9 Ambulante Operationen nach § 115b SGB V
  Ambulant <- xml_find_all(Gefäßchirurgie, ".//Ambulante_Operation")

  df <- lapply(Ambulant, function(e) {
    OPS_301 <- xml_text(xml_find_first(e, "./OPS_301"))
    Anzahl <- xml_text(xml_find_first(e, "./Anzahl"))
    data.frame(
      OPS_301 = OPS_301,
      Prozedur_Ambulant_Anzahl = as.numeric(Anzahl),
      stringsAsFactors = FALSE
    )
  }) %>%
    bind_rows()

  # Ausgabe
  print(df)

}


# 
# 
# 
# 
# 
# # qb_first <- read_xml("Gemeinsamer_Bundesausschluss/Qualitaetsbericht_2023/261401052-771392000-2023-xml.xml")
# #
# #
# # # --- A Struktur- und Leistungsdaten des Krankenhauses bzw. des Krankenhausstandorts ---
# # # -- A-1 Allgemeine Kontaktdaten des Krankenhauses -------------------------------------
# # Name <- xml_text(xml_find_all(qb_first, ".//Krankenhaus/Mehrere_Standorte/Krankenhauskontaktdaten/Name"))
# # IK <- xml_text(xml_find_all(qb_first, ".//Krankenhaus/Mehrere_Standorte/Krankenhauskontaktdaten/IK"))
# # PLZ <- xml_text(xml_find_all(qb_first, ".//Krankenhaus/Mehrere_Standorte/Krankenhauskontaktdaten/Kontakt_Zugang/Postleitzahl"))
# # Ort <- xml_text(xml_find_all(qb_first, ".//Krankenhaus/Mehrere_Standorte/Krankenhauskontaktdaten/Kontakt_Zugang/Ort"))
# # Standortnummer <- xml_text(xml_find_all(qb_first, ".//Standortnummer"))
# #
# #
# # # -- A-9 Anzahl der Betten -------------------------------------------------------------
# # Anzahl_Betten <- xml_text(xml_find_all(qb_first, ".//Anzahl_Betten"))
# #
# #
# # # --A-10 Gesamtfallzahlen --------------------------------------------------------------
# # Vollstationaere_Fallzahl <- xml_text(xml_find_all(qb_first, ".//Fallzahlen/Vollstationaere_Fallzahl"))
# # Teilstationaere_Fallzahl <- xml_text(xml_find_all(qb_first, ".//Fallzahlen/Teilstationaere_Fallzahl"))
# # Ambulante_Fallzahl <- xml_text(xml_find_all(qb_first, ".//Fallzahlen/Ambulante_Fallzahl"))
# #
# #
# # # --- B Struktur- und Leistungsdaten der Organisationseinheiten/Fachabteilungen -------
# #
# # # -- B-[X].1 Name der Organisationseinheit/Fachabteilung ------------------------------
# # dir_Fachabteilung <- ".//Organisationseinheiten_Fachabteilungen/Organisationseinheit_Fachabteilung/"
# #
# # Fachabteilung_Name <- xml_text(xml_find_all(qb_first, paste0(dir_Fachabteilung, "Name")))
# # Fachabteilung_Name
# # Fachabteilungsschluessel <- xml_text(xml_find_all(qb_first, paste0(dir_Fachabteilung, "Fachabteilungsschluessel")))
# # Fachabteilungsschluessel
# # # -- B-[X].5 Fallzahlen der Organisationseinheit/Fachabteilung
# #
# # #### Gefäßchirurgie
# # Gefäßchirurgie <- xml_find_first(qb_first, ".//Organisationseinheit_Fachabteilung[Fachabteilungsschluessel='1800']")
# # Gefäßchirurgie
# #
# # Vollstationaere_Fallzahl <- xml_text(xml_find_all(Gefäßchirurgie, ".//Fallzahlen_OE/Vollstationaere_Fallzahl"))
# # Fallzahlen_OE_Teilstationaere_Fallzahl <- xml_text(xml_find_all(Gefäßchirurgie, ".//Fallzahlen_OE/Teilstationaere_Fallzahl"))
# #
# #
# # # -- B-[X].6 Hauptdiagnosen nach ICD -----------------------------------------------
# #
# # # Alle <Eintrag>-Knoten finden (innerhalb deines Elements)
# # Hauptdiagnosen <- xml_find_all(Gefäßchirurgie, ".//Hauptdiagnose")
# #
# # df <- lapply(Hauptdiagnosen, function(e) {
# #   ICD_10 <- xml_text(xml_find_first(e, "./ICD_10"))
# #   Fallzahl <- xml_text(xml_find_first(e, "./Fallzahl"))
# #   data.frame(
# #     ICD_10 = ICD_10,
# #     Haupdiagnose_Fallzahl = as.numeric(Fallzahl),
# #     stringsAsFactors = FALSE
# #   )
# # }) %>%
# #   bind_rows()
# #
# # # Ausgabe
# # print(df)
# #
# #
# # # -- B-[X].7 Durchgeführte Prozeduren nach OPS -------------------------------------
# # Prozeduren <- xml_find_all(Gefäßchirurgie, ".//Prozedur")
# #
# # df <- lapply(Prozeduren, function(e) {
# #   OPS_301 <- xml_text(xml_find_first(e, "./OPS_301"))
# #   Anzahl <- xml_text(xml_find_first(e, "./Anzahl"))
# #   data.frame(
# #     OPS_301 = OPS_301,
# #     Prozedur_Anzahl = as.numeric(Anzahl),
# #     stringsAsFactors = FALSE
# #   )
# # }) %>%
# #   bind_rows()
# #
# # # Ausgabe
# # print(df)
# #
# #
# #
# # # -- B-[X].9 Ambulante Operationen nach § 115b SGB V
# # Ambulant <- xml_find_all(Gefäßchirurgie, ".//Ambulante_Operation")
# #
# # df <- lapply(Ambulant, function(e) {
# #   OPS_301 <- xml_text(xml_find_first(e, "./OPS_301"))
# #   Anzahl <- xml_text(xml_find_first(e, "./Anzahl"))
# #   data.frame(
# #     OPS_301 = OPS_301,
# #     Prozedur_Ambulant_Anzahl = as.numeric(Anzahl),
# #     stringsAsFactors = FALSE
# #   )
# # }) %>%
# #   bind_rows()
# #
# # # Ausgabe
# # print(df)
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # 
# # # 
# # # 
# # # 
# # # 
# # # 
# # 
# # # Ordnerpfad mit den XML-Dateien
# # ordnerpfad <- "Gemeinsamer_Bundesausschluss/Qualitaetsbericht_2023/"
# # 
# # # Liste aller XML-Dateien im Ordner
# # xml_files <- list.files(ordnerpfad, pattern = "\\.xml$", full.names = TRUE)
# # 
# # # Initialisiere einen leeren Vektor, um die Dateinamen zu speichern
# # gefunden_files <- character()
# # # Durchlaufe alle Dateien
# # 
# # for (xml_file in xml_files) {
# #   # XML laden
# #   qb_first <- read_xml(xml_file)
# # 
# #   # Alle <Fachabteilungsschluessel>-Texte extrahieren
# #   fachabteilungsschluessel <- xml_text(xml_find_all(qb_first, ".//Fachabteilungsschluessel"))
# # 
# #   # Prüfen, ob einer der Werte "1800" entspricht
# #   if (any(fachabteilungsschluessel == "1800")) {
# #     gefunden_files <- c(gefunden_files, basename(xml_file))
# #   }
# # }
# # 
# # # Ausgabe
# # print(gefunden_files)
