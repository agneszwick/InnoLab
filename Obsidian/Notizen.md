# Daten

## Noise2NAKOAI - Roud Traffic Noise, Germany 2017
https://geoservice.dlr.de/web/datasets/n2nnoise
- Input Data: EIONET Strategic Noise Maps (DF 4 and DF 8) Aggroad_Lden and Mroad_Lden. Data reported under the 2002/49/EC obligations to EEA.
- Format: Cloud-Optimized GeoTIFF (COG)
- Spatial Resolution: 10 x 10m
- Period: 2017
- Coverage: Germany
- License: [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/)
- The indicator, Lden (Day-Evening-Night Level), describes the equivalent sound pressure level of a 24-hour period, with separate values for daytime, evening, and nighttime periods and is commonly used in environmental noise assessments to evaluate the impact of noise sources on human health and well-being. 
- The input data, simulated noise levels provided as shapefiles by the federal states of Germany, were cleansed and harmonized prior rasterizing them to 10 x 10m.
- - Spatial Resolution: 10 x 10m
- **Map Projection:** Name: [ETRS89 / LAEA Europe (EPSG:3035)](https://epsg.io/3035)
![[Pasted image 20250509135119.png]]
 - Raster auf jeden Landkreis zugeschnitten
 - anschließend pixel count berechnet
 - pixel count in fläche umgerechnet (ein Pixel ist 10x10 m )
 - Flächenanteil jeder Dezibel Klasse pro Landkreis
 - 
## DWD 
https://opendata.dwd.de/climate_environment/CDC/grids_germany/
- __*Monatliche und Saisonal (2022-2024)
	- Niederschlag (Jahreszeitensumme der Niederschlagshöhe in mm.)
	- Min/Mean/Max Temperatur (Parameter Jahreszeitenmittel der monatlich gemittelten täglichen Lufttemperaturmaxima in 2 m Höhe, in 1/10 °C.)
	- UHI
		- tropical_nights_diff (Anzahl der Tropennächte, die zusätzlich aufgrund von Bebauungsstrukturen aufkommt)
		- uhi_daymax_max (maximale UHI-Intensität)
		- uhi_daymax_mean (mittlere UHI-Intensität basierend auf Tagesmaxima)
	- Dürreindex (Trockenheitsindex nach de Martonne (dMI) wird durch folgende Formel berechnet: dMI = P/(T+10). Eingangsdaten sind die Raster für T=Temperatur in Grad Celsius und P=Niederschlag in mm)
	- Hot_days (Hitzetage): Anzahl der Heißen Tage; Definition Heißer Tag: Maximum der Lufttemperatur >= 30°C
	- Sunshine_duration(Sonnenscheindauer): Jahressumme der Sonnenscheindauer in h
- Anmerkung: Nummerierung bei Saisonal: 
	- MAM(yyyy_13)
	- JJA(yyyy_14)
	- SON(yyyy_15)
	- DJF(yyyy_16)
### Sortierung DWD-Daten

## MODIS 
- NDVI 
## World Settlement Footprint (DLR) 
- in GEE nur von 2015

## Sentinel-5P
- NO2/SO2/O3 (Sentinel-5P)
- Auflösung 1113.2 m
- Werte liegen in **mol/m²** (Mol pro Quadratmeter) → Umrechnung→ **µmol/m² = mol/m² × 1,000,000** 
- Anmerkung bei den combined_files (zb combined_O3_values) wurden die werte auf  **µmol/m²** umgerechnet!!!
- 

- Sentinel-5P OFFL NO2: Offline Nitrogen Dioxide
	- Because of noise in the data, negative vertical column values are often observed in particular over clean regions or for low SO2 emissions. It is recommended not to filter these values except for outliers, i.e. for vertical columns lower than -0.001 mol/m^2.

## Corine Land Cover
- Auflösung 100m 
- Datengrundlage 2018: Sentinel-2 and Landsat-8 for gap filling
- 44 Klassen davon 37 in deutschland vertreten 
- Raster wurde auf KRS zugeschnitten, vektorisiert, und dann flächenanteil in % pro KRS berechnet 


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



## Verwaltungsgebiete:
- Daten: https://gdz.bkg.bund.de/index.php/default/verwaltungsgebiete-1-250-000-stand-31-12-vg250-31-12.html
- Landkreisebene: Kreis VG250_KRS.SHP
- GF: Geofaktor
	- Werteübersicht:
		- 1 = ohne Struktur Gewässer
		- 2 = mit Struktur Gewässer
		- 3 = ohne Struktur Land
		- 4 = mit Struktur Land
	
	- Die Gebiete, in denen unterhalb der Landesebene keine weiteren Ebenen vorhanden sind, erhalten die Angabe „ohne Struktur“. Die Angabe Gewässer bezieht sich auf die Nord- und Ostsee sowie den Bodensee. Verwaltungseinheiten, deren Gebiet sich auch über die Nord- oder Ostsee bzw. den Bodensee erstreckt, sind an der Küste getrennt. Eine Unterscheidung der beiden Teile der betroffenen Verwaltungseinheiten ist über das Attribut GF (Geofaktor) möglich. Die Teilfläche auf den genannten Gewässern besitzt den GF-Wert 2. Dagegen besitz die Landteilflächen den GF-Wert 4.
	- 


## Postleitzahlen
Postleitzahl mit Kreis code (ARS)
https://public.opendatasoft.com/explore/dataset/georef-germany-postleitzahl/export/?sort=krs_code