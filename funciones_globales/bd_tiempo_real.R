bd_tiempo_real <- function(v, tb_variables, x, f1, f2, ruta){

  # driver <- RJDBC::JDBC(driverClass = "oracle.jdbc.driver.OracleDriver",
  #                       classPath = file.path(ruta, "ojdbc7.jar"))
  # 
  # conexion <-
  #   DBI::dbConnect(driver, "jdbc:oracle:thin:@localhost:1521:xe", "", "")
  # 
  # result <- DBI::dbSendQuery(conexion, statement = paste(
  #   "SELECT ",v,
  #   " FROM VIGAMB.VIGAMB_TRAMA_AIRE",
  #   " WHERE ID_ESTACION = ", x,
  #   " AND FECHA_DATA_LOGGER_TIMESTAMP BETWEEN to_date(to_char('", f1,
  #   "'), 'YYYY-MM-DD HH24:MI:SS') AND to_date(to_char('", f2,
  #   "'), 'YYYY-MM-DD HH24:MI:SS')",
  #   " ORDER BY FECHA_DATA_LOGGER_TIMESTAMP",
  #   sep = ""))

  # bd <- DBI::dbFetch(result)
  

  
  
  
  
  # Eliminar-----------------------------
  
  # bd <- readRDS(file = "bd_2020.rds")
  # 
  # int <- lubridate::interval(f1, f2)
  # 
  # bd <- bd %>% 
  #   dplyr::select(unlist(strsplit(v, ","))) %>% 
  #   dplyr::filter(ID_ESTACION == x) %>% 
  #   dplyr::mutate(
  #     FECHA_DATA_LOGGER_TIMESTAMP = as.POSIXct(strptime(FECHA_DATA_LOGGER_TIMESTAMP, format = "%Y-%m-%d %H:%M:%S", tz = "UTC"))
  #   )
  # 
  # bd <- bd[bd$FECHA_DATA_LOGGER_TIMESTAMP %within% int,]
  
  # Eliminar-----------------------------
  
  v <- stringr::str_split(string = v, ",")[[1]]
  
    bd <- readRDS(file = "VIGAMB.rds") %>% 
    dplyr::select(!!v) %>% 
    dplyr::filter(ID_ESTACION == x) %>% 
    dplyr::mutate(
      FECHA_DATA_LOGGER_TIMESTAMP = as.POSIXct(strptime(FECHA_DATA_LOGGER_TIMESTAMP, format = "%Y-%m-%d %H:%M:%S", tz = "UTC"))
    ) %>% 
    dplyr::filter(FECHA_DATA_LOGGER_TIMESTAMP %within% lubridate::interval(f1, f2)) %>% 
    dplyr::arrange(., FECHA_DATA_LOGGER_TIMESTAMP)
  
  nv <- dplyr::left_join(x = tibble::tibble(VARIABLES = v), y = tb_variables, by = "VARIABLES") %>% 
    dplyr::pull(NVARIABLES)

  data.table::setnames(x = bd, old = v, new = nv)

  bd <- bd %>% 
    dplyr::mutate(
      date = as.POSIXct(strptime(date, format = "%Y-%m-%d %H:%M:%S", tz = "UTC"))) %>%
  # tidyr::complete(
  #     date = base::seq.POSIXt(
  #       from = min(date, na.rm = T),
  #       to = max(date, na.rm = T),
  #       by = "1 min")) %>%
    dplyr::arrange(., date) %>%
    dplyr::select(-ID_ESTACION)
  


  return(bd)
  
  # DBI::dbClearResult(result)
  # DBI::dbDisconnect(conexion)
  # 
}

#bd_tiempo_real: Contiene datos 100% crudos
# x <- 2
# f1 <- "2021-01-22 00:00:00"
# f2 <- "2021-05-27 12:00:00"
# ruta <- "C:/Users/Usuario/Desktop/proyecto2/sisvalaire/modulo_01/objetos_globales"
# y <- c("Meteorología")
# v <- sel_var(tb_var_est = VAR_EST, tb_estaciones = ESTACIONES, x = x, y = y)
# 
# bd0 <- bd_tiempo_real(v = v, tb_variables = VARIABLES, x = x, f1 = f1, f2 = f2, ruta = ruta)
# bd0
