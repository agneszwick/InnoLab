#!/bin/bash

# Zielordner (anpassen, falls du willst)
TARGET_DIR="/mnt/c/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/DLR_S_VELD_NO2_PM2_5"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Jahre und Monate
for year in 2018 2019; do
  for month in {01..12}; do
    file="MODIS_SLSTR_PM25SURF_MONTH_${year}${month}.zip"
    url="https://download.geoservice.dlr.de/SVELD/files/monthly/${year}/${month}/${file}"

    echo "📦 Lade: $file ..."
    
    # Prüfen ob Datei existiert, bevor runtergeladen wird
    if wget --spider "$url" 2>/dev/null; then
      wget -nc "$url"
    else
      echo "⚠️  Datei nicht gefunden: $url"
    fi
  done
done
