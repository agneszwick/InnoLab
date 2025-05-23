# Umweltdaten - Raster/Vektor 

| Datengrundlage                                                                                                        | Temporale Auflösung                 | Räumliche Auflösung | Einheit                       | Anmerkung                                                         | Quelle                                                                                       |
| --------------------------------------------------------------------------------------------------------------------- | ----------------------------------- | ------------------- | ----------------------------- | ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| [[Noise2NAKOAI - Roud Traffic Noise, Germany 2017]]                                                                   | einmalig (2017)                     | 10 m                | Lden [dB]                     |                                                                   | https://geoservice.dlr.de/web/maps/eoc:n2nnoise                                              |
| [[Deutscher Wetterdienst (DWD)]]                                                                                      | täglich/monatlich/saisonal/jährlich | 1 km                | unterschliedlich je Datensatz |                                                                   | https://opendata.dwd.de/climate_environment/CDC/grids_germany/                               |
| [[MOD13A3 NDVI]]                                                                                                      | monatlich                           | 1 km                |                               | MOD44W wurde verwendet um Wasserflächen zu maskieren              | https://developers.google.com/earth-engine/datasets/catalog/MODIS_061_MOD13A3?hl=de          |
| [[Sentinel-5P]]  <br>SO2_column_number_density <br>O3_column_number_density<br>tropospheric_NO2_column_number_density | täglich                             | 7 km x 3.5 km       | mol/m²                        | Jährlicher Durchschnitt wird berechnet und in µmol/m² umgerechnet | https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S5P_OFFL_L3_SO2?hl=de |
| [[Copernicus CORINE Land Cover]]                                                                                      | alle 6 Jahre (aktuellstes 2018)     | 100 m               |                               |                                                                   | https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_CORINE_V20_100m?hl=de |
| [[S-VELD MODIS SLSTR Surface PM2.5 (Monthly Mean)]]                                                                   | Monatlich (Jan 2018-Dez 2019)       | 500 m               | μg/m3                         |                                                                   | https://download.geoservice.dlr.de/SVELD/files/                                              |
| [[S-VELD Sentinel-5P]] <br>Tropospheric NO2 column densities                                                          | Monatlich (Jan 2018-Dez 2020)       | 2000 m              | mol/m2                        |                                                                   | https://download.geoservice.dlr.de/SVELD/files/                                              |
| [[S-VELD Sentinel-5P]] <br>Surface NO2 concentrations                                                                 | Monatlich (Jan 2018-Dez 2020)       | 500 m               | μg/m3                         |                                                                   | https://download.geoservice.dlr.de/SVELD/files/                                              |



### World Settlement Footprint (DLR) 
## Destatis
- Bevölkerung: Kreise, Stichtag, Geschlecht, Altersgruppen (Code: 12411-0018) https://www-genesis.destatis.de/datenbank/online/statistic/12411/table/12411-0018
	- Abgespeichert unter: Bevölkerung
- Empfänger von Grundsicherung: Kreise, Berichtsmonat im Quartal, Geschlecht/Altersgruppen/Ort der Leistungserbringung (Code: 22151-0040) https://www-genesis.destatis.de/datenbank/online/statistic/22151/table/22151-0040
	- Abgespeichert unter: Empfaenger_Grundsicherung
	- 
