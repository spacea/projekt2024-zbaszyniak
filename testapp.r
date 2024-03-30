library(shiny)
library(semantic.dashboard)
library(ggplot2)
library(plotly)
library(DT)

world_coordinates = map_data("world")
data = read.csv("dane_projekt3.csv")
data$month_2 = as.integer(data$month_2)
df = read.csv("databasemap.csv")

ui = dashboardPage(
  dashboardHeader(color = "black", title = "Dayseek", inverted = TRUE),
  dashboardSidebar(
    size = "thin", color = "blue",
    sidebarMenu(
      menuItem(tabName = "main", "SEARCH BY DATE", icon = icon("calendar")),
      menuItem(tabName = "extra", "QUICK LOOK INTO DATASET", icon = icon("table")),
      menuItem(tabName = "aboutus", "ABOUT US", icon = icon("info"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "main",
        fluidRow(
          box(
            width = 8,
            height = 10,
            title = "Date Selection",
            color = "yellow",  
            ribbon = TRUE,
            collapsible = FALSE,
            title_side = "top left",
            column(
              width = 15,
              dateInput("selected_date", "Select a date you want to check", startview = "decade")
            )
          ),
          box(
            width = 8,
            height = 10,
            title = "People born on this date",
            color = "violet",  
            ribbon = TRUE,
            collapsible = FALSE,
            title_side = "top right",
            column(
            # tu trzeba jakoś wypisać nazwiska
              width = 6
            )
          ),
          box(
            width = 15,
            title = "Graph 1",
            h1("Where were they born?"),
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
            h1("Check what they are related to"),
            title = "Graph 2",
            color = "green",
            ribbon = TRUE,
            title_side = "top right",
            column(
              width = 15,
              selectInput(
                inputId = "x",
                label = h3("Choose a level."),
                choices = c("Level 1", "Level 2", "Level 3"),
                selected = "Level 1"
              ),
              br(),
              helpText("Here you can choose the level of categorization. Level 1 contains only four categories while level 3 contains 200 of them."),
              br(),
              plotlyOutput("plot2")
            )
          )
        )
      ),
      tabItem(
        tabName = "extra",
        fluidRow(
          box(
            width = 15,
            title = "Graph 1",
            h1("Number of people in dataset for each country"),
            color = "blue",
            ribbon = TRUE,
            title_side = "top right",
            column(
              width = 15,
              plotlyOutput("plot3")
            )
          ),
          box(
            width = 15,
            title = "Table 1",
            h1("Take a look at datatable"),
            color = "green",
            ribbon = TRUE,
            title_side = "top right",
            column(
              width = 15,
              dataTableOutput("datatable")
            )
          ),
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
        text = ~paste("Name:", name, "<br> Year of birth:", Year),  
        mode = "markers",
        marker = list(
          size = 13, 
          color = ~Year, 
          colorscale = "Blues", 
          colorbar = list(title = "Year")
                      )
              ) %>%
      layout(
        geo = list(
          scope = "world",  
          showland = TRUE,
          landcolor = "lightgray", 
          showcountries = TRUE,  
          countrycolor = "black"  
        )
      )
    
    
    output$plot1 = renderPlotly({mapa})
    
    # tu wypisać jakoś nazwiska
    
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
  
      output$plot2 = renderPlotly({
        plot_ly() %>%
          add_trace(data = filtered_data,
                    x = ~.data[[inputx]],
                    type = "histogram",
                    color = ~.data[[inputx]],
                    colors = "Blues"
                    ) %>%
          layout(xaxis = list(title = "Categories"), yaxis = list(title = "Number of people."))
      })
      

})
  colorscale1 = list(
    c(0, 'rgb(221,242,253)'),
    c(0.02, 'rgb(177,215,226)'),
    c(0.08, 'rgb(155,190,200)'),
    c(0.15, 'rgb(66,125,157)'),
    c(1, 'rgb(22,72,99)')
  )
  
  plot3 = plot_ly(df, type='choropleth', locations=df$CODE, z=df$n, text=df$n, colorscale = colorscale1)
  output$plot3 = renderPlotly({plot3})
  
  data_show = subset(filtered_data, select = c(-1, -2, -5, -6, -7, -8, -9, -10, -11, -12, -14, -15, -16, -17, -18, -20, -21, -22, -24))
  data_show = data_show[order(data_show$POPULARITY),]
  output$datatable = renderDataTable(data_show)
  
  
  
})
})

shinyApp(ui, server)

# co trzeba zrobic jeszcze + propozycje
# lista nazwisk
# oś czasu z osobami
# ladniejsza tabela w raw data 
# po kliknieciu na nazwisko danej osoby w jakis sposob zaznaczenie jej na wykresach np. zmiana koloru 
