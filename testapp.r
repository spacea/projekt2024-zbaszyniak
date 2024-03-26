library(shiny)
library(semantic.dashboard)
library(ggplot2)
library(plotly)

world_coordinates = map_data("world")
data = read.csv("dane_projekt2.csv")
data$month_2 = as.integer(data$month_2)


ui = dashboardPage(
  dashboardHeader(color = "violet", title = "Is your birthday famous?", titleWidth = "wide", inverted = TRUE),
  dashboardSidebar(
    size = "thin", color = "teal",
    sidebarMenu(
      menuItem(tabName = "main", "SEARCH BY DATE", icon = icon("calendar")),
      menuItem(tabName = "extra", "SEE RAW DATA", icon = icon("table")),
      menuItem(tabName = "aboutus", "ABOUT US")
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
              plotOutput("dotplot1")
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
              plotOutput("dotplot2")
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
    
    output$dotplot1 = renderPlot({
      ggplot() + 
        geom_map(
          data = world_coordinates, map = world_coordinates,
          aes(long, lat, map_id = region),
          color = "black", fill = "lightyellow"
        ) +
        geom_point(
          data = filtered_data, aes(bplo1, bpla1),
          color = "red"
        ) 
    })
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
  
    output$dotplot2 = renderPlot({
    ggplot(filtered_data, aes_string(x = inputx)) +
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
