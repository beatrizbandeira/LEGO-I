#Exercícios - Aula 4 - LEGO
#Aluna: Beatriz Bandeira de Mello

getwd()

require(tidyverse)
require(ggplot2)
require(dplyr)
require(readr)
require(rio)
require(haven)

eseb2022 <- read_sav("eseb2022.sav", encoding = "UTF-8")
eseb2022 <- as_factor(eseb2022) #Mostra o nome das categorias
View(eseb2022)

#Exercicio 1 - Gráfico de barras

ggplot(eseb2022, aes(x = Q10P2b)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Votos x Candidatos", 
         subtitle = "ESEB 2022",
         x = "Categoria",
         y = "Votos")

#Exercicio 2 - Gráfico de barras com facetas

ggplot(eseb2022, aes(x = Q10P2b)) +
  geom_bar() +
  facet_wrap (~ REG, ncol = 2) +
  labs(title = "Distribuição de votos por candidato",
       x = "Candidato",
       y = "Votos")

#Exercicio 3 - Gráficos de histograma

censo <- read_delim("https://raw.githubusercontent.com/izabelflores/Censo_1872/main/Censo_1872_dados_tidy_versao2.csv",
                    delim = ";",
                    locale = locale(encoding = "latin1"))

ggplot(censo, aes(x = Raças_Preto)) +
  geom_histogram()

#Exercicios 4 e 5 - Gráficos de barras com totais calculados e customização

#Calcular o total de pessoas por provincia

provincias <-group_by(censo, PrimeiroDeProvincia)
total_provincias <- summarize(provincias, pop_total = sum(Total_Almas))

#Criar gráfico de barras
ggplot(total_provincias, aes(x = PrimeiroDeProvincia, y = pop_total/10000)) +
  geom_col(fill = "purple",
          alpha = 0.8) +
  theme_light() +
  coord_flip() +
  labs(title = "População por província",
       subtitle = "ESEB 2022",
       x = "Província",
       y = "Total_População")