## INKAR 
https://www.inkar.de/
Alle folgenden Werte sind von 2022 (aber ab 1995 verfügbar):
- #### Absolutzahlen
	- __Bodenfläche gesamt qkm__ (Katasterfläche in km²)
	- __Bevölkerung gesamt__ (Zahl der Einwohner insgesamt)
	- __Bevölkerung männlich__ (Zahl der männlichen Einwohner)
	- __Bevölkerung weiblich__ (Zahl der weiblichen Einwohner)
	- __Bevölkerung__ (mit Korrektur VZ 1987/Zensus 2011) (Zensuskorrigierte Zahl der Einwohner insgesamt)
	- __Erwerbsfähige Bevölkerung (15 bis unter 65 Jahre)__ (Zahl der Einwohner im Alter von 15 bis unter 65 Jahren)
	- __Erwerbstätige__ (Zahl der Erwerbstätigen in 1000 Personen)
	- __Sozialversicherungspflichtig Beschäftigte am Arbeitsort__ (Zahl der sozialversicherungspflichtig Beschäftigten am Arbeitsort insgesamt)
	- __Sozialversicherungspflichtig Beschäftigte am Wohnort__ (Zahl der sozialversicherungspflichtig Beschäftigten am Wohnort insgesamt)
	- __Arbeitslose__ (Zahl der Arbeitslosen insgesamt)
	- __Bruttoinlandsprodukt in 1000 Euro__ (Bruttoinlandsprodukt (BIP) absolut in Millionen Euro)


