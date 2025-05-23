

library(sf)
library(readr)
library(dplyr)

setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Kreisebene")

krs_uebersicht <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/KRS_Uebersicht.csv")

# 1. CSV einlesen mit readr::read_csv und Spaltentypen explizit angeben
data <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Gemeinsamer_Bundesausschluss/processed/I71_rupt_J_2023_KRS.csv",
                 col_types = cols(
                   ARS = col_character(),
                   AGS = col_character(),
                   SDV_ARS = col_character()
                 ))

data$geometry <- NULL


data_unique <- data %>%
  group_by(ARS) %>%
  slice(1) %>%  # erste Zeile pro ARS behalten
  ungroup()

View(data_unique)

shapefile_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
gdf_shp <- st_read(shapefile_path) %>%
  mutate(AGS = as.character(AGS), ARS = as.character(ARS), SDV_ARS = as.character(SDV_ARS))


library(dplyr)

# Nur ARS plus Spalten, die mit Min_ oder Max_ anfangen auswählen
QB_I71_rupt <- data_unique %>%
  dplyr::select(ARS, starts_with("Min_"), starts_with("Max_")) %>%
  distinct() %>%
  rename_with(~ paste0(., "_J_2023"), .cols = c(starts_with("Min_"), starts_with("Max_")))



# Liste der CSV-Dateien mit vollem Pfad
BBSR_INKAR <- read_csv("BBSR_INKAR.csv",
                       col_types = cols(
                         ARS = col_character(),
                         AGS = col_character(),
                         # SDV_ARS = col_character()
                       ))

BBSR_INKAR <- BBSR_INKAR %>%
  dplyr::select(-matches("(_x|_y)$"))

View(BBSR_INKAR)


# Liste der CSV-Dateien mit vollem Pfad
Copernicus_CLC_J_2018 <- read_csv("Copernicus_CLC_J_2018.csv",
                                  col_types = cols(
                                    ARS = col_character(),
                                    AGS = col_character(),
                                    #   # SDV_ARS = col_character()
                                  )
)

View(Copernicus_CLC_J_2018)


DWD_Lufttemperatur_max_J_2023 <- read_csv("DWD_Lufttemperatur_max_J_2023.csv",
                                          col_types = cols(
                                            ARS = col_character(),
                                            AGS = col_character(),
                                            SDV_ARS = col_character()
                                          )
)

View(DWD_Lufttemperatur_max_J_2023)



DWD_Lufttemperatur_mean_J_2023 <- read_csv("DWD_Lufttemperatur_mean_J_2023.csv",
                                           col_types = cols(
                                             ARS = col_character(),
                                             AGS = col_character(),
                                             SDV_ARS = col_character()
                                           )
)

View(DWD_Lufttemperatur_mean_J_2023)

DWD_Lufttemperatur_min_J_2023 <- read_csv("DWD_Lufttemperatur_min_J_2023.csv",
                                          col_types = cols(
                                            ARS = col_character(),
                                            AGS = col_character(),
                                            SDV_ARS = col_character()
                                          )
)

View(DWD_Lufttemperatur_min_J_2023)



DWD_Dürreindex_J_2023 <- read_csv("DWD_Dürreindex_J_2023.csv",
                                  col_types = cols(
                                    ARS = col_character(),
                                    AGS = col_character(),
                                    SDV_ARS = col_character()
                                  )
)

View(DWD_Dürreindex_J_2023)



DWD_Hitzetage_J_2023 <- read_csv("DWD_Hitzetage_J_2023.csv",
                                 col_types = cols(
                                   ARS = col_character(),
                                   AGS = col_character(),
                                   SDV_ARS = col_character()
                                 )
)

View(DWD_Hitzetage_J_2023)





DWD_Sonnenscheindauer_J_2023 <- read_csv("DWD_Sonnenscheindauer_J_2023.csv",
                                         col_types = cols(
                                           ARS = col_character(),
                                           AGS = col_character(),
                                           SDV_ARS = col_character()
                                         )
)

View(DWD_Sonnenscheindauer_J_2023)


DLR_Road_Traffic_Noise_J_2017 <- read_csv("DLR_Road_Traffic_Noise_J_2017.csv",
                                          col_types = cols(
                                            ARS = col_character(),
                                            AGS = col_character(),
                                            # SDV_ARS = col_character()
                                          )
)

View(DLR_Road_Traffic_Noise_J_2017)

DWD_Tropische_Naechte_J_2023 <- read_csv("DWD_Tropische_Naechte_J_2023.csv",
                                         col_types = cols(
                                           ARS = col_character(),
                                           AGS = col_character(),
                                           SDV_ARS = col_character()
                                         )
)

View(DWD_Tropische_Naechte_J_2023)
View(QB_I71_rupt)


# Liste aller DataFrames
df_list <- list(
  BBSR_INKAR,
  Copernicus_CLC_J_2018,
  DWD_Lufttemperatur_max_J_2023,
  DWD_Lufttemperatur_mean_J_2023,
  DWD_Lufttemperatur_min_J_2023,
  DWD_Dürreindex_J_2023,
  DWD_Hitzetage_J_2023,
  DWD_Niederschlag_J_2023,
  DWD_Sonnenscheindauer_J_2023,
  DWD_Tropische_Naechte_J_2023, 
  QB_I71_rupt, 
  DLR_Road_Traffic_Noise_J_2017
)


joined_df <- reduce(df_list, full_join, by = "ARS")


joined_df <- joined_df %>%
  dplyr::select(-matches("(.x|.y)$"))



joined_df <- joined_df %>%
  dplyr::select(ARS, AGS, GF, BEZ,GEN, everything())

View(joined_df)

write.csv(joined_df, "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Kreisebene/QB_u_Umweltdaten_ARS.csv", row.names = FALSE)

