bd_tiempo_real_flag <- function(bd_treal, tb_rf, tb_ro){

  bd_rf <- function(bd_treal, tb_rf){  

    rf <- function(x, L1, L2, L3, L4){
      
      y <- recoder::recoder(
        var = x, 
        recode = paste0(
          ">= ", L2, " & <= ", L3, ": 'VA'; ",
          ">= ", L1, " & <  ", L2, ": 'VE'; ",
          ">  ", L3, " & <= ", L4, ": 'VE'; ",
          "<  ", L1, " | >  ", L4, ": 'IR'"), 
        na = 'ND'
      )
      
      return(y)
      
  }
    
    # Nota: VA: Válido, VE: Valor por evaluar rango operativo o físico de equipo y IR: Inválido por rango operativo o físico de equipo
    
    coi <- base::intersect(x = colnames(bd_treal), y = dplyr::pull(tb_rf, NVARIABLES))
    
    m <- length(coi)
  
    for (i in 1:m){
      
    e <- coi[i]; x <- dplyr::pull(bd_treal, e)
    
    L1 <- dplyr::filter(tb_rf, NVARIABLES == e) %>% dplyr::pull(L1)
    L2 <- dplyr::filter(tb_rf, NVARIABLES == e) %>% dplyr::pull(L2)
    L3 <- dplyr::filter(tb_rf, NVARIABLES == e) %>% dplyr::pull(L3)
    L4 <- dplyr::filter(tb_rf, NVARIABLES == e) %>% dplyr::pull(L4)
  
    v <- rf(x = x, L1 = L1, L2 = L2, L3 = L3, L4 = L4) %>% tibble() 
    
    colnames(v) <- paste("B", e, sep = "_")
    
    ifelse(i == 1, aux <- v, aux <- dplyr::bind_cols(aux, v))
    
  }
    
    return(aux)
    
  }
  
  bd_ro <- function(bd_treal, tb_ro){
    
 ro <- function(x, Linf, Lsup){
      
       L0 <- stringr::str_extract(Linf, "-\\d+\\.*\\d*|\\d+\\.*\\d*") %>% as.numeric()
      S0a <- ifelse(length(grep(pattern = "[", x = Linf, fixed = TRUE)) == 1, ">=", ">" )
      S0b <- ifelse(length(grep(pattern = "[", x = Linf, fixed = TRUE)) == 1,  "<", "<=")
      
       L1 <- stringr::str_extract(Lsup, "-\\d+\\.*\\d*|\\d+\\.*\\d*") %>% as.numeric()
      S1a <- ifelse(length(grep(pattern = "]", x = Lsup, fixed = TRUE)) == 1, "<=", "<" )
      S1b <- ifelse(length(grep(pattern = "]", x = Lsup, fixed = TRUE)) == 1,  ">", ">=")
      
      y <- recoder::recoder(
        var = x, 
        recode = paste0(
          S0a, L0, " & ", S1a, L1, ": 'VA'; ",
          S0b, L0, " | ", S1b, L1, ": 'VE'  "), 
        na = NA
      )
      
      return(y)
      
    }
    
    # Nota: VA: Válido, VE: Valor por evaluar rango operativo o físico de equipo
    
    coi <- base::intersect(x = colnames(bd_treal), y = dplyr::pull(tb_ro, NVARIABLES))
    
    m <- length(coi)
    
    for (i in 1:m){
      
      e <- coi[i]; x <- dplyr::pull(bd_treal, e)
      
      Linf <- dplyr::filter(tb_ro, NVARIABLES == e) %>% dplyr::pull(Linf)
      Lsup <- dplyr::filter(tb_ro, NVARIABLES == e) %>% dplyr::pull(Lsup)
      
      v <- ro(x = x, Linf = Linf, Lsup = Lsup) %>% tibble() 
      
      colnames(v) <- paste("B", e, sep = "_")
      
      ifelse(i == 1, aux <- v, aux <- dplyr::bind_cols(aux, v))
      
    }
    
    return(aux)
    
  }
  
  nom_bd_treal <- colnames(bd_treal)
  
  nom_tb_rf <- tb_rf %>% dplyr::pull(NVARIABLES)
  
  nom_tb_ro <- tb_ro %>% dplyr::pull(NVARIABLES)
  
  sw1 <- length(intersect(x = nom_bd_treal, y = nom_tb_rf)) > 0
  
  sw2 <- length(intersect(x = nom_bd_treal, y = nom_tb_ro)) > 0
  
  if(sw1 && sw2){
    
    bd <- dplyr::bind_cols(list(bd_rf(bd_treal, tb_rf),  bd_ro(bd_treal, tb_ro)))
  
  }else{
    
    if(sw1){
      
      bd <- bd_rf(bd_treal, tb_rf)
      
    }
    
    if(sw2){
      
      bd <- bd_ro(bd_treal, tb_ro)
      
    }
    
  }
    
  return(bd)
  
}
# 
# bd_treal <- bd0
# tb_rf <- RANGOS_FISICOS
# tb_ro <- RANGOS_OPERATIVOS
# bd1 <- bd_tiempo_real_flag(bd_treal = bd0, tb_rf = RANGOS_FISICOS, tb_ro = RANGOS_OPERATIVOS)
