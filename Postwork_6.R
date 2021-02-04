#Importar el conjunto match.data.csv

library(dplyr)
match <- read.csv("match.data.csv")
head(match)

#Agregar una columna sumagoles - suma de goles por partido

sumagoles <- match$home.score + match$away.score
match <- cbind(match,sumagoles)

#Promedio por mes de la suma de goles

consulta <- match %>% 
  mutate(date = as.Date(date, "%Y-%m-%d")) %>%
  mutate(mes = format(date, "%Y-%m")) %>%
  group_by(mes) %>%
  summarise(PromedioGolesMes = mean(sumagoles))

#Serie de tiempo del promedio hasta dic. 2019
consulta <- as.data.frame(consulta)
consulta <- (consulta[1:95,])

st.promedio <- ts(consulta$PromedioGolesMes, start = c(1,1),frequency = 10)

#Gráfica de la ST

plot(st.promedio, main="Serie de tiempo", ylab = "Promedio por mes de la suma de goles", xlab = "Años (2010-2019)")