- #### Beschäftigung und Erwerbstätigkeit
	- __*Struktur
		- __Beschäftigungsquote__ (SV Beschäftigte am Wohnort je 100 Einwohner im erwerbsfähigen Alter in %)
		- __Beschäftigungsquote Frauen__ (SV beschäftigte Frauen am Wohnort je 100 Frauen im erwerbsfähigen Alter in %)
		- __Beschäftigungsquote Männer__ (SV beschäftigte Männer am Wohnort je 100 Männer im erwerbsfähigen Alter in %)
		- __Beschäftigungsquote Ausländer__ (SV beschäftigte Ausländer am Wohnort je 100 erwerbsfähige Ausländer in %)
		- __Verhältnis junge zu alte Erwerbsfähige__ (Verhältnis junge (15-<20J) zu alte (60-<65J) Erwerbsfähige in %)
		- __Quote jüngere Beschäftigte__ (SV Beschäftigte am Wohnort im Alter von 15 bis unter 30 Jahre je 100 Einwohner dieser Altersgruppe in %)
		- __Quote ältere Beschäftigte__ (SV Beschäftigte am Wohnort im Alter von 55 bis unter 65 Jahren je 100 Einwohner dieser Altersgruppe in %)
		- __Teilzeitbeschäftigte__ (Anteil der SV Beschäftigten am Arbeitsort (Teilzeit) an den SV Beschäftigten in %)
		- __Teilzeitbeschäftige Frauen__ (Anteil der SV beschäftigten Frauen am Arbeitsort (Teilzeit) an allen SV beschäftigten Frauen in %)
		- __Erwerbsquote__ (Erwerbspersonen je 100 Einwohner im erwerbsfähigen Alter in %)
		- __Erwerbsquote Frauen__ (Weibliche Erwerbspersonen je 100 Frauen im erwerbsfähigen Alter in %)
		- __Erwerbsquote Männer__ (Männliche Erwerbspersonen je 100 Männer im erwerbsfähigen Alter in %)
		- __Selbständigenquote__ (Selbständige je 100 Erwerbstätige in %)
	-  __*Qualifikation
		- __Beschäftigte am AO mit akademischem Berufsabschluss__ (Anteil der SV Beschäftigten am Arbeitsort mit akademischem Berufsabschluss an den SV Beschäftigten in %)
		- __Beschäftigte am AO mit Berufsabschluss__ (Anteil der SV Beschäftigten am Arbeitsort mit Berufsabschluss an den SV Beschäftigten in %)
		- __Beschäftigte am AO ohne Berufsabschluss__ (Anteil der SV Beschäftigten am Arbeitsort ohne Berufsabschluss an den SV Beschäftigten in %)
		- __Beschäftigte am WO mit akademischen Abschluss__ (Anteil der SV Beschäftigten am Wohnort mit akademischem Berufsabschluss an den SV Beschäftigten in %)
		- __Beschäftigte am WO mit Berufsabschluss__ (Anteil der SV Beschäftigten am Wohnort mit Berufsabschluss an den SV Beschäftigten in %)
		- __Beschäftigte am WO ohne Berufsabschluss__ (Anteil der SV Beschäftigten am Wohnortohne Berufsabschluss an den SV Beschäftigten in %)
		- __Beschäftigte mit Anforderungsniveau Experte__ (Anteil der SV Beschäftigten am Arbeitsort mit Anforderungsniveau Experte an den SV Beschäftigten in %)
		- __Beschäftigte mit Anforderungsniveau Spezialist__ (Anteil der SV Beschäftigten am Arbeitsort mit Anforderungsniveau Spezialist an den SV Beschäftigten in %)
		- __Beschäftigte mit Anforderungsniveau Fachkraft__ (Anteil der SV Beschäftigten am Arbeitsort mit Anforderungsniveau Fachkraft an den SV Beschäftigten in %)
		- __Beschäftigte mit Anforderungsniveau Helfer__ (Anteil der SV Beschäftigten am Arbeitsort mit Anforderungsniveau Helfer an den SV Beschäftigten in %)
	- __*Wirtschafts- und Berufszweig
		- __Beschäftigte Pimärer Sektor__ (Anteil der SV Beschäftigten am Arbeitsort im Primären Sektor an den SV Beschäftigten in %)
		- __Beschäftigte Sekundärer Sektor__ (Anteil der SV Beschäftigten am Arbeitsort im Sekundären Sektor an den SV Beschäftigten in %)
		- __Beschäftigte Tertiärer Sektor__ (Anteil der SV Beschäftigten am Arbeitsort im Tertiären Sektor an den SV Beschäftigten in %)
		- __Industriequote__ (SV Beschäftigte am Arbeitsort in der Industrie je 100 Einwohner im erwerbsfähigen Alter in %)
		- __Dienstleistungsquote__ (SV Beschäftigte am Arbeitsort im Dienstleistungssektor je 100 Einwohner im erwerbsfähigen Alter in %)
		- __Beschäftigte in unternehmensbezogenen Dienstleistungen__ (Anteil der SV Beschäftigten am Arbeitsort in wissensintensiven unternehmensbezogenen Dienstleistungsbranchen an den SV Beschäftigten in %)
		- __Beschäftigte in Kreativbranchen__ (Anteil der SV Beschäftigten am Arbeitsort in Kreativbranchen an den SV Beschäftigten in %)
		- __Beschäftigte in wissensintensiven Industrien__ (Anteil der SV Beschäftigten am Arbeitsort in wissens- u. forschungsintensiven Industrien an den SV Beschäftigten in %)
		- __Beschäftigte in IT- und naturwissenschaftlichen Dienstleistungsberufen__ (Anteil der sozialversicherungspfichtig Beschäftigten in IT- und naturwissenschaftlichen Dienstleistungsberufen an den SV Beschäftigten in %)
		- __Beschäftigte im Handwerk__ (Anteil der SV Beschäftigte am Arbeitsort in Handwerksbetrieben an den SV Beschäftigten in %)
		- __Erwerbstätige Primärer Sektor__ (Anteil der Erwerbstätigen im Primären Sektor an den Erwerbstätigen in %)
		- __Erwerbstätige Sekundärer Sektor__ (Anteil der Erwerbstätigen im Sekundären Sektor an den Erwerbstätigen in %)
		- __Erwerbstätige Tertiärer Sektor__ (Anteil der Erwerbstätigen im Tertiären Sektor an den Erwerbstätigen in %)
		- __Anteil Erwerbstätige Verarbeitendes Gewerbe an Industrie__ (Anteil der Erwerbstätigen im Verarbeitenden Gewerbe an den Erwerbstätigen im Sekundären Sektor in %)
		- __Anteil Erwerbstätige Finanz- und Unternehmensdienstleistungen__ (Anteil der Erwerbstätigen in Finanz-, Versicherungs- und Unternehmensdienstleistungen sowie im Grundstücks- und Wohnungswesen an den Erwerbstätigen im Tertiären Sektor in %)
		- __Beschäftigte im Baugewerbe__ (Anteil der SV Beschäftigten am Arbeitsort im Baugewerbe an den SV Beschäftigten in %)
		
