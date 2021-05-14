tabladatos <- function(bd, flag, sw){

  m1 <- ncol(bd); m2 <- ncol(flag); v <- colnames(flag)

  numc <- ifelse(sw, m1 + m2 , m1) # TRUE; con flag; m1 + m2 y FALSE; sin flag; m1

  fijarcol <- ifelse(numc >= 15, TRUE, FALSE) # TRUE; fija columna derecha; list(leftColumns = 1)
  
  if(sw){

    bd <- ordparflag(bd = bd, flag = flag)

    formatcol <- list(
      list(targets = 0, width = "110px"),
      list(targets = 0:(m1 + m2 - 1), className = "dt-head-center dt-center"))

    opc_bd <- list(
      pageLength = 100,
      searching = FALSE,
      autoWidth = TRUE,
      scrollX = TRUE,
      scrollY = "690px",
      scrollCollapse = "true",
      paging = "false",
      fixedColumns = fijarcol,
      columnDefs = formatcol,
      language = list(url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json"))

  }else{

    bd <- dplyr::bind_cols(list(bd, flag))

    formatcol <- list(
      list(targets = 0, width = "110px"),
      list(targets = 0:(m1 - 1), className = "dt-head-center dt-center"),
      list(targets = m1:(m1 + m2 - 1), visible = FALSE))

    opc_bd <- list(
      pageLength = 100,
      searching = FALSE,
      autoWidth = TRUE,
      scrollX = TRUE,
      scrollY = "690px",
      scrollCollapse = "true",
      paging = "false",
      fixedColumns = fijarcol,
      columnDefs = formatcol,
      language = list(url = "//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json"))

  }

  bd <- bd %>% 
    dplyr::mutate(date = as.character(date)) %>%
    DT::datatable(
      rownames = FALSE,
      extensions = c("FixedColumns"),
      options = opc_bd) %>%
    formatDate("date",
               method = "toLocaleString", 
               params = list(
                 "es-ES",
                 list(hour12 = FALSE) # Formato tiempo timeZone = "UTC",
               ))
  
  for(i in 1:m2){
    
    bd <- bd %>% 
      formatStyle(columns = stringr::str_sub(string = v[i], start = 3),
                  valueColumns = v[i],
                  backgroundColor = styleEqual(levels = c("VA","VE","IR","ND"),
                                               values = c(rgb( 87, 208,  6 , max = 256),   # Verde
                                                          rgb(255, 192,  0 , max = 256),   # Anaranjado
                                                          rgb(255,   0,  0 , max = 256),   # Rojo
                                                          rgb(255, 255, 255, alpha = 0, maxColorValue = 256)   # Blanco
                                                          ))) %>% 
      formatStyle(columns = v[i],
                  valueColumns = v[i],
                  backgroundColor = styleEqual(levels = c("VA", "VE", "IR", "ND"), 
                                               values = c(rgb(87, 208,  6 , max = 256),    # Verde
                                                          rgb(255, 192,  0 , max = 256),   # Anaranjado
                                                          rgb(255,   0,  0 , max = 256),   # Rojo
                                                          rgb(255, 255, 255, alpha = 0, maxColorValue = 256)   # Blanco
                                                          )))
    
  }

  return(bd)

}

# bd <- bd_treal
# flag <- bd1
