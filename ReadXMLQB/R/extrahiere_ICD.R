extrahiere_icd_codes <- function(xml_file_vec, icd_prefix = "I71", schluessel_liste = NULL) {
  alle_icd_codes <- c()
  
  # Falls keine Schlüssel übergeben wurden, Default setzen
  if (is.null(schluessel_liste)) {
    schluessel_liste <- c("1800", "1890", "1891", "1892", "1893", "1894", "1895", "1896", "1897", "1898",
                          "1518", "1550", "2118")
  }
  
  for (file in xml_file_vec) {
    qb <- read_xml(file)
    fachabteilungen <- xml_find_all(qb, ".//Organisationseinheit_Fachabteilung")
    
    gefaess_node <- NULL
    for (node in fachabteilungen) {
      name_node <- xml_text(xml_find_first(node, "./Name"))
      schluessel_node <- xml_text(xml_find_first(node, ".//Fachabteilungsschluessel/FA_Schluessel"))
      
      if (
        str_detect(name_node, regex("gefäß", ignore_case = TRUE)) ||
        schluessel_node %in% schluessel_liste
      ) {
        gefaess_node <- node
        break
      }
    }
    
    if (!is.null(gefaess_node)) {
      hauptdiagnosen <- xml_find_all(gefaess_node, ".//Hauptdiagnose")
      icd_codes <- xml_text(xml_find_all(hauptdiagnosen, ".//ICD_10"))
      
      icd_match <- icd_codes[str_starts(icd_codes, icd_prefix)]
      alle_icd_codes <- c(alle_icd_codes, icd_match)
    }
  }
  
  return(sort(unique(alle_icd_codes)))
}
