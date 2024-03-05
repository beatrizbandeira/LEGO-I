#Exercícios - Aula 2 - LEGO I
#Aluna: Beatriz Bandeira de Mello

getwd()

require(readx1)
require(readODS)
require(haven)
require(rio)
require(tidyverse)

#Exercício 1 - Carregando arquivos simples I
pessoas <- read_delim("pessoas.csv") #Usei o modo de carregamento de arquivos csv
head(pessoas)

#Exercicio 2 - carregando arquivos simples II
satisfacao <- read_delim("pesquisa_satisfacao.txt")
head(satisfacao) #Usei o modo de carregamento de arquivos txt

#Exercicio 3 - Carregando arquivos simples III
#O arquivo inventário não estava na pasta

#Exercicio 4 - Carregando arquivos delimitados
casos <- read_delim("casos_registrados.csv", delim = ",", skip = 2)
head(casos) #Segui a instrução do capítulo e usei o skip para pular algumas linhas em branco

#Exercicio 5 - Carregando arquivos de outros formatos I
censo <- read_delim("https://raw.githubusercontent.com/izabelflores/Censo_1872/main/Censo_1872_dados_tidy_versao2.csv",
                    delim = ";",
                    locale = locale(encoding = "latin1")) #Corrige problemas de acentuação
head(censo)

#Exercicio 6- Carregando arquivos de outros formatos II

airbnb_arraial <- read_xlsx("dados_airbnb_arraial.xlsx")
head(airbnb_arraial)

#Exercicio 7 - Carregando microdados administrativos

inep_2022 <- read_delim("microdados_inep_22.csv", delim = ";")
names(inep_2022)
nrow(inep_2022)
ncol(inep_2022)
