library(shiny)
library(semantic.dashboard)
library(ggplot2)
library(plotly)
library(DT)

world_coordinates = map_data("world")
data = read.csv("dane_projekt2.csv")
data$month_2 = as.integer(data$month_2)


ui = dashboardPage(
  dashboardHeader(color = "violet", title = "Dayseek", titleWidth = "wide", inverted = TRUE),
  dashboardSidebar(
    size = "thin", color = "teal",
    sidebarMenu(
      menuItem(tabName = "main", "SEARCH BY DATE", icon = icon("calendar")),
      menuItem(tabName = "extra", "SEE RAW DATA", icon = icon("table")),
      menuItem(tabName = "aboutus", "ABOUT US", icon = icon("info"))
    )
  ),
  dashboardBody(
    tabItems(
      selected = 1,
      tabItem(
        tabName = "main",
        fluidRow(
          box(
            width = 15,
            height = 10,
            title = "Date Selection",
            color = "yellow",  
            ribbon = TRUE,
            collapsible = FALSE,
            title_side = "top left",
            column(
              width = 15,
              dateInput("selected_date", "Select a Date you want to check", startview = "decade")
            )
          ),
          box(
            width = 15,
            title = "Graph 1",
            color = "red",
            ribbon = TRUE,
            title_side = "top right",
            column(
              width = 15,
              plotlyOutput("plot1", width = "90%", height = "90%")
            )
          ),
          box(
            width = 15,
            title = "Graph 2",
            color = "green",
            ribbon = TRUE,
            title_side = "top right",
            column(
              width = 15,
              selectInput(
                inputId = "x",
                label = "Level",
                choices = c("Level 1", "Level 2", "Level 3"),
                selected = "Level 1"
              ),
              plotOutput("plot2")
            )
          )
        )
      ),
      tabItem(
        tabName = "extra",
        fluidRow(
          dataTableOutput("datatable")
        )
      )
    )
  ),
  theme = "cerulean"
)

server = shinyServer(function(input, output, session) {
  
  observeEvent(input$selected_date, {
    selected_date = as.Date(input$selected_date, format = "%Y-%m-%d")
    selected_day = as.numeric(format(selected_date, format = "%d"))
    selected_month = as.integer(format(selected_date, format = "%m"))
    filtered_data = subset(data, month_2 == selected_month & day == selected_day)
    
    mapa = plot_ly() %>%
      add_trace(
        data = filtered_data,
        type = "scattergeo",
        lon = filtered_data$bplo1,
        lat = filtered_data$bpla1,
        text = filtered_data$name,  
        mode = "markers",
        marker = list(size = 7, color = "red")  
      ) %>%
      layout(
        geo = list(
          scope = "world",  
          showland = TRUE,
          landcolor = "lightgray", 
          showcountries = TRUE,  
          countrycolor = "black"  
        )
      ) %>% 
      config(scrollZoom = FALSE)
    
    
    output$plot1 = renderPlotly({mapa})
  observeEvent(input$x,{
      inputx = input$x
    if (inputx == "Level 1") {
      inputx = "level1_main_occ"
    }
    if (inputx == "Level 2") {
      inputx = "level2_main_occ"
    }
    if (inputx == "Level 3") {
      inputx = "level3_main_occ"
    }
  
    output$plot2 = renderPlot({
    ggplot(filtered_data, aes(x = .data[[inputx]])) +
      geom_bar() +
      labs(x = "Categories", y = "Number of people")
  })
  })
  output$datatable = renderDataTable(filtered_data)
})
})

shinyApp(ui, server)

# co trzeba zrobic jeszcze + propozycje
# lista nazwisk
# w wykresie słupkowym mozliwosci wyboru co jest na osi
# oś czasu z osobami
# ladniejsza tabela w raw data 
# po kliknieciu na nazwisko danej osoby w jakis sposob zaznaczenie jej na wykresach np. zmiana koloru 
