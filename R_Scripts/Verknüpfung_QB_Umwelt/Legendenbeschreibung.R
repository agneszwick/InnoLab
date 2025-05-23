library(tibble)

Legende_INKAR <- tribble(
  ~Variabel,                  ~Beschreibung,
  "Bodenfläche gesamt qkm",   "Katasterfläche in km²",
  "Bevölkerung gesamt",       "Zahl der Einwohner insgesamt",
  "Bevölkerung männlich",     "Zahl der männlichen Einwohner",
  "Bevölkerung weiblich",     "Zahl der weiblichen Einwohner",
  "Bevölkerung (korrigiert)", "Zensuskorrigierte Zahl der Einwohner insgesamt (mit Korrektur VZ 1987/Zensus 2011)",
  "Erwerbsfähige 15-65",      "Zahl der Einwohner im Alter von 15 bis unter 65 Jahren",
  "Erwerbstätige",            "Zahl der Erwerbstätigen in 1000 Personen",
  "Sozialversicherungspflichtig Arbeitsort", "Zahl der sozialversicherungspflichtig Beschäftigten am Arbeitsort insgesamt",
  "Sozialversicherungspflichtig Wohnort",    "Zahl der sozialversicherungspflichtig Beschäftigten am Wohnort insgesamt",
  "Arbeitslose",              "Zahl der Arbeitslosen insgesamt",
  "Bruttoinlandsprodukt in 1000 Euro", "Bruttoinlandsprodukt (BIP) absolut in Millionen Euro",
  "Beschäftigungsquote",             "SV Beschäftigte am Wohnort je 100 Einwohner im erwerbsfähigen Alter in %",
  "Beschäftigungsquote Frauen",      "SV beschäftigte Frauen am Wohnort je 100 Frauen im erwerbsfähigen Alter in %",
  "Beschäftigungsquote Männer",      "SV beschäftigte Männer je 100 Männer im erwerbsfähigen Alter in %",
  "Beschäftigungsquote Ausländer",   "SV beschäftigte Ausländer je 100 erwerbsfähige Ausländer in %",
  "Verhältnis junge zu alte Erwerbsfähige", "Verhältnis junge (15-<20J) zu alte (60-<65J) Erwerbsfähige in %",
  "Quote jüngere Beschäftigte",      "SV Beschäftigte im Alter 15 bis unter 30 Jahre je 100 Einwohner dieser Altersgruppe in %",
  "Quote ältere Beschäftigte",       "SV Beschäftigte im Alter 55 bis unter 65 Jahre je 100 Einwohner dieser Altersgruppe in %",
  "Teilzeitbeschäftigte",            "Anteil der SV Beschäftigten am Arbeitsort (Teilzeit) an den SV Beschäftigten in %",
  "Teilzeitbeschäftige Frauen",      "Anteil der SV beschäftigten Frauen am Arbeitsort (Teilzeit) an allen SV beschäftigten Frauen in %",
  "Erwerbsquote",                    "Erwerbspersonen je 100 Einwohner im erwerbsfähigen Alter in %",
  "Erwerbsquote Frauen",             "Weibliche Erwerbspersonen je 100 Frauen im erwerbsfähigen Alter in %",
  "Erwerbsquote Männer",             "Männliche Erwerbspersonen je 100 Männer im erwerbsfähigen Alter in %",
  "Selbständigenquote",              "Selbständige je 100 Erwerbstätige in %",
  "Beschäftigte am AO mit akademischem Berufsabschluss", 
  "Anteil der SV Beschäftigten am Arbeitsort mit akademischem Berufsabschluss an den SV Beschäftigten in %",
  "Beschäftigte am AO mit Berufsabschluss",  
  "Anteil der SV Beschäftigten am Arbeitsort mit Berufsabschluss an den SV Beschäftigten in %",
  "Beschäftigte am AO ohne Berufsabschluss", 
  "Anteil der SV Beschäftigten am Arbeitsort ohne Berufsabschluss an den SV Beschäftigten in %",
  "Beschäftigte am WO mit akademischen Abschluss", 
  "Anteil der SV Beschäftigten am Wohnort mit akademischem Berufsabschluss an den SV Beschäftigten in %",
  "Beschäftigte am WO mit Berufsabschluss",  
  "Anteil der SV Beschäftigten am Wohnort mit Berufsabschluss an den SV Beschäftigten in %",
  "Beschäftigte am WO ohne Berufsabschluss",  
  "Anteil der SV Beschäftigten am Wohnort ohne Berufsabschluss an den SV Beschäftigten in %",
  "Beschäftigte mit Anforderungsniveau Experte",  
  "Anteil der SV Beschäftigten am Arbeitsort mit Anforderungsniveau Experte an den SV Beschäftigten in %",
  "Beschäftigte mit Anforderungsniveau Spezialist", 
  "Anteil der SV Beschäftigten am Arbeitsort mit Anforderungsniveau Spezialist an den SV Beschäftigten in %",
  "Beschäftigte mit Anforderungsniveau Fachkraft",  
  "Anteil der SV Beschäftigten am Arbeitsort mit Anforderungsniveau Fachkraft an den SV Beschäftigten in %",
  "Beschäftigte mit Anforderungsniveau Helfer",    
  "Anteil der SV Beschäftigten am Arbeitsort mit Anforderungsniveau Helfer an den SV Beschäftigten in %",
  "Beschäftigte Primärer Sektor",  
  "Anteil der SV Beschäftigten am Arbeitsort im Primären Sektor an den SV Beschäftigten in %",
  "Beschäftigte Sekundärer Sektor",  
  "Anteil der SV Beschäftigten am Arbeitsort im Sekundären Sektor an den SV Beschäftigten in %",
  "Beschäftigte Tertiärer Sektor",  
  "Anteil der SV Beschäftigten am Arbeitsort im Tertiären Sektor an den SV Beschäftigten in %",
  "Industriequote",  
  "SV Beschäftigte am Arbeitsort in der Industrie je 100 Einwohner im erwerbsfähigen Alter in %",
  "Dienstleistungsquote",  
  "SV Beschäftigte am Arbeitsort im Dienstleistungssektor je 100 Einwohner im erwerbsfähigen Alter in %",
  "Beschäftigte in unternehmensbezogenen Dienstleistungen",  
  "Anteil der SV Beschäftigten am Arbeitsort in wissensintensiven unternehmensbezogenen Dienstleistungsbranchen an den SV Beschäftigten in %",
  "Beschäftigte in Kreativbranchen",  
  "Anteil der SV Beschäftigten am Arbeitsort in Kreativbranchen an den SV Beschäftigten in %",
  "Beschäftigte in wissensintensiven Industrien",  
  "Anteil der SV Beschäftigten am Arbeitsort in wissens- u. forschungsintensiven Industrien an den SV Beschäftigten in %",
  "Beschäftigte in IT- und naturwissenschaftlichen Dienstleistungsberufen",  
  "Anteil der sozialversicherungspflichtig Beschäftigten in IT- und naturwissenschaftlichen Dienstleistungsberufen an den SV Beschäftigten in %",
  "Beschäftigte im Handwerk",  
  "Anteil der SV Beschäftigten am Arbeitsort in Handwerksbetrieben an den SV Beschäftigten in %",
  "Erwerbstätige Primärer Sektor",  
  "Anteil der Erwerbstätigen im Primären Sektor an den Erwerbstätigen in %",
  "Erwerbstätige Sekundärer Sektor",  
  "Anteil der Erwerbstätigen im Sekundären Sektor an den Erwerbstätigen in %",
  "Erwerbstätige Tertiärer Sektor",  
  "Anteil der Erwerbstätigen im Tertiären Sektor an den Erwerbstätigen in %",
  "Anteil Erwerbstätige Verarbeitendes Gewerbe an Industrie",  
  "Anteil der Erwerbstätigen im Verarbeitenden Gewerbe an den Erwerbstätigen im Sekundären Sektor in %",
  "Anteil Erwerbstätige Finanz- und Unternehmensdienstleistungen",  
  "Anteil der Erwerbstätigen in Finanz-, Versicherungs- und Unternehmensdienstleistungen sowie im Grundstücks- und Wohnungswesen an den Erwerbstätigen im Tertiären Sektor in %",
  "Beschäftigte im Baugewerbe",  
  "Anteil der SV Beschäftigten am Arbeitsort im Baugewerbe an den SV Beschäftigten in %",
  "Ausländeranteil",      "Anteil der Ausländer an den Einwohnern in %",
  "Haushaltsgröße",       "Personen je Haushalt",
  "Einpersonenhaushalt",  "Anteil der Einpersonenhaushalte an den Haushalten insgesamt in %",
  "Haushalte mit Kindern","Anteil der Haushalte mit Kindern an allen Haushalten in %",
  "Siedlungs- und Verkehrsfläche",  "Anteil der Siedlungs- und Verkehrsfläche an der Fläche in %",
  "Siedlungsdichte in km²",          "Einwohner je km² Siedlungs- und Verkehrsfläche",
  "Erholungsfläche",                 "Anteil Erholungsfläche an der Fläche in %",
  "Erholungsfläche je Einwohner",    "Erholungsfläche je Einwohner in m²",
  "Freifläche",                     "Anteil Freifläche an der Fläche in %",
  "Freifläche je Einwohner",         "Freifläche je Einwohner in m²",
  "Landwirtschaftsfläche",           "Anteil Landwirtschaftsfläche an der Fläche in %",
  "Naturnähere Fläche",              "Anteil naturnähere Fläche an der Fläche in %",
  "Naturnähere Fläche je Einwohner", "Naturnähere Fläche je Einwohner in m²",
  "Waldfläche",                     "Anteil Waldfläche an der Fläche in %",
  "Wasserfläche",                   "Anteil Wasserfläche an der Fläche in %",
  "Krankenhausbetten", "Krankenhausbetten je 1.000 Einwohner",
  "Ärzte",             "Ärzte je 10.000 Einwohner",
  "Hausärzte",         "Hausärzte je 10.000 Einwohner",
  "Allgemeinärzte",    "Allgemeinärzte je 10.000 Einwohner",
  "Internisten",       "Internisten je 10.000 Einwohner",
  "Kinderärzte",       "Kinderärzte je 10.000 Einwohner",
  "Pflegebedürftige",        "Pflegebedürftige je 100 Einwohner",
  "Ambulante Pflege",        "Anteil der Pflegebedürftigen in ambulanter Pflege an den Pflegebedürftigen insgesamt in %",
  "Stationäre Pflege",       "Anteil der Pflegebedürftigen in stationärer Dauerpflege an den Pflegebedürftigen insgesamt in %",
  "Empfänger Pflegegeld",    "Anteil der Empfänger von Pflegegeld an den Pflegebedürftigen insgesamt in %",
  "Personal in Pflegeheimen", "Personal in Pflegeheimen je 100 vollstationärer Pflegebedürftiger",
  "Personal in Pflegediensten", "Personal in ambulanten Pflegediensten je 100 ambulanter Pflegebedürftiger",
  "Pflegeheimplätze",        "Verfügbare Plätze in Pflegeheimen je 10.000 Einwohner",
  "Ländlichkeit",              "Anteil der Einwohner in Gemeinden mit einer Bevölkerungsdichte von unter 150 E/km²",
  "Bevölkerung in Mittelzentren", "Bevölkerungsanteil, der in Mittelzentren und möglichen Mittelzentren lebt",
  "Bevölkerung in Oberzentren", "Bevölkerungsanteil, der in Oberzentren und möglichen Oberzentren lebt",
  "Einwohnerdichte",           "Einwohner je km²",
  "Einwohner-Arbeitsplatz-Dichte", "Einwohner und Beschäftigte je km²",
  "SGB II - Quote",                     "Anteil der erwerbsfähigen und nicht erwerbsfähigen Leistungsberechtigten nach SGB II an den unter 65-jährigen Einwohnern in %",
  "Weibliche SGB II-Empfänger",         "Anteil weibliche erwerbsfähige Leistungsberechtigte nach SGB II an allen SGB II Empfängern in %",
  "Wohngeldhaushalte",                  "Anteil der Haushalte, die Wohngeld empfangen je 1.000 Haushalte",
  "Empfänger von Grundsicherung im Alter (Altersarmut)", "Anteil der Bevölkerung mit Grundsicherung im Alter an den Einwohnern 65 Jahre und älter in %",
  "Empfänger von Mindestsicherungen",  "Anteil der Bevölkerung mit sozialen Mindestsicherungsleistungen in %",
  "SGB II-/SGB XII-Quote",                     "Anteil Leistungsbeziehende nach SGB II und nach SGB XII je 1.000 Einwohner",
  "Kinderarmut",                               "Nicht erwerbsfähige Leistungsberechtigte unter 15 Jahren je 100 Einwohner unter 15 Jahren",
  "Empfänger von Grundsicherung im Alter (Altersarmut)", "Anteil der Bevölkerung mit Grundsicherung im Alter an den Einwohnern 65 Jahre und älter in %",
  "Stickstoffüberschuss",                      "Überschuss der Stickstoff-Flächenbilanz der landwirtschaftlich genutzten Fläche in kg N /ha LN",
  "Vorzeitige Sterblichkeit Frauen",           "Todesfälle von Frauen im Alter von unter 70 Jahren je 1.000 Frauen im Alter von unter 70 Jahren",
  "Vorzeitige Sterblichkeit Männer",           "Todesfälle von Männern im Alter von unter 70 Jahren je 1.000 Männern im Alter von unter 70 Jahren",
  "Wohnungsnahe Grundversorgung Hausarzt",     "Einwohnergewichtete Luftliniendistanz zum nächsten Hausarzt",
  "Krankenhausversorgung",                      "Krankenhausbetten je 1000 Einwohner",
  "Wohnungsnahe Grundversorgung Apotheke",     "Einwohnergewichtete Luftliniendistanz zur nächsten Apotheke",
  "Personal in Pflegeheimen",                    "Personal in Pflegeheimen je 10.000 stationär Pflegebedürftige",
  "Personal in Pflegediensten",                  "Personal in ambulanten Pflegediensten je 10.000 Einwohner",
  "Pflegeheimplätze",                            "Verfügbare Plätze in Pflegeheimen je 10.000 Einwohner",
  "Wohnungsnahe Grundversorgung Grundschule",   "Einwohnergewichtete Luftliniendistanz zur nächsten Grundschule",
  "Schulabgänger ohne Abschluss",                "Anteil der Schulabgänger ohne Hauptschulabschluss an den Schulabgängern in %",
  "Betreuungsquote Kleinkinder",                  "Anteil der Kinder unter 3 Jahren in Kindertageseinrichtungen an den Kinder der entsprechenden Altersgruppe",
  "Integrative Kindertageseinrichtungen",         "Anteil der integrativen Kindertageseinrichtungen an allen Kindertageseinrichtungen",
  "Verhältnis der Beschäftigungsquote von Frauen zu Männern", "SV Beschäftigtenquote der Frauen am Wohnort je SV Beschäftigtenquote der Männer am Wohnort in %",
  "Frauenanteil in Stadträten und Kreistagen",  "Anzahl Frauen mit Mandaten in Stadträten und Kreistagen an allen Mandaten in %",
  "Bruttoinlandsprodukt je Einwohner",          "Bruttoinlandsprodukt in € je Einwohner",
  "Langzeitarbeitslose",                         "Anteil der Arbeitslosen, 1 Jahr und länger arbeitslos, an den Arbeitslosen in %",
  "Beschäftigungsquote",                         "SV Beschäftigte am Wohnort je 100 Einwohner im erwerbsfähigen Alter in %",
  "Quote ältere Beschäftigte",                    "SV Beschäftigte am Wohnort im Alter von über 55 Jahren je 100 Einwohner dieser Altersgruppe in %",
  "Aufstocker",                                  "Anteil erwerbstätiger ALGII-Bezieher (Aufstocker) an den abhängig Beschäftigten",
  "Angebotsmietpreise",                          "Wiedervermietungsmieten inserierter Wohnungen (Angebotsmieten)",
  "Beschäftigte am AO mit akademischem Berufsabschluss", "SV Beschäftigte am Arbeitsort mit akademischem Berufsabschluss an den SV Beschäftigten in %",
  "Bandbreitenverfügbarkeit mindestens 100 Mbit/s", "Anteil der Haushalte mit einer Bandbreitenverfügbarkeit (leitungsgebunden) mit mindestens 100 Mbit/s in %",
  "Beschäftigtenquote Ausländer",                "Verhältnis der Beschäftigungsquote ausländischer Staatsbürger zur Beschäftigungsquote insgesamt",
  "Einbürgerungen je Ausländer",                  "Anzahl der eingebürgerten Personen an den Einwohnern ausländischer Staatsbürgerschaft",
  "Wohnfläche",                                  "Verfügbare Wohnfläche je Einwohner",
  "Wohnungsnahe Grundversorgung Supermarkt",    "Einwohnergewichtete Luftliniendistanz zum nächsten Supermarkt/Discounter",
  "Pkw-Dichte",                                  "Anzahl der Pkw je 1.000 Einwohner",
  "Verunglückte im Straßenverkehr",              "Verunglückte im Straßenverkehr je 100.000 Einwohner",
  "Siedlungs- und Verkehrsfläche",                "Anteil der Siedlungs- und Verkehrsfläche an der Gesamtfläche in %",
  "Flächenneuinanspruchnahme",                   "Änderung der Siedlungs- und Verkehrsfläche an der Gesamtfläche im Vergleich zum Vorjahr",
  "Siedlungs- und Verkehrsfläche je Einwohner", "Siedlungs- und Verkehrsfläche je Einwohner",
  "Erholungsfläche je Einwohner",                "Erholungsfläche in m² je Einwohner",
  "Fertiggestellte Wohngebäude mit erneuerbarer Heizenergie", "Anteil fertiggestelle Wohngebäude mit erneuerbarer Heizenergie an allen Wohngebäuden in %",
  "Trinkwasserverbrauch",                        "Wasserabgabe an Letztverbraucher (Haushalte und Kleingewerbe) in l je Einwohner und Tag",
  "Abfallmenge",                                 "Entsorgte Abfallmenge in kg je Einwohner",
  "Steuereinnahmen",                             "Steuereinnahmen der Gemeinden und Gemeindeverbände in Euro je Einwohner",
  "Kassenkredite",                               "Kassenkredite im Kernhaushalt je Einwohner",
  
  )
  


