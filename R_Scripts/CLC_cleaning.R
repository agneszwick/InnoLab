library(readr)
library(dplyr)
library(tidyr)

# 1. CSV-Dateien laden
df <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/COPERNICUS_CORINE_V20_100m/CLC_Anteile_AlleKreise_2018.csv")
klassen <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/COPERNICUS_CORINE_V20_100m/CLC_Klassen_Namen.csv")
krs_uebersicht <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/KRS_Uebersicht.csv")

# 2. Daten vorbereiten und aggregieren
df_selected <- df %>%
  select(AGS, CLC_Code, Anteil_prozent) %>%
  group_by(AGS, CLC_Code) %>%
  summarise(Anteil_prozent = sum(Anteil_prozent, na.rm = TRUE), .groups = "drop")

# 3. In breites Format umwandeln
df_wide <- df_selected %>%
  pivot_wider(
    names_from = CLC_Code,
    values_from = Anteil_prozent,
    values_fill = list(Anteil_prozent = 0)
  )

# 4. Spaltennamen für Mapping vorbereiten
colnames(df_wide) <- as.character(colnames(df_wide))  # alle Spaltennamen als character
klassen <- klassen %>%
  mutate(CLC_Code = as.character(CLC_Code))  # CLC_Code ebenfalls als character

# 5. Mapping erstellen
ags_column <- "AGS"
clc_columns <- setdiff(colnames(df_wide), ags_column)

clc_mapping <- klassen %>%
  filter(CLC_Code %in% clc_columns) %>%
  mutate(new_name = paste0(CLC_Code, "_", CLC_Klassenname_Deutsch))

# Optional: Spaltennamen bereinigen (Umlaute, Leerzeichen)
clc_mapping <- clc_mapping %>%
  mutate(new_name = new_name %>%
           gsub("ä", "ae", .) %>%
           gsub("ö", "oe", .) %>%
           gsub("ü", "ue", .) %>%
           gsub("ß", "ss", .) %>%
           gsub(" ", "_", .))

# 6. Named vector für Umbenennung
name_vector <- setNames(clc_mapping$new_name, clc_mapping$CLC_Code)

# Vor dem Rename: alle Spaltennamen zu character
colnames(df_wide) <- as.character(colnames(df_wide))

# 7. Umbenennung der Spalten
df_wide_renamed <- df_wide %>%
  rename_with(~ name_vector[.x], .cols = all_of(names(name_vector)))

# 8. CSV mit KRS_Übersicht verbinden
df_final <- df_wide_renamed %>%
  left_join(krs_uebersicht, by = "AGS")

# 9. Spalten neu anordnen, sodass ARS, GF, GEN, BEZ direkt nach AGS kommen
df_final <- df_final %>%
  select(AGS, ARS, GF, GEN, BEZ, everything())

# 10. Spalten mit "_J_2018" suffix umbenennen
df_final <- df_final %>%
  rename_with(~ ifelse(. %in% c("AGS", "ARS", "GF", "GEN", "BEZ"), ., paste0(.,"_J_2018")), .cols = !c("AGS", "ARS", "GF", "GEN", "BEZ"))



head(df_final)

# 10. Optional: Ergebnis speichern
write_csv(df_final, "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/COPERNICUS_CORINE_V20_100m/processed/CLC_Anteile_pro_KRS_2018.csv")


