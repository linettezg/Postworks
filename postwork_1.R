#Importar datos de temp 19/20 de la 1ra división

soccer <- read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
dim(soccer)

#Extraer columnas con goles de casa y goles de visitantes

soccer$FTHG  #Casa
soccer$FTAG  #Visitante

#TABLAS DE FRECUENCIAS RELATIVAS
# Probabilidades marginales

(table(soccer$FTHG)/dim(soccer)[1])*100 #De que el equipo que juega casa anote X goles

(table(soccer$FTAG)/dim(soccer)[1])*100 #De que el equipo que juega visitante anote Y goles

(table(soccer$FTHG, soccer$FTAG)/dim(soccer)[1])*100 # De que el equipo que juega casa anote X goles y el equipo visitante anote Y goles
