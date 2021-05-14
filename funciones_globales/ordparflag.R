ordparflag <- function(bd, flag){
  
  x <- colnames(bd)
  y <- colnames(flag)
  id <- substring(y, 3)
  A <- data.frame(x, stringsAsFactors = FALSE)
  B <- data.frame(id, y, stringsAsFactors = FALSE)
  C <- dplyr::left_join(x = A, y = B, by = c("x" = "id"))

  u0 <- c(C$x, C$y)
  impar <- seq(from = 1, to = length(u0), by = 2)
    par <- impar + 1
     u1 <- c(impar, par)
  
  z <- tibble::tibble(u0 = u0, u1 = u1) %>% 
    dplyr::arrange(., u1) %>% 
    magrittr::extract2(1)
  
  sel <- as.character(stats::na.omit(z))
  
  bd_flag <- dplyr::bind_cols(list(bd, flag))
  
  bd_flag <- bd_flag[, sel]
  
  return(bd_flag)
  
}
