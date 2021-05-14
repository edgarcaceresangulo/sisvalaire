sel_var <- function(tb_estaciones, tb_var_est, x, y){

  sel <- tb_estaciones %>% 
    dplyr::filter(ID_ESTACION == x) %>% 
    dplyr::pull(COD_ESTACION)

  v <- tb_var_est %>% 
    dplyr::filter(.data[[sel]] == 1 & PARAMETROS %in% c("Sistema",y)) %>% 
    dplyr::pull(VARIABLES) %>% 
    paste0(., collapse = ",")

  return(v)
  
}
