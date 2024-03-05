#Exercicios - Aula 3 - LEGO 1
#Aluna: Beatriz Bandeira de Mello

getwd()

require(tidyverse)
require(heaven)
require(readxl)

#Exercicio 1 - Filtrando bases de dados

populacao_q <- read_delim("pop_quilombola.csv", delim = ",")
populacao_q_100 <- slice(populacao_q,seq(1:100)) #Passa um vetor para a função indicando a posição que quer manter
print(populacao_q_100)

#Exercicio 2 - Filtrando bases de dados II

populacao_q_1 <- filter(populacao_q, pop_quilombola >= 1)
print(populacao_q_1) #O resultado mostra que existem 1700 municipios com ao menos 1 pessoa identificada como quilombola

#Exercicio 3 - Seleção de variáveis, filtragem e ordenamento

populacao <- read_xlsx("pop_total.xlsx")
print(populacao)

populacao <- arrange(populacao, desc(pop_total))
maiores_populacoes <- slice(populacao, seq(1,50))
maiores_populacoes[50,2] #Reposta Mogi das Cruzes (SP)

#Exercicio 4 - Criação de variáveis

populacao_peq <- mutate(populacao, 
                  habitantes_1000 = pop_total / 1000, 
                  capitais_pequenas = if_else(pop_total < 50000, "Pequeno porte", "Outros"))

print(populacao_peq) #Outra opção é usar o case_when() para várias opções de teste

#Exercicio 5 - Resumo de variáveis

print(populacao_q)
summarise(populacao_q, populacao_total = sum(pop_quilombola))

summarise(populacao, 
          populacao_total = sum(pop_total)/1000000,
          media_populacao = sum(pop_total)/5570,
          menor_populacao = min(pop_total),
          maior_populacao = max(pop_total)
          )

#Resume informaçoes em uma única linha, mas as funções estão dentro dela

#Exercicio 6 - Cruzando bases de dados I
#Funcao _join para cruzar pop_quilombola e pop_total

uf_municipios <- read_delim("uf_municipios.csv", delim = ",")

populacao <- mutate(populacao, cod_ibge = as.character(cod_ibge))
populacao_q <- mutate(populacao_q, cod_ibge = as.character(cod_ibge))

municipios <- left_join(populacao, populacao_q, by = join_by(cod_ibge == cod_ibge))
View(municipios)

#Exercicio 7 - Criação de variáveis, filtragem e ordenamento

municipios_pop_quilombola <- mutate(municipios, proporcao_quilombola = pop_quilombola/pop_total * 100)
View(municipios_pop_quilombola)

municipios_pop_quilombola <- arrange(municipios_pop_quilombola, desc(proporcao_quilombola))
municipios_pop_quilombola[1:3,2:5] #Alcântara (MA), Berilo (MG) e Cavalcante (GO)

#Exercicio 8 - Cruzamento de bases de dados II

uf_municipios <- mutate(uf_municipios, cod_ibge = as.character(cod_ibge))
municipios <- right_join (uf_municipios, municipios, by = join_by(cod_ibge))
print(municipios)

#Exercicio 9 - Agrupamento e resumo de variáveis I

regioes <- group_by(municipios, regiao)
summarise(regioes, populacao_quilombola = sum(pop_quilombola))
summarise(regioes, populacao_total = sum(pop_total))

#Exercício 10 - Agrupamento e resumo de variáveis II

municipios <- mutate(municipios, proporcao = pop_quilombola/pop_total)
municipios <- arrange(municipios, desc(proporcao))
slice(municipios, 1:5) #Alcântara (MA), Berilo (MG) e Cavalcante (GO), Serrano do Maranhão (GO) e Bonito (MA)

#Exercicio 11 - Agrupamento e criação de variáveis

uf <- group_by(municipios, sigla_uf)
taxa_pop_quilombola <- summarise(uf, taxa = sum(pop_quilombola/pop_total)/100000)
print(taxa_pop_quilombola)

taxa_pop_quilombola <- arrange(taxa_pop_quilombola, desc(taxa))
print(taxa_pop_quilombola)