- ##### Bevölkerung
	- __*Bevölkerungsstruktur
		- __Ausländeranteil__ (Anteil der Ausländer an den Einwohnern in %)
		- __Haushaltsgröße__ (Personen je Haushalt)
		- __Einpersonenhaushalt__ (Anteil der Einpersonenhaushalte an den Haushalten insgesamt in %)
		- __Haushalte mit Kindern__ (Anteil der Haushalte mit Kindern an allen Haushalten in %)
	- Wanderungen (?)
	- Natürliche Bevölkerungsbewegungen (Geburtenrate/Sterberate?)

- ##### Flächennutzung und Umwelt 
	- __*Flächennutzung
		- __Siedlungs- und Verkehrsfläche__ (Anteil der Siedlungs- und Verkehrsfläche an der Fläche in %)
		- __Siedlungsdichte in km²__ (Einwohner je km² Siedlungs- und Verkehrsfläche)
		- __Erholungsfläche__ (Anteil Erholungsfläche an der Fläche in %)
		- __Erholungsfläche je Einwohner__ (Erholungsfläche je Einwohner in m²)
		- __Freifläche__ (Anteil Freifläche an der Fläche in %)
		- __Freifläche je Einwohner__ (Freifläche je Einwohner in m²)
		- __Landwirtschaftsfläche__ (Anteil Landwirtschaftsfläche an der Fläche in %)
		- __Naturnähere Fläche__ (Anteil naturnähere Fläche an der Fläche in %)
		- __Naturnähere Fläche je Einwohner__ (Naturnähere Fläche je Einwohner in m²)
		- __Waldfläche__ (Anteil Waldfläche an der Fläche in %)
		- __Wasserfläche__ (Anteil Wasserfläche an der Fläche in %)

- #### Medizinische und soziale Versorgung
	- __*Medizinische Versorgung
		- __Krankenhausbetten__ (Krankenhausbetten je 1.000 Einwohner)
		- __Ärzte__ (Ärzte je 10.000 Einwohner)
		- __Hausärzte__ (Hausärzte je 10.000 Einwohner)
		- __Allgemeinärzte__ (Allgemeinärzte je 10.000 Einwohner)
		- __Internisten__ (Internisten je 10.000 Einwohner)
		- __Kinderärzte__ (Kinderärzte je 10.000 Einwohner)
		
	- __*Soziale Versorgung
		- __Pflegebedürftige__ (Pflegebedürftige je 100 Einwohner)
		- __Ambulante Pflege__ (Anteil der Pflegebedürftigen in ambulanter Pflege an den Pflegebedürftigen insgesamt in %)
		- __Stationäre Pflege__ (Anteil der Pflegebedürftigen in stationärer Dauerpflege an den Pflegebedürftigen insgesamt in %)
		- __Empfänger Pflegegeld__ (Anteil der Empfänger von Pflegegeld an den Pflegebedürftigen insgesamt in %)
		- __Personal in Pflegeheimen__ (Personal in Pflegeheimen je 100 vollstationärer Pflegebedürftiger)
		- __Personal in Pflegediensten__ (Personal in ambulanten Pflegediensten je 100 ambulanter Pflegebedürftiger)
		- __Pflegeheimplätze__ (Verfügbare Plätze in Pflegeheimen je 10.000 Einwohner)
		
- #### Siedlungsstruktur
	- __Ländlichkeit__ (Anteil der Einwohner in Gemeinden mit einer Bevölkerungsdichte von unter 150 E/km²)
	- __Bevölkerung in Mittelzentren__ (Bevölkerungsanteil, der in Mittelzentren und möglichen Mittelzentren lebt)
	- __Bevölkerung in Oberzentren__ (Bevölkerungsanteil, der in Oberzentren und möglichen Oberzentren lebt)
	- __Einwohnerdichte__ (Einwohner je km²)
	- __Einwohner-Arbeitsplatz-Dichte__ (Einwohner und Beschäftigte je km²)

