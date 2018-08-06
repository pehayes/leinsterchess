#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load required libraries
  library(shiny)
  library(dplyr)
  library(ggplot2)
  library(ggthemes)

# Load required data file containing data at player level for the past 14 years of 
# Leinster winter chess league data for all 7 divisions.

# The data file must first be downloaded to your working directory from this github location:
# https://github.com/pehayes/leinsterchess/blob/master/llout.Rda
  load(file = "llout.Rda")
    
# Define UI for application that generates a histogram of performance across the last 14 seasons
ui <- fluidPage(
   
   # Application title
   titlePanel("Leinster Chess Leagues : 2003 - 2017 (All Leagues). Distribution of Score Per Player"),
   
   # Sidebar with two dropdown lists to allow single selection of Year and Division 
   sidebarLayout(
      sidebarPanel(
        selectInput("year", "Select Year", 
                    choices = unique(as.character(llout$Year))
                    ),
        selectInput("division", "Select Division", 
                    choices = unique(as.character(llout$Division))
                    )
      ),
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distribution")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   output$distribution <- renderPlot({
      
     # Filter the population using input$year and input$division from ui.R
        x <- dplyr::filter(llout, as.character(llout$Year) == input$year & llout$Division == input$division) 
     
     # Generate a ggplot histogram of the output 
        x %>% ggplot(.,aes(x = Score, fill = cut(Score, 100))) + 
          theme_economist() +
          geom_histogram(bins = 25, show.legend = FALSE) +
          ggtitle("Histogram of Player Scores Across All Seasons")
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

