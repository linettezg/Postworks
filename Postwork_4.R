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

#TABLAS DE FRECUENCIAS RELATIVAS
#Probabilidades estimadas marginales y conjuntas

casa <- round(table(fut1720$FTHG)/dim(fut1720)[1],3) #De que el equipo que juega casa anote X goles

visitante <- round(table(fut1720$FTAG)/dim(fut1720)[1],3) #De que el equipo que juega visitante anote Y goles

conjunta <- round(table(fut1720$FTHG, fut1720$FTAG)/dim(fut1720)[1],3) # De que el equipo que juega casa anote X goles y el equipo visitante anote Y goles

#TABLA DE COCIENTES
conjunta/(casa%*%t(visitante))

#Mediante PROCEDIMIENTO D BOOTsRAP obtener cocientes similares a los anteriores

#--------------------------------------------------
#Sacar muestreo
set.seed(17)
i = 1
promedios <- list(NULL)
while (i<=1000) {

muestra <- sample_n(fut1720, 380, replace = TRUE)
#head(muestra)

#Generar probabilidades
bt.casa <- round(table(muestra$FTHG)/dim(muestra)[1],3) #De que el equipo que juega casa anote X goles

bt.visitante <- round(table(muestra$FTAG)/dim(muestra)[1],3) #De que el equipo que juega visitante anote Y goles

bt.conjunta <- round(table(muestra$FTHG, muestra$FTAG)/dim(muestra)[1],3) # De que el equipo que juega casa anote X goles y el equipo visitante anote Y goles

#Tabla de cocientes
bt.cnte <- bt.conjunta/(bt.casa%*%t(bt.visitante))

promedios[[length(promedios)+1]] <- mean(bt.cnte)

i = i + 1
}

lista.cocientes <- do.call(rbind, promedios)
head(lista.cocientes)

plot(lista.cocientes)

lista.cocientes <- as.data.frame(lista.cocientes)
library(ggplot2)
ggplot(lista.cocientes, aes()) + 
  xlab("# Interación") +
  ylab("Promedio")+
  ggtitle("Promedio de Tablas de Cocientes fut 17-20")
#---------------------------------------------------

#library(boot)
#cocnt <- function(data, index){
  ##muestra <- data[index,]
  #muestra <- sample_n(data, 380, replace = TRUE)
  ##head(muestra)
  
  #bt.c <- round(table(muestra$FTHG)/dim(muestra)[1],3) #De que el equipo que juega casa anote X goles
  
  #bt.v <- round(table(muestra$FTAG)/dim(muestra)[1],3) #De que el equipo que juega visitante anote Y goles
  
  #bt.cj <- round(table(muestra$FTHG, muestra$FTAG)/dim(muestra)[1],3) # De que el equipo que juega casa anote X goles y el equipo visitante anote Y goles
  
  ##Tabla de cocientes
  #return(bt.cj/(bt.c%*%t(bt.v)))
  
#}

#set.seed(12345)
#myBootstrap <- boot(fut1720, rep, R=1000)
#myBootstrap

#set.seed(626)

#b <- boot(fut1720, cocnt, R=1000)
#b
#cat("Standard deviation of sdratio = ", sd(b$t[,1]), "\n")

#Mencionar en cuáles casos parece razonable que los cocientes de la tabla son iguales a 1

