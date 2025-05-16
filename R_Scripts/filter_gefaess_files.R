# filter_gefaess_dateien.R

# Benötigte Pakete
library(xml2)
library(stringr)

# # Fachabteilungen mit Schlüsseln (gemäß § 301 SGB V)

# |  FA_Schluessel | Fachabteilung                                                  |
# | ------         | -------------------------------------------------------------- |
# | 1800           | Gefäßchirurgie                                                 |
# | 1518           | Allgemeine Chirurgie/Schwerpunkt Gefäßchirurgie                |
# | 1550           | Allgemeine Chirurgie/Schwerpunkt Abdominal- und Gefäßchirurgie |
# | 2118           | Herzchirurgie/Schwerpunkt Gefäßchirurgie                       |
# # 
# # Hinweis:
# Zusätzlich zu ‘00’ kann in der 3. und 4. Stelle ‘90’ bis ‘98’ individuell genutzt werden, um spezialisierte
# Fachabteilungen zu verschlüsseln, für die kein bundeseinheitlicher Fachabteilungsschlüssel vorgesehen ist
# Kombination aus Name und Schlüssel notwendig, da bei Gefäßchirgurgie auch häufig der Allgemeine Chirurgie Schlüssel verwendet wird (1500)

# Funktion zum Filtern gefäß-relevanter Dateien
filter_gefaess_dateien <- function(ordnerpfad) {
  
  # Alle relevanten XML-Dateien finden
  xml_files <- list.files(ordnerpfad, pattern = "-xml\\.xml$", full.names = TRUE)
  
  # Gefäß-relevante Schlüssel (inkl. individueller Erweiterungen)
  GC_Schluessel <- c("1800", 
                     "1890", "1891", "1892", "1893", "1894", "1895", "1896", "1897", "1898", 
                     "1518", "1550", "2118")
  
  # Initialisierung
  gefaess_files <- c()
  
  # Über alle XML-Dateien iterieren
  for (xml_file in xml_files) {
    qb_first <- read_xml(xml_file)
    
    # Name der Fachabteilung auslesen
    namen <- xml_text(xml_find_all(qb_first, ".//Organisationseinheit_Fachabteilung/Name"))
    
    # FA_Schlüssel auslesen
    schluessel <- xml_text(xml_find_all(qb_first, ".//Organisationseinheit_Fachabteilung/Fachabteilungsschluessel/FA_Schluessel"))
    
    # Prüfen, ob entweder "gefäß" im Namen vorkommt oder passender Schlüssel enthalten ist
    if (any(str_detect(namen, regex("gefäß", ignore_case = TRUE))) || any(schluessel %in% GC_Schluessel)) {
      gefaess_files <- c(gefaess_files, xml_file)
    }
  }
  
  # Ergebnis zurückgeben
  return(gefaess_files)
}
