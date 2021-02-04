#Descargue los archivos csv que corresponden a las temporadas
#2017/2018, 2018/2019, 2019/2020 de la primera división de la liga española

url1 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
url2 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url3 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"

fut1718 <- read.csv(file = url1)
fut1819 <- read.csv(file = url2)
fut1920 <- read.csv(file = url3)

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
dim(fut1720)

#Crear el data frame SmallData
#columnas: date, home.team, home.score, away.team, away.score

SmallData <- select(fut1720, date = Date, home.team = HomeTeam, home.score = FTHG, 
                    away.team = AwayTeam, away.score = FTAG)

#Crear un directorio y guardar el df como .csv con nombre soccer.csv
#row.names = FALSE en write.csv

write.csv(x = SmallData, file = "soccer.csv", row.names = FALSE)

#Usando create.fbRanks.dataframes importar el archivo soccer.csv
#y asignarlo a una var. llamada listasoccer

library(fbRanks)
listasoccer <- create.fbRanks.dataframes(scores.file = "soccer.csv")

#Asignar los data frames scores y teams a variables llamadas anotaciones y equipos

anotaciones <- listasoccer$scores
equipos <- listasoccer$teams

#Usando unique crear vector de fechas que no se repitan
#Estas deben coincidir con fechas en las que se jugaron partidos

fecha <- unique(anotaciones$date) 

#Crear variable  n que contenga el número de fechas diferentes
 
n <- length(fecha)
 
#usando rank.teams (anotaciones, equipos) crear ranking de equipos 
#Usando únicamente datos desde fecha inicial y hasta la penúltima
#Estás se deben especificar en max.date y min.date

ranking <- rank.teams(scores = anotaciones, teams = equipos, max.date = fecha[n-1], min.date = fecha[1])

#Estimar probabilidades de los eventos para los partidos que se 
#Jugaron en la última fecha del vector "fecha"
#Tip: usando predict (ranking, fecha[n])

prob <- predict(ranking, date = fecha[n])