head(Legende_INKAR)
# Doppelte Einträge entfernen (basierend auf variable)
Legende_INKAR <- Legende_INKAR %>%
  distinct(Variabel, .keep_all = TRUE)

print(Legende_INKAR)



library(tibble)

dwd_legende <- tribble(
  ~Variabel,                          ~Beschreibung,
  "Lufttemperatur_max_J_2023_mean",  "Jahresmittel des monatlich gemittelten täglichen Lufttemperaturmaximums in 2 m Höhe, in °C.",
  "Lufttemperatur_max_J_2023_median","Jahresmittel des monatlich gemittelten täglichen Lufttemperaturmaximums in 2 m Höhe, in °C.",
  
  "Lufttemperatur_mean_J_2023_mean", "Jahresmittel der monatlich gemittelten täglichen Lufttemperatur in 2 m Höhe, in °C.",
  "Lufttemperatur_mean_J_2023_median","Jahresmittel der monatlich gemittelten täglichen Lufttemperatur in 2 m Höhe, in °C.",
  
  "Lufttemperatur_min_J_2023_mean",  "Jahresmittel des monatlich gemittelten täglichen Lufttemperaturminimums in 2 m Höhe, in °C.",
  "Lufttemperatur_min_J_2023_median", "Jahresmittel des monatlich gemittelten täglichen Lufttemperaturminimums in 2 m Höhe, in °C.",
  
  "Dürreindex_J_2023_mean",          "Jährlicher Trockenheitsindex nach de Martonne, Einheit: mm/°C.",
  "Dürreindex_J_2023_median",        "Jährlicher Trockenheitsindex nach de Martonne, Einheit: mm/°C.",
  
  "Hitzetage_J_2023_mean",           "Anzahl der Heißen Tage; Definition Heißer Tag: Maximum der Lufttemperatur >= 30°C",
  "Hitzetage_J_2023_median",         "Anzahl der Heißen Tage; Definition Heißer Tag: Maximum der Lufttemperatur >= 30°C",
  
  "Niederschlag_J_2023_mean",        "Jahressumme der Niederschlagshöhe in mm",
  "Niederschlag_J_2023_median",      "Jahressumme der Niederschlagshöhe in mm",
  
  "Sonnenscheindauer_J_2023_mean",   "Jahressumme der Sonnenscheindauer in h",
  "Sonnenscheindauer_J_2023_median", "Jahressumme der Sonnenscheindauer in h",
  
  "Tropische_Naechte_2023_mean",     "Anzahl der Tropennächte (Minimum >= 20 °C), Temperatur in 2 m",
  "Tropische_Naechte_2023_median",   "Anzahl der Tropennächte (Minimum >= 20 °C), Temperatur in 2 m"
)

