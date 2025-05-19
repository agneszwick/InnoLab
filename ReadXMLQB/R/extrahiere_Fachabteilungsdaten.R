extrahiere_Fachabteilungsdaten <- function(xml_file,
                                           schluessel_liste = NULL,
                                           alle_icd_codes = NULL) {
  qb <- xml2::read_xml(xml_file)
  fachabteilungen <- xml2::xml_find_all(qb, ".//Organisationseinheit_Fachabteilung")
  
  if (is.null(schluessel_liste)) {
    schluessel_liste <- c("1800", "1890", "1891", "1892", "1893", "1894", "1895",
                          "1896", "1897", "1898", "1518", "1550", "2118")
  }
  
  ergebnisse <- list()
  
  for (fach_node in fachabteilungen) {
    name_node <- xml2::xml_text(xml2::xml_find_first(fach_node, "./Name"))
    schluessel_nodes <- xml2::xml_find_all(fach_node, ".//Fachabteilungsschluessel/FA_Schluessel")
    schluessel_values <- xml2::xml_text(schluessel_nodes)
    
    if (
      stringr::str_detect(name_node, regex("gefäß", ignore_case = TRUE)) ||
      any(schluessel_values %in% schluessel_liste)
    ) {
      vollstationaere <- xml2::xml_text(xml2::xml_find_first(fach_node, ".//Fallzahlen_OE/Vollstationaere_Fallzahl"))
      teilstationaere <- xml2::xml_text(xml2::xml_find_first(fach_node, ".//Fallzahlen_OE/Teilstationaere_Fallzahl"))
      
      # ICD-Zähler initialisieren
      icd_counts <- setNames(rep(0, length(alle_icd_codes)), alle_icd_codes)
      
      if (!is.null(alle_icd_codes)) {
        hauptdiagnosen <- xml2::xml_find_all(fach_node, ".//Hauptdiagnose")
        icd_codes <- xml2::xml_text(xml2::xml_find_all(hauptdiagnosen, ".//ICD_10"))
        fallzahlen <- as.integer(xml2::xml_text(xml2::xml_find_all(hauptdiagnosen, ".//Fallzahl")))
        
        for (i in seq_along(icd_codes)) {
          code <- icd_codes[i]
          if (code %in% alle_icd_codes) {
            icd_counts[code] <- icd_counts[code] + fallzahlen[i]
          }
        }
      }
      
      ergebnisse[[length(ergebnisse) + 1]] <- tibble::tibble(
        Datei = basename(xml_file),
        FA_Name = name_node,
        FA_Schluessel = paste(schluessel_values, collapse = ", "),
        FA_Vollstationaere_Fallzahl = as.integer(vollstationaere),
        FA_Teilstationaere_Fallzahl = as.integer(teilstationaere),
        !!!as.list(icd_counts)
      )
    }
  }
  
  if (length(ergebnisse) > 0) {
    return(dplyr::bind_rows(ergebnisse))
  } else {
    return(NULL)
  }
}
