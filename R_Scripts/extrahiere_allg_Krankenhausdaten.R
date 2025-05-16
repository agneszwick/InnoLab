extrahiere_allgemeine_krankenhausdaten <- function(xml_file) {
  qb_first <- read_xml(xml_file)
  
  # Standortinformationen
  if (length(xml_find_all(qb_first, ".//Mehrere_Standorte")) > 0) {
    Name <- xml_text(xml_find_first(qb_first, ".//Standortkontaktdaten/Name"))
    PLZ <- xml_text(xml_find_first(qb_first, ".//Standortkontaktdaten/Kontakt_Zugang/Postleitzahl"))
    Ort <- xml_text(xml_find_first(qb_first, ".//Standortkontaktdaten/Kontakt_Zugang/Ort"))
    Standortnummer <- xml_text(xml_find_first(qb_first, ".//Standortkontaktdaten/Standortnummer"))
    IK <- xml_text(xml_find_first(qb_first, ".//Standortkontaktdaten/IK"))
    
    
  } else if (length(xml_find_all(qb_first, ".//Ein_Standort")) > 0) {
    Name <- xml_text(xml_find_first(qb_first, ".//Krankenhauskontaktdaten/Name"))
    PLZ <- xml_text(xml_find_first(qb_first, ".//Krankenhauskontaktdaten/Kontakt_Zugang/Postleitzahl"))
    Ort <- xml_text(xml_find_first(qb_first, ".//Krankenhauskontaktdaten/Kontakt_Zugang/Ort"))
    Standortnummer <- xml_text(xml_find_first(qb_first, ".//Krankenhauskontaktdaten/Standortnummer"))
    IK <- xml_text(xml_find_first(qb_first, ".//Krankenhauskontaktdaten/IK"))
  } else {
    Name <- PLZ <- Ort <- Standortnummer <- IK <- NA
  }
  
  Anzahl_Betten <- xml_text(xml_find_first(qb_first, ".//Anzahl_Betten"))
  Vollstationaere_Fallzahl <- xml_text(xml_find_first(qb_first, ".//Fallzahlen/Vollstationaere_Fallzahl"))
  Teilstationaere_Fallzahl <- xml_text(xml_find_first(qb_first, ".//Fallzahlen/Teilstationaere_Fallzahl"))
  Ambulante_Fallzahl <- xml_text(xml_find_first(qb_first, ".//Fallzahlen/Ambulante_Fallzahl"))
  
  # DataFrame mit allgemeinen Krankenhausdaten
  df <- tibble::tibble(
    Datei = basename(xml_file),
    Name = Name,
    PLZ = PLZ,
    Ort = Ort,
    Standortnummer = Standortnummer,
    IK = IK,
    Anzahl_Betten = Anzahl_Betten,
    Vollstationaere_Fallzahl = Vollstationaere_Fallzahl,
    Teilstationaere_Fallzahl = Teilstationaere_Fallzahl,
    Ambulante_Fallzahl = Ambulante_Fallzahl
  )
  
  return(df)
}