- #### Sozialleistungen 
	- __*Leistungsempfänger
		- __SGB II - Quote__ (Anteil der erwerbsfähigen und nicht erwerbsfähigen Leistungsberechtigten nach SGB II an den unter 65-jährigen Einwohnern in %)
		- __Weibliche SGB II-Empfänger__ (Anteil weibliche erwerbsfähige Leistungsberechtigte nach SGB II an allen SGB II Empfängern in %)
		- __Wohngeldhaushalte__ (Anteil der Haushalte, die Wohngeld empfangen je 1.000 Haushalte)
		- __Empfänger von Grundsicherung im Alter (Altersarmut)__ (Anteil der Bevölkerung mit Grundsicherung im Alter an den Einwohnern 65 Jahre und älter in %)
		- __Empfänger von Mindestsicherungen__ (Anteil der Bevölkerung mit sozialen Mindestsicherungsleistungen in %)
- 
- #### Verkehr und Erreichbarkeit (?)
	

- #### SDG-Indikatoren für Kommunen
	- __SGB II-/SGB XII-Quote__ (Anteil Leistungsbeziehende nach SGB II und nach SGB XII je 1.000 Einwohner)
	- __Kinderarmut__ (Nicht erwerbsfähige Leistungsberechtigte unter 15 Jahren je 100 Einwohner unter 15 Jahren)
	- __Empfänger von Grundsicherung im Alter (Altersarmut)__ (Anteil der Bevölkerung mit Grundsicherung im Alter an den Einwohnern 65 Jahre und älter in %)#
	- __Stickstoffüberschuss__ (Überschuss der Sickstoff-Flächenbilanz der landwirtschaftlich genutzten Fläche in kg N /ha LN)
	- __Vorzeitige Sterblichkeit Frauen__ (Todesfälle von Frauen im Alter von unter 70 Jahren je 1.000 Frauen im Alter von unter 70 Jahren)
	- __Vorzeitige Sterblichkeit Männer__ (Todesfälle von Männern im Alter von unter 70 Jahren je 1.000 Männern im Alter von unter 70 Jahren)
	- __Wohnungsnahe Grundversorgung Hausarzt__ (Einwohnergewichtete Luftliniendistanz zum nächsten Hausarzt)
	- __Krankenhausversorgung__ (Krankenhausbetten je 1000 Einwohner)
	- __Wohnungsnahe Grundversorgung Apotheke__ (Einwohnergewichtete Luftliniendistanz zur nächsten Apotheke)
	- __Personal in Pflegeheimen__ (Personal in Pflegeheimen je 10.000 stationär Pflegebedürftige )
	- __Personal in Pflegediensten__ (Personal in ambulanten Pflegediensten je 10.000 Einwohner)
	- __Pflegeheimplätze__ (Verfügbare Plätze in Pflegeheimen je 10.000 Einwohner)
	- __Wohnungsnahe Grundversorgung Grundschule__ (Einwohnergewichtete Luftliniendistanz zur nächsten Grundschule)
	- __Schulabgänger ohne Abschluss__ (Anteil der Schulabgänger ohne Hauptschulabschluss an den Schulabgängern in %)
	- __Betreuungsquote Kleinkinder__ (Anteil der Kinder unter 3 Jahren in Kindertageseinrichtungen an den Kinder der entsprechenden Altersgruppe)
	- __Integrative Kindertageseinrichtungen__ (Anteil der integrativen Kindertageseinrichtungen an allen Kindertageseinrichtungen)
	- __Verhältnis der Beschäftigungsquote von Frauen zu Männern__ (SV Beschäftigtenquote der Frauen am Wohnort je SV Beschäftigtenquote der Männer am Wohnort in %)
	- __Frauenanteil in Stadträten und Kreistagen__ (Anzahl Frauen mit Mandaten in Stadträten und Kreistagen an allen Mandaten in %)
	- __Bruttoinlandsprodukt je Einwohner__ (Bruttoinlandsprodukt in € je Einwohner)
	- __Langzeitarbeitslose__ (Anteil der Arbeitslosen, 1 Jahr und länger arbeitslos, an den Arbeitslosen in %)
	- __Beschäftigungsquote__ (SV Beschäftigte am Wohnort je 100 Einwohner im erwerbsfähigen Alter in %)
	- __Quote ältere Beschäftigte__ (SV Beschäftigte am Wohnort im Alter von über 55 Jahren je 100 Einwohner dieser Altersgruppe in %)
	- __Aufstocker__ (Anteil erwerbstätiger ALGII-Bezieher (Aufstocker) an den abhängig Beschäftigten)
	- __Angebotsmietpreise__ (Wiedervermietungsmieten inserierter Wohnungen (Angebotsmieten))
	- __Beschäftigte am AO mit akademischem Berufsabschluss__ (SV Beschäftigte am Arbeitsort mit akademischem Berufsabschluss an den SV Beschäftigten in %)
	- __Bandbreitenverfügbarkeit mindestens 100 Mbit/s__ (Anteil der Haushalte mit einer Bandbreitenverfügbarkeit (leitungsgebunden) mit mindestens 100 Mbit/s in %)
	- __Beschäftigtenquote Ausländer__ (Verhältnis der Beschäftigungsquote ausländischer Staatsbürger zur Beschäftigungsquote insgesamt)
	- __Einbürgerungen je Ausländer__ (Anzahl der eingebürgerten Personen an den Einwohnern ausländischer Staatsbürgerschaft)
	- __Wohnfläche__ (Verfügbare Wohnfläche je Einwohner)
	- __Wohnungsnahe Grundversorgung Supermarkt__ (Einwohnergewichtete Luftliniendistanz zum nächsten Supermarkt/Discounter)
	- __Pkw-Dichte__ (Anzahl der Pkw je 1.000 Einwohner)
	- __Verunglückte im Straßenverkehr__ (Verunglückte im Straßenverkehr je 100.000 Einwohner)
	- __Siedlungs- und Verkehrsfläche__ (Anteil der Siedlungs- und Verkehrsfläche an der Gesamtfläche in %)
	- __Flächenneuinanspruchnahme__ (Änderung der Siedlungs- und Verkehrsfläche an der Gesamtfläche im Vergleich zum Vorjahr)
	- __Siedlungs- und Verkehrsfläche je Einwohner__ (Siedlungs- und Verkehrsfläche je Einwohner)
	- __Erholungsfläche je Einwohner__ (Erholungsfläche in m² je Einwohner)
	- __Fertiggestellte Wohngebäude mit erneuerbarer Heizenergie__ (Anteil fertiggestelle Wohngebäude mit erneuerbarer Heizenergie an allen Wohngebäuden in %)
	- __Trinkwasserverbrauch__ (Wasserabgabe an Letztverbraucher (Haushalte und Kleingewerbe) in l je Einwohner und Tag)
	- __Abfallmenge__ (Entsorgte Abfallmenge in kg je Einwohner)
	- __Steuereinnahmen__ (Steuereinnahmen der Gemeinden und Gemeindeverbände in Euro je Einwohner)
	- __Kassenkredite__ (Kassenkredite im Kernhaushalt je Einwohner)




# [[Verwaltungsgebiete]]
- Daten: https://gdz.bkg.bund.de/index.php/default/verwaltungsgebiete-1-250-000-stand-31-12-vg250-31-12.html
## Postleitzahlen
Postleitzahl mit Kreis code (ARS)
https://public.opendatasoft.com/explore/dataset/georef-germany-postleitzahl/export/?sort=krs_code

Sentinel-5P OFFL O3 