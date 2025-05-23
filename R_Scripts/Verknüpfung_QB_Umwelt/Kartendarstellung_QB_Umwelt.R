# install.packages("stringdist")
library(sf)
library(readr)
library(dplyr)
library(shiny)
library(leaflet)
library(viridis)
library(stringdist)
library(stringr)

setwd("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Kreisebene")

df <- read_csv("QB_u_Umweltdaten_ARS.csv",
                                         col_types = cols(
                                           ARS = col_character(),
                                           AGS = col_character()))

head(df)


shapefile_path <- "C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Verwaltungsgebiete/vg250_12-31.gk3.shape.ebenen/vg250_ebenen_1231/VG250_KRS.shp"
gdf_shp <- st_read(shapefile_path) %>%
  mutate(AGS = as.character(AGS), ARS = as.character(ARS), SDV_ARS = as.character(SDV_ARS))
gdf_shp


# Join df (Umweltdaten) in gdf_shp (Geometrie)
gdf_joined <- gdf_shp %>%
  left_join(df, by = "ARS")

gdf_joined <- gdf_joined %>%
  dplyr::select(-matches("(.x)$"))

gdf_joined <- gdf_joined %>%
  rename_with(~str_replace(., "\\.y$", ""))

View(gdf_joined)

Legende <- read_csv("C:/Users/agnes/Documents/EAGLE/Innovation_Lab/Daten/Kreisebene/Spaltenbeschreibung.csv")


##############################################################################
########################## KARTEN ERSTELLUNG #################################
##############################################################################


clean_varname <- function(varname) {
  # Entferne alles ab "_" (inkl. Unterstrich)
  base <- sub("_.*", "", varname)
  # Entferne führende und abschließende Leerzeichen
  base <- trimws(base)
  return(base)
}

get_beschreibung <- function(varname, legend) {
  base_var <- clean_varname(varname)
  
  # Versuche exakten Match
  exact_match <- legend$Beschreibung[legend$Variabel == base_var]
  if(length(exact_match) > 0) return(exact_match)
  
  # Fuzzy Matching (niedrigste Distanz)
  dists <- stringdist::stringdist(base_var, legend$Variabel, method = "jw") # Jaro-Winkler
  best_match_index <- which.min(dists)
  
  if(dists[best_match_index] < 0.3) {  # Schwellenwert für "gut genug"
    return(legend$Beschreibung[best_match_index])
  } else {
    return("Keine Beschreibung verfügbar.")
  }
}


# 1. Daten vorbereiten (hier Beispielname verwenden)
Landkreis_leaflet_ready <- st_transform(gdf_joined, 4326)

# 2. Alle Spalten außer Geometrie zur Auswahl anbieten
auswahl_spalten <- names(Landkreis_leaflet_ready)[
  names(Landkreis_leaflet_ready) != "geometry"
]
auswahl_spalten


# Auswahlbare Spalten (z. B. alle nach "GEN")
start_index <- which(names(Landkreis_leaflet_ready) == "GEN") + 1
auswahl_spalten <- names(Landkreis_leaflet_ready)[start_index:length(names(Landkreis_leaflet_ready))]
auswahl_spalten <- auswahl_spalten[sapply(Landkreis_leaflet_ready[auswahl_spalten], is.numeric)]

# Liste der Farbpaletten
paletten <- c(
  "Viridis (Standard)" = "viridis",
  "Inferno (dunkel → gelb)" = "inferno",
  "Plasma (lila → gelb)" = "plasma",
  "Magma (dunkelrot → hell)" = "magma",
  "Cividis (monochromatisch)" = "cividis",
  "Spectral (kontrastreich)" = "Spectral",
  "YlOrRd (Ampelstil)" = "YlOrRd",
  "RdYlBu (rot-gelb-blau)" = "RdYlBu"
)

# UI
ui <- fluidPage(
  titlePanel("Ergebnisse auf Landkreisebene"),
  sidebarLayout(
    sidebarPanel(
      selectInput("variable", "Wähle eine Variable:", choices = auswahl_spalten),
      selectInput("palette", "Wähle eine Farbpalette:", choices = paletten),
      hr(),
      h5(strong("Beschreibung zur Variable:")),
      textOutput("beschreibung")  # Hier kommt die Beschreibung hin
    ),
    mainPanel(
      leafletOutput("karte", height = 800)
    )
  )
)

server <- function(input, output, session) {
  output$beschreibung <- renderText({
    req(input$variable)
    get_beschreibung(input$variable, Legende)
  })
  
  output$karte <- renderLeaflet({
    var <- input$variable
    pal_name <- input$palette
    
    # Farbpalette erzeugen
    if (pal_name %in% c("viridis", "inferno", "plasma", "magma", "cividis")) {
      pal <- colorNumeric(palette = get(pal_name)(256), domain = Landkreis_leaflet_ready[[var]], na.color = "transparent")
    } else {
      pal <- colorNumeric(palette = pal_name, domain = Landkreis_leaflet_ready[[var]], na.color = "transparent")
    }
    
    # Popup-Text vorbereiten
    Landkreis_leaflet_ready$popup_text <- paste0(
      "<strong>GEN: </strong>", Landkreis_leaflet_ready$GEN, "<br>",
      "<strong>Min_Anzahl_Aneurysma_rupturiert_J_2023: </strong>", Landkreis_leaflet_ready$Min_Anzahl_Aneurysma_rupturiert_J_2023, "<br>",
      "<strong>Max_Anzahl_Aneurysma_rupturiert_J_2023: </strong>", Landkreis_leaflet_ready$Max_Anzahl_Aneurysma_rupturiert_J_2023, "<br>",
      "<strong>Min_Anzahl_Dissektion_rupturiert_J_2023: </strong>", Landkreis_leaflet_ready$Min_Anzahl_Dissektion_rupturiert_J_2023, "<br>",
      "<strong>Max_Anzahl_Dissektion_rupturiert_J_2023: </strong>", Landkreis_leaflet_ready$Max_Anzahl_Dissektion_rupturiert_J_2023, "<br>",
      "<strong>", var, ": </strong>", Landkreis_leaflet_ready[[var]]
    )
    
    
    leaflet(Landkreis_leaflet_ready) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~pal(Landkreis_leaflet_ready[[var]]),
        fillOpacity = 0.8,
        color = "#333333", weight = 1,
        popup = ~popup_text
      ) %>%
      addLegend("topright", pal = pal, values = Landkreis_leaflet_ready[[var]],
                title = var, opacity = 0.8)
  })
}

shinyApp(ui, server)

