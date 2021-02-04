#Descargar los archivos csv que corresponden a las temporadas
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

#---------------- Postwork 3 ---------------
#TABLAS DE FRECUENCIAS RELATIVAS
#Probabilidades estimadas marginales y conjuntas

a <- (table(fut1720$FTHG)/dim(fut1720)[1])*100 #De que el equipo que juega casa anote X goles

b <- (table(fut1720$FTAG)/dim(fut1720)[1])*100 #De que el equipo que juega visitante anote Y goles

c <- (table(fut1720$FTHG, fut1720$FTAG)/dim(fut1720)[1])*100 # De que el equipo que juega casa anote X goles y el equipo visitante anote Y goles

#GRÁFICA DE BARRAS

library(ggplot2)

# De probabilidad para el equipo que juega casa 

casa <- as.data.frame(a)
str(casa)

ggplot(casa, aes(x = Var1, y = Freq))+
  xlab("# Goles") +
  ylab("Probabilidad marginal estimada")+
  ggtitle("Probabilidades del equipo casa")+
  geom_bar(stat = "identity",  fill ="purple") +
  theme_light()

# De probabilidad para el equipo que juega visitante
visitante <- as.data.frame(b)
str(visitante)

ggplot(visitante, aes(x = Var1, y = Freq))+
  xlab("# Goles") +
  ylab("Probabilidad marginal estimada")+
  ggtitle("Probabilidades del equipo visitante")+
  geom_bar(stat = "identity",  fill ="purple") +
  theme_light()

# De probabilidad de que el equipo que juega casa
#anote X goles y el equipo visitante anote Y goles

conjunta <- as.data.frame(c)
str(conjunta)

ggplot(conjunta, aes(Var1, Var2))+
  xlab("Equipo casa") + 
  ylab("Equipo visitante")+
  geom_tile(aes(fill = Freq)) +
  ggtitle("Probabilidades conjuntas")+
  theme(axis.text.x = element_text(angle = 90, hjust = 0))