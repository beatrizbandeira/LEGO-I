# Script da Aula 1
# Aluna: Beatriz Bandeira de Mello
# LEGO I

require(stringr)
require(tidyverse)

#Exercício 1: primeiros passos com R

meu_ano_nascimento <- 1993
ano_atual <- 2024
minha_idade <- ano_atual- meu_ano_nascimento
minha_idade

#Exercício 2: trabalhando com textos

meu_nome <- "Beatriz"
paste("Meu nome é", meu_nome) #Paste combina textos e números

#Exercício 3: usando funcoes basicas

nchar (meu_nome)
raiz_nome <- sqrt (nchar (meu_nome))
raiz_nome

#Exercício 4: criando e usando vetores

notas <- c(8.9, 9, 8.5, 9.5, 9.5)
media_notas <- mean(notas)
media_notas

#Exercício 5: usando logica condicional

aprovado <- media_notas > 8 #Retorna TRUE se a media das notas for maior que 8
media_notas

if(media_notas > 8) {
  resultado <- "APROVADO"
  print (resultado)
} else {
  resultado <- "REPROVADO"
  print (resultado)
}

#Exercício 6: trabalhando com textos - strings

nome_abreviado <- abbreviate(meu_nome) #A funcao remove as vogais do nome
nome_abreviado

#Exercício 7: operacoes com vetores

anos <- seq(ano_atual-4, ano_atual)
minhas_idades <- anos - meu_ano_nascimento
minhas_idades

media_idades <- mean(minhas_idades)
media_idades

x <- anos - media_idades
x

#Exercício 8: operacoes com vetores II

notas
notas_abaixo_media <- notas > media_notas
abaixo_media <- notas[notas_abaixo_media] #Criei um objeto apenas com as notas abaixo da media de notas   
abaixo_media

#Exercicio 9: Explorando data.frames

dados_pessoais <- data.frame(
  ano <- anos,
  idade <- minhas_idades
  )

names(dados_pessoais) #Nome da linha e da coluna
nrow(dados_pessoais) #Numero de linhas
ncol(dados_pessoais) #Numero de colunas
View(dados_pessoais) #Abre visualizacao em formato de excel

#Exercicio 10: manipulando data.frames

#data.frame

capitais_sudeste = data.frame(
  capitais = c("Belo Horizonte", "São Paulo", "Rio de Janeiro", "Vitória"),
  estados = c("MG", "SP", "RJ", "ES"),
  populacao_por_mil = c(2315, 11451, 6211, 322)
)

print(capitais_sudeste)

gd.pop <- capitais_sudeste$populacao_por_mil>5000

capitais_sudeste[gd.pop,] #Versao modificada, o teste logico filtrou as linhas

#Nesse caso, como eu tive muitas dificuldades em escrever um código mais simples, então fui destrinchando
#em etapas menores pra tentar entender a lógica por trás dos comandos

#Exercicio 11: manipulando data.frames II



#Exercício 12: instalação e uso de pacotes

require(ggplot2)

ggplot(data = dados_pessoais, aes(x = anos, y = idade)) +
  geom_line() +
  geom_point()
