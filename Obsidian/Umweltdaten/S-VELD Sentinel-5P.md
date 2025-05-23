## 1. Tropospheric NO2 column densities
- Satellit: Sentinel-5P TROPOMI 
- Monatliche Ergebnisse von Januar 2018 bis Dezember 2020
- baseProduct: Level 3 SVELD
- Räumliche Auflösung: 2000 m 
- no2_tropospheric_column: in mol/m2 (average tropospheric NO2 column)
#### Tropospheric NO₂ Retrieval Algorithm  
- **Methodology:**
	- The **DOAS (Differential Optical Absorption Spectroscopy)** method is used to retrieve NO₂ slant column densities from TROPOMI radiance data (405–465 nm).
	- Includes absorption features of NO₂ and interfering species: **ozone, O₂-O₂, water vapor, and liquid water**.
	- Uses a **220 K NO₂ reference spectrum** (Vandaele et al., 2002) and a **Fraunhofer Ring spectrum** for correction.
	
- **Spectral Corrections:**
    - A **linear intensity offset** is fitted to correct for stray light, ocean scattering, and calibration issues.
    - **Shift and stretch adjustments** improve wavelength alignment.
    
- **Initial Vertical Column Calculation:**
    - Assumes an **unpolluted troposphere**, using only **stratospheric NO₂ profiles** for the air mass factor (AMF).
    - This underestimates NO₂ in polluted regions and requires correction.
    - AMFs are calculated using the **VLIDORT radiative transfer model** at 437.5 nm.
        
- **Stratosphere-Troposphere Separation:**
    - The **STREAM (STRatospheric Estimation Algorithm from Mainz)** method estimates the stratospheric NO₂ contribution.
    - Relies on data from **clean, remote, and cloudy scenes**.
    - Uses **weighting factors** and does **not require chemical transport models**.
        
- **Tropospheric NO₂ Column Calculation:**
    - Tropospheric AMFs are computed using:
        - **Surface albedo climatology** from OMI (440 nm, 3-year average).
        - **TM5-MP model** NO₂ vertical profiles (1°×1° resolution).
        - **Cloud properties** from TROPOMI's **OCRA and ROCINN algorithms**.
            
- **Limitations with Cloudy Conditions:**
    - If clouds are **optically thick** and **above the pollution layer**, NO₂ may not be detected.
    - Therefore, measurements with **cloud fraction > 20% are flagged** in the TROPOMI L2 product.
## 2. Surface NO2 concentrations
- Satellit: Sentinel-5P TROPOMI 
- Monatliche Ergebnisse von Januar 2018 bis Dezember 2020
- baseProduct: Level 3 SVELD
- Räumliche Auflösung: 500 m 
- no2_concentration: unit: μg/m3 

#### Surface NO₂ Estimation:
- **Input Data**
	- **Satellite Data:**  
	    TROPOMI tropospheric NO₂ columns, filtered for clouds (CRF < 50%) and quality; regridded to 0.5×0.5 km.
	- **Ground Station Data:**  
	    Ambient NO₂ from 268 in-situ monitoring stations in Germany (excluding roadside and industrial sites) to avoid local pollution bias.
	- **Meteorological Data:**  
	    Weather variables (e.g., boundary layer height, temperature, humidity, wind) from ECMWF ERA5 reanalysis, resolution ~0.25°.
	- **Surface Elevation:**  
	    Data from EU-DEM used to account for terrain differences in NO₂ estimation.
	    
- A **neural network model** (4 hidden layers) is trained to predict surface NO₂ based on satellite, meteorological, and elevation data.
- Inputs and outputs are regridded to daily 0.5×0.5 km resolution.
- **Training data:** 76,338 data pairs (90% training, 10% validation).
- The model is optimized using **stochastic gradient descent** and **mean squared error**.