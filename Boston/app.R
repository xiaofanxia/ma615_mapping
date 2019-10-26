#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

pacman::p_load("ggmap","maptools","maps","mapproj","shiny")
worldmap <- map_data("world")
projections <- c("cylindrical","mercator","sinusoidal","gnomonic","rectangular","cylequalarea")

ui <- fluidPage(
    titlePanel("World Map"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput("p","Select a Projection",choices = projections),
            sliderInput("rng1", "Range for longitude", value = c(-180,180),min=-200,max=200),
            sliderInput("rng2", "Range for latitude", value = c(-60,90),min=-100,max=100)
        ),
        mainPanel(
            plotOutput("mymap")
        )
    )
)