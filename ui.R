ui <- shinyUI(function(req){fluidPage(

  includeCSS("www/styles.css"),

  headerPanel("Módulo 1: Datos crudos"),

  fluidRow(

    column(2,
      
      wellPanel(
        
        tags$h5(strong("Estación:")),
        selectInput("station",
                    label = NULL,
                    choices = NULL,
                    width = "55%"),
        
        tags$h5(strong("Rango de tiempo")),

        tags$h5("Inicio:"),
        dateInput(inputId = "start_date",
                  label = NULL,
                  width = "45%",
                  language = "es"), 
        timeInput(inputId = "start_time", label = NULL, value = strptime("00:00:00", "%T")),

        tags$h5("Fin:"),
        dateInput(inputId = "end_date",
                  label = NULL,
                  width = "45%",
                  language = "es"),
        timeInput(inputId = "end_time", label = NULL, value = strptime("23:59:59", "%T")),
        
        tags$h5(strong("Parámetro(s):")),
        selectizeInput(
          inputId = "multi_parametro",
          label = NULL,
          choices = NULL,
          multiple = TRUE,
          options = list(placeholder = "Seleccione alguno"),
          width = "80%"
        ), 
        
        tags$h5(strong("Ver flag:")),
        switchInput(
           inputId = "Id016",
           size = "mini"
        ),

        actionButton("goButton", "Ejecutar"),

        tags$h5(strong("Descargar:")),
        downloadButton("downloadData", "Datos (.xlsx)"),

        conditionalPanel(condition = "output.condP", uiOutput("mensaje"))

        ) # Cierra wellPanel

    ), # Cierra column(3,

    column(10, align = "center",

      tabsetPanel(type = "tabs",
  
        tabPanel("Tabla de datos", br(), DT::dataTableOutput("table"))
        
      ) # Cierra tabsetpanel

    ) # Cierra column(9, 
    
  ) # Cierra fluidRow
  
)}) # Cierra fluidPage y shinyUI