#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

pacman::p_load("shiny","tidyverse","leaflet","leaflet.extras")

#Read in data
violation <- read.csv("public_work_violation.csv")

#Data Cleaning
violation_new <- 
  violation %>% 
  select(ticket_no,status_dttm,description,street,suffix,city,latitude,longitude)%>%
  separate(status_dttm,into=c("Date","Time")," ")
colnames(violation_new) <- c("Ticket Number","Date","Time","Description","Street","Suffix","City","Latitude","Longitude")
map <- violation_new
map$lat <- as.numeric(map$Latitude)
map$long<- as.numeric(map$Longitude)
na.omit(map)


#Define Violations
Description <- unique(map$Description)

#Define Location
Street <- unique(map$Street)
City <- unique(map$City)

#Layout
ui <- fluidPage(
  titlePanel("MA Public Work Violation Map"),
  sidebarLayout(
    sidebarPanel(
      selectInput("x", "Violation", Description),
      selectInput("s", "Street", Street),
      selectInput("c","City",City),
      actionButton("resetBeatSelection", "Reset Map Selection")
    ),
    mainPanel(
      leafletOutput(outputId = "mymap")
    )
  )
)

#Server
server <- function(input, output) {
  # pull out the data
  selected <- reactive(
    map %>% filter(Description==input$x & Street==input$s & City==input$c)
  )
  # output the map 
  output$mymap <- renderLeaflet(
    selected() %>% leaflet() %>% addTiles() %>%
      addMarkers(~long, ~lat, label = ~as.character(Description))
  )
  
}
shinyApp(ui, server)