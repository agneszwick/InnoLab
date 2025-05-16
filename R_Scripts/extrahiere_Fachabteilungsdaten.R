extrahiere_Fachabteilungsdaten <- function(xml_file,
                                           schluessel_liste = NULL,
                                           alle_icd_codes = NULL) {
  qb_first <- read_xml(xml_file)
  
  # Standardschlüssel setzen
  if (is.null(schluessel_liste)) {
    schluessel_liste <- c("1800", "1890", "1891", "1892", "1893", "1894", "1895",
                          "1896", "1897", "1898", "1518", "1550", "2118")
  }
  
  # Fachabteilung suchen
  fachabteilungen <- xml_find_all(qb_first, ".//Organisationseinheit_Fachabteilung")
  gefaess_node <- NULL
  for (node in fachabteilungen) {
    name_node <- xml_text(xml_find_first(node, "./Name"))
    schluessel_node <- xml_text(xml_find_first(node, ".//Fachabteilungsschluessel/FA_Schluessel"))
    
    if (str_detect(name_node, regex("gefäß", ignore_case = TRUE)) ||
        schluessel_node %in% schluessel_liste) {
      gefaess_node <- node
      break
    }
  }
  
  # Basiswerte setzen
  Datei <- basename(xml_file)
  GC_Name <- GC_Vollstationaere_Fallzahl <- GC_Teilstationaere_Fallzahl <- NA
  icd_counts <- setNames(rep(0, length(alle_icd_codes)), alle_icd_codes)
  
  if (!is.null(gefaess_node)) {
    GC_Name <- xml_text(xml_find_first(gefaess_node, ".//Name"))
    GC_Vollstationaere_Fallzahl <- xml_text(xml_find_first(gefaess_node, ".//Fallzahlen_OE/Vollstationaere_Fallzahl"))
    GC_Teilstationaere_Fallzahl <- xml_text(xml_find_first(gefaess_node, ".//Fallzahlen_OE/Teilstationaere_Fallzahl"))
    
    if (!is.null(alle_icd_codes)) {
      hauptdiagnosen <- xml_find_all(gefaess_node, ".//Hauptdiagnose")
      icd_codes <- xml_text(xml_find_all(hauptdiagnosen, ".//ICD_10"))
      fallzahlen <- as.integer(xml_text(xml_find_all(hauptdiagnosen, ".//Fallzahl")))
      
      # Filtern & Aggregieren
      for (i in seq_along(icd_codes)) {
        code <- icd_codes[i]
        if (code %in% alle_icd_codes) {
          icd_counts[code] <- icd_counts[code] + fallzahlen[i]
        }
      }
    }
  }
  
  # DataFrame erstellen
  icd_df <- tibble::tibble(
    Datei = Datei,
    GC_Name = GC_Name,
    GC_Vollstationaere_Fallzahl = GC_Vollstationaere_Fallzahl,
    GC_Teilstationaere_Fallzahl = GC_Teilstationaere_Fallzahl,
    !!!as.list(icd_counts)  # Spalten aus Named List expandieren
  )
  
  return(icd_df)
}