# Falls du Legende_INKAR schon hast:
Legende <- bind_rows(Legende_INKAR, dwd_legende)

QB <- tribble(
  ~Variabel,                          ~Beschreibung,
  "Min_Anzahl_Aneurysma_rupturiert_J_2023", "Häufigkeit der NA-Werte und Summe der Werte von allen rupturierten Aneurysma-Hautpdiagnosen von allen gefäßchirurgischen Fachabteilungen in einem Landkreis",
  "Max_Anzahl_Aneurysma_rupturiert_J_2023", "Häufigkeit der NA-Werte * 3 (da bei Anzahl < 4 wegen Datenschutz die Anzahl auf NA gesetzt wird) und Summe der Werte von allen rupturierten Aneurysma-Hautpdiagnosen von allen gefäßchirurgischen Fachabteilungen in einem Landkreis",
  "Min_Anzahl_Dissektion_rupturiert_J_2023", "Häufigkeit der NA-Werte und Summe der Werte von allen rupturierten Dissektion-Hautpdiagnosen von allen gefäßchirurgischen Fachabteilungen in einem Landkreis",
  "Max_Anzahl_Dissektion_rupturiert_J_2023", "Häufigkeit der NA-Werte * 3 (da bei Anzahl < 4 wegen Datenschutz die Anzahl auf NA gesetzt wird) und Summe der Werte von allen rupturierten Dissektion-Hautpdiagnosen von allen gefäßchirurgischen Fachabteilungen in einem Landkreis"
)

