server <- shinyServer(function(input, output, session){

  observe({
    
    updateSelectInput(session, "station", choices = c(ESTACIONES[["ESTACION"]]))
    
  })

  observe({
    
    req(input$station)

    x <- input$station
    io <- base::subset(ESTACIONES, ESTACION == x)[["INICIO_OPER"]]
    fo <- base::subset(ESTACIONES, ESTACION == x)[["FIN_OPER"]]

    if(fo == "NA"){ fo <- Sys.Date() }

    updateDateInput(
      session,
      inputId = "start_date",
      value = base::as.Date(fo, "%Y-%m-%d") - 5,
      min = base::as.Date(io, "%Y-%m-%d"),
      max = base::as.Date(fo, "%Y-%m-%d")
    )
    
    updateDateInput(
      session,
      inputId = "end_date",
      value = base::as.Date(fo, "%Y-%m-%d"),
      min = base::as.Date(io, "%Y-%m-%d"),
      max = base::as.Date(fo, "%Y-%m-%d")
    )

  }) # Cierra start_date

  # observe({
  #   
  #   req(input$station)
  #   
  #   x <- input$station
  #   fo <- base::subset(ESTACIONES, ESTACION == x)[["FIN_OPER"]]
  #   io <- base::subset(ESTACIONES, ESTACION == x)[["INICIO_OPER"]]
  #   
  #   if(fo == "NA"){ fo <- Sys.Date() }
  #   
  #   updateDateInput(
  #     session,
  #     inputId = "start_date",
  #     value = base::as.Date(io, "%Y-%m-%d")-5,
  #     min = base::as.Date(io, "%Y-%m-%d"),
  #     max = base::as.Date(fo, "%Y-%m-%d")
  #   )
  #   
  # }) # Cierra end_date
  
  mpar <- reactive({
    
    sort(unique(dplyr::filter(EST_PAR[c("ESTACION","PARAMETROS")], ESTACION == input$station))[[2]])

  }) # Cierra reactive

  observeEvent(mpar(), {

  choices <- mpar()
  updateSelectInput(session, "multi_parametro", choices = choices, selected = head(choices, 1))
  
  }) # Cierra observeEvent
  
  parametros <- reactive({
    
    req(input$multi_parametro)
    
      st <- dplyr::filter(ESTACIONES, ESTACION == input$station) %>% magrittr::extract2(1)
      f1 <- paste(input$start_date, strftime(input$start_time, "%T"), sep = " ")
      f2 <- paste(input$end_date, strftime(input$end_time, "%T"), sep = " ")
multipar <- input$multi_parametro
  
    list(st = st, f1 = f1, f2 = f2, multipar = multipar)

  }) # Cierra reactive parámetros

  datos <- reactive({
    
    st <- parametros()$st; f1 <- parametros()$f1; f2 <- parametros()$f2; multipar <- parametros()$multipar
    
    v <- sel_var(tb_estaciones = ESTACIONES, tb_var_est = VAR_EST, x = st, y = multipar)
    
    bd_treal <- bd_tiempo_real(v = v, tb_variables = VARIABLES, x = st, f1 = f1, f2 = f2, ruta = objetos_globales)
    
    bd_treal_flag <- bd_tiempo_real_flag(bd_treal = bd_treal , tb_rf = RANGOS_FISICOS, tb_ro = RANGOS_OPERATIVOS)
    
    nom_st <- input$station
    
    list(bd = bd_treal, flag = bd_treal_flag, nom_st = nom_st)
    
  }) # Cierra datos

  tb_reactive <- eventReactive(input$goButton, {
   
   bd <- datos()$bd; flag <- datos()$flag; sw <- input$Id016
   
   tabladatos(bd = bd, flag = flag, sw = sw)
     
  }) # Cierra bd_reactive

  output$table <- DT::renderDataTable({
    
    tb_reactive()

  }) # Cierra datatable

  output$mensaje <- renderUI({
    
    shiny::includeMarkdown(path = file.path(objetos_globales, "leyenda.md"))

  }) # Cierra mensaje
  
  output$condP <- reactive({ input$Id016 }) # Cierra condP
  
  outputOptions(output, "condP", suspendWhenHidden = FALSE) # outputOptions
  
  output$downloadData <- downloadHandler(

    filename = function(file) {

      paste(datos()$nom_st, " ", format(Sys.time(), "%Y-%m-%d %Hh %Mm %Ss"), ".xlsx", sep = "")

    },
    
    content = function(file) {
      
      if(input$Id016){
        
        tb <- as.data.frame(ordparflag(datos()$bd, datos()$flag))

      }else{

        tb <- as.data.frame(datos()$bd)
        
      }
      
      write_xlsx(x = tb, path = file)

    }

  ) # Cierra downloadData

}) # Cierra shinyServer