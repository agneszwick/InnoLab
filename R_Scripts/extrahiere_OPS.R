extrahiere_ops_codes <- function(xml_file_vec, ops_prefix = "5-", schluessel_liste = NULL) {
  alle_ops_codes <- c()
  
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
      prozeduren <- xml_find_all(gefaess_node, ".//Prozedur")
      ops_codes <- xml_text(xml_find_all(prozeduren, ".//OPS_301"))
      
      ops_match <- ops_codes[str_starts(ops_codes, ops_prefix)]
      alle_ops_codes <- c(alle_ops_codes, ops_match)
    }
  }
  
  return(sort(unique(alle_ops_codes)))
}
