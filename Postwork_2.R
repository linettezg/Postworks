#Descargar los archivos csv que corresponden a las temporadas
#2017/2018, 2018/2019, 2019/2020 de la primera división de la liga española

url1 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
url2 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url3 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

fut1718 <- read.csv(file = url1)
fut1819 <- read.csv(file = url2)
fut1920 <- read.csv(file = url3)

#Obtener las características de los df usando
#str, head, View, summary

#Temporada 17-18
str(fut1718); head(fut1718) ; View(fut1718) ; summary(fut1718)
#Temporada 18-19
str(fut1819); head(fut1819) ; View(fut1819) ; summary(fut1819)
#Temporada 19-20
str(fut1920); head(fut1920) ; View(fut1920) ; summary(fut1920)

#Con la función select del paquete dplyr selecciona las columnas
#Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR
library(dplyr)
lista <-list(fut1718,fut1819,fut1920)
lista <- lapply(lista, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

#Asegurarse que los elementos de las columnas sean del mismo tipo
#as.Date y mutate para fechas
lista[[1]] <-mutate(lista[[1]], Date = as.Date(Date, "%d/%m/%y"))
lista[[2]] <-mutate(lista[[2]], Date = as.Date(Date, "%d/%m/%y"))
lista[[3]] <-mutate(lista[[3]], Date = as.Date(Date, "%d/%m/%y"))

#Con rbind formar un único dataframe que tenga las 6 columnas
#do.call podría usarse
fut1720 <- do.call(rbind, lista)
str(fut1720)
