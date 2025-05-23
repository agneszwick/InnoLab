### Meine Berechnung:
- Jährlichen Mittelwert und Median aus den monatlichen Daten (.tiff files) 
- Mittelwert und Median pro Landkreis für die Jährlichen Daten (.csv file)


### Allgemeine Infos zu den Daten:
- Die zeitliche Auflösung des Produkts ist monatlich
- Das Datengitter deckt Deutschland und die umliegenden Länder in UTM-Koordinaten mit einer Auflösung von 0,5kmx0,5km ab. 
- mass_concentration_of_pm2p5_ambient_aerosol_particles_in_air (in μg/m-3)

### Datengrundlage:
- **Satellitendaten (MODIS & SLSTR)**:
    - Verwendet zur Schätzung der PM2.5-Konzentrationen am Boden.
    - Umwandlung auf ein regelmäßiges Längen-/Breitengrad-Raster mit 0,01° Auflösung.
    - Mehrfache Tageswerte pro Gitterzelle wurden zu einem Tagesmittelwert gemittelt.
    
- **Daten von Luftqualitätsmessstationen**:
    - PM2.5-Daten stammen von der Europäischen Umweltagentur (EEA).
    - Genutzt wurden stündliche E2a-Messdaten für das Jahr 2018.
    - Region: 46°N–56°N, 2°E–16°E; umfasst 350 Stationen in 9 Ländern, davon 175 in Deutschland.
    - Da nicht alle Stationen zwischen 10:30–13:30 messen (Satellitenüberflug), wurden tägliche Mittelwerte verwendet.
    - Ziel: Verbesserung der Stichprobengrundlage für die spätere lineare Regressionsanalyse.

- **Meteorologische Daten:**
- Bereitgestellt vom European Centre for Medium-Range Weather Forecasts (ECMWF)
- Verwendet wurde das **HRES-Datenset** (hochaufgelöste 10-Tage-Vorhersage) mit 0,1° Auflösung
- Genutzte Parameter: **Grenzschichthöhe (BLH)** und **relative Luftfeuchtigkeit (RH)**.
- Datenzeitpunkt: **12 Uhr mittags** (passend zu Satellitenüberflug).
- Interpolation auf ein **0,01° x 0,01° Gitter**.

### Berechnung der PM2.5-Konzentration am Boden:

- **Halb-empirisches Modell** zur Ableitung von PM2.5 aus AOD (Aerosol Optical Depth)
- Formel berücksichtigt:
    - **AOD** (τ), **Partikeldichte (ρ)**, **effektiver Partikelradius (r_eff)**,
    - **Extinktionskoeffizient bei trockenen Bedingungen (Q_ext,dry)**,
    - **Grenzschichthöhe (H)**,
    - **relative Luftfeuchtigkeit (RH)** → beeinflusst über Hygroskopie die Lichtstreuung.

- Annahme: Aerosole sind hauptsächlich in der **planetaren Grenzschicht** und gut durchmischt.
- Annahme eines **einheitlichen Aerosoltyps** (urban-industriell, schwach/nicht-absorbierend), daher konstante Werte für r_eff und Q_ext,dry.

#### Korrekturverfahren:
- **Lineare Regression** mit in-situ PM2.5-Daten zur Korrektur von Bias und Skalierungsfehlern.
- Regressionsparameter (Steigung A, Achsenabschnitt B) stationen- und monatsweise berechnet.
- Nach Ausreißerentfernung: Interpolation der Regressionsparameter auf ein 0,01°-Raster mittels inverse distance weighting
- Daraus: **Korrekturfelder** zur Neuberechnung der täglichen PM2.5-Werte.

### Ergebnis:

- Erstellung **täglich korrigierter PM2.5-Konzentrationen** mit MODIS- und SLSTR-AOD-Daten.
- **Kombination beider Datensätze** durch Mittelung der Tageswerte pro Gitterzelle.
- Ableitung der **monatlichen Mittelwerte** aus den kombinierten täglichen PM2.5-Werten.