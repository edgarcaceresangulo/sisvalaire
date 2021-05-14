library(shiny)
library(RJDBC)
library(DBI)
library(dplyr)
library(lubridate)
library(shinyTime)
library(DT)
library(magrittr)
library(tidyr)
library(tibble)
library(writexl)
library(data.table)
library(recoder)
library(stringr)
library(readxl)
library(shinyWidgets)
library(tidyselect)

# Funciones globales:
funciones_globales_path <- "funciones_globales"
       objetos_globales <- "objetos_globales"

# Funciones locales:
funciones_locales_path <- "funciones_locales"
       objetos_locales <- "objetos_locales"

       ESTACIONES <- readxl::read_excel(path = file.path(objetos_globales, "TABVIGAMB.xlsx"), sheet = "ESTACIONES")
          EQUIPOS <- readxl::read_excel(path = file.path(objetos_globales, "TABVIGAMB.xlsx"), sheet = "EQUIPOS")
          EST_PAR <- readxl::read_excel(path = file.path(objetos_globales, "TABVIGAMB.xlsx"), sheet = "EST_PAR")
          VAR_EST <- readxl::read_excel(path = file.path(objetos_globales, "TABVIGAMB.xlsx"), sheet = "VAR_EST")
        VARIABLES <- readxl::read_excel(path = file.path(objetos_globales, "TABVIGAMB.xlsx"), sheet = "VARIABLES")
   RANGOS_FISICOS <- readxl::read_excel(path = file.path(objetos_globales, "TABVIGAMB.xlsx"), sheet = "RANGOS_FISICOS")
RANGOS_OPERATIVOS <- readxl::read_excel(path = file.path(objetos_globales, "TABVIGAMB.xlsx"), sheet = "RANGOS_OPERATIVOS")
       PPB_A_UGM3 <- readxl::read_excel(path = file.path(objetos_globales, "TABVIGAMB.xlsx"), sheet = "PPB_A_UGM3")
     PASE_1MIN_1H <- readxl::read_excel(path = file.path(objetos_globales, "TABVIGAMB.xlsx"), sheet = "PASE_1MIN_1H")

source(file.path(funciones_globales_path, "sel_var.R"), local = TRUE, encoding = "utf-8")
source(file.path(funciones_globales_path, "bd_tiempo_real.R"), local = TRUE, encoding = "utf-8")
source(file.path(funciones_globales_path, "bd_tiempo_real_flag.R"), local = TRUE, encoding = "utf-8")
source(file.path(funciones_locales_path, "tabladatos.R"), local = TRUE, encoding = "utf-8")
source(file.path(funciones_globales_path, "ordparflag.R"), local = TRUE, encoding = "utf-8")