Legende <- bind_rows(Legende, QB)

lärm_beschreibung <- "Anteil der Fläche des Landkreises, die in der jeweiligen Lärmklasse (Dezibel-Bereich, Lden) liegt. Die Zahl gibt den Flächenanteil an, z.B. 55_J_2017 = Anteil der Fläche mit Lärmpegel bis 55 dB(A), 60_J_2017 = Anteil der Fläche mit Lärmpegel zwischen 55 und 60 dB(A), usw."

lärm_abschnitt_vars <- c("55_J_2017", "60_J_2017", "65_J_2017", "70_J_2017", "75_J_2017")

lärm_beschreibungen <- tibble(
  Variabel = lärm_abschnitt_vars,
  Beschreibung = lärm_beschreibung
)

Legende <- bind_rows(Legende, lärm_beschreibungen)


flächenanteil_beschreibung <- "Prozentualer Anteil der Landkreisfläche, die von der jeweiligen Landnutzungsklasse bedeckt wird."

flächenanteil_vars <- c(
  "111_Durchgaengig_staedtische_Praegung_J_2018",
  "112_Nicht_durchgaengig_staedtische_Praegung_J_2018",
  "121_Industrie_und_Gewerbeflaechen,_oeffentliche_Einrichtungen_J_2018",
  "123_Hafengebiete_J_2018",
  "124_Flughaefen_J_2018",
  "141_Staedtische_Gruenflaechen_J_2018",
  "142_Sport-_und_Freizeitanlagen_J_2018",
  "211_Nicht_bewaessertes_Ackerland_J_2018",
  "231_Wiesen_und_Weiden_J_2018",
  "311_Laubwaelder_J_2018",
  "312_Nadelwaelder_J_2018",
  "313_Mischwaelder_J_2018",
  "324_Wald-Strauch-Übergangsstadien_J_2018",
  "521_Lagunen_J_2018",
  "523_Meere_und_Ozeane_J_2018",
  "122_Strassen-,_Eisenbahnnetze_und_funktionell_zugeordnete_Flaechen_J_2018",
  "243_Landwirtschaftlich_genutztes_Land_mit_Flaechen_natuerlicher_Bodenbedeckung_von_signifikanter_Groesse_J_2018",
  "411_Suempfe_J_2018",
  "511_Gewaesserlaeufe_J_2018",
  "512_Wasserflaechen_J_2018",
  "131_Abbauflaechen_J_2018",
  "132_Deponien_und_Abraumhalden_J_2018",
  "321_Natuerliches_Gruenland_J_2018",
  "322_Heiden_und_Moorheiden_J_2018",
  "412_Torfmoore_J_2018",
  "242_Komplexe_Parzellenstruktur_J_2018",
  "331_Straende,_Duenen_und_Sandflaechen_J_2018",
  "421_Salzwiesen_J_2018",
  "423_In_der_Gezeitenzone_liegende_Flaechen_J_2018",
  "522_Muendungsgebiete_J_2018",
  "222_Obst-_und_Beerenobstbestaende_J_2018",
  "333_Flaechen_mit_spaerlicher_Vegetation_J_2018",
  "133_Baustellen_J_2018",
  "221_Weinbauflaechen_J_2018",
  "332_Felsen_ohne_Vegetation_J_2018",
  "335_Gletscher_und_Dauerschneegebiete_J_2018"
)

flächenanteil_legende <- tibble(
  Variabel = flächenanteil_vars,
  Beschreibung = flächenanteil_beschreibung
)

# Beispiel: Mit bestehender Legende zusammenführen
Legende <- bind_rows(Legende, flächenanteil_legende)

write.csv(Legende, "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Kreisebene/Spaltenbeschreibung.csv")




