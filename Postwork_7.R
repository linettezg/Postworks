#Usar manejador de BDD Mongodb Compass
library(mongolite)

#Alojar el fichero data.csv en una BD match_games
#Nombrar al collection = match
match <- read.csv('data.csv')

mongo_R = mongo(collection = "match", db = "match_games")
mongo_R$insert(match)

#Count sobre el no. de registros
mongo_R$count()

#Consulta - No. de goles del Real Madrid el 20-12-2015 y 
#contra qué equipo jugó
mongo_R$find('{"HomeTeam":"Real Madrid", "Date":"2015-12-20"}')

#Agregar dataset mtcars a la BDD
mongo_R = mongo(collection = "mtcars", db = "mtcars") 
mongo_R$insert(mtcars)

#Cerrar conexión con la BDD
rm(mongo_R)