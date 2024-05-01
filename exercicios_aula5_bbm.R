#Exercícios - Aula 5
#Aluna: Beatriz Bandeira de Mello

require(tidyverse)
require(modelsummary)
require(gt)
require(dbplyr)
require(readx1)
require(readODS)
require(haven)
require(rio)


# Capítulo 5 -------------------------------------------------------------------


#1: Medidas de tendência central (total, média e mediana)
#Tratamento do banco de dados antes das análises

renda <- read_delim("distribuicao_renda_rfb.txt", delim = ";")
renda <- renda %>%
  mutate_at(vars(rendimentos_tributaveis_milhoes, imposto_devido_milhoes,
                 bens_milhoes, rendimentos_isentos_milhoes), 
            ~ str_replace(., ",", ".")) %>%  
  mutate_at(vars(rendimentos_tributaveis_milhoes, imposto_devido_milhoes,
                 bens_milhoes, rendimentos_isentos_milhoes), as.numeric)

View(renda)

renda_centil <- renda %>% 
  group_by(centil) %>% 
  summarise(total_renda = sum(rendimentos_tributaveis_milhoes),
            media_renda = mean(rendimentos_tributaveis_milhoes),
            mediana_renda = median(rendimentos_tributaveis_milhoes)) 

View(renda_centil)

#2: Dispersão (desvio-padrão, valores máx e min)

renda_ano <- renda %>% 
  group_by(ano) %>% 
  summarise(desvio_bens = sd(bens_milhoes),
            min_bens = min(bens_milhoes),
            max_bens = max(bens_milhoes),
            desvio_rendimentos = sd(rendimentos_isentos_milhoes),
            min_rendimentos = min(rendimentos_isentos_milhoes),
            max_rendimentos = max(rendimentos_isentos_milhoes))

View(renda_ano)

#3: Comparando grupos

renda_grupos <- slice(renda_centil, c(1:50, 100)) %>% 
  mutate(condicao = ifelse(centil < 100, "Pobre", "Rico")) %>% 
  group_by(condicao) %>% 
  summarise(media_renda = mean(total_renda))
  
View(renda_grupos)

#4: Tabelas formatadas

renda_corte <- renda %>% 
  filter(ano >= 2015 & ano <= 2020,
         centil == 100) %>% 
  select(ano, bens_milhoes, rendimentos_isentos_milhoes)

tabela <- gt(renda_corte) %>% 
  cols_label(
    ano = "Ano",
    bens_milhoes = "Bens (Milhões)",
    rendimentos_isentos_milhoes = "Rendimentos Isentos (Milhões)"
  ) %>%
  tab_header(title = md("**Renda Ricos**"),
             subtitle = md("*2015 a 2020*")) %>% #md inclui o uso de markdowns 
  tab_source_note("Fonte: Receita Federal, Brasil")
  
tabela

#5: Tabelas de estatísticas descritivas

tabela2 <- modelsummary::datasummary(rendimentos_tributaveis_milhoes + bens_milhoes + rendimentos_isentos_milhoes 
                                     ~ Mean + Median + sd + Min + Max, 
                                     data = renda, output = "tabela2.html")
tabela2

#6: Modelo de regressão linear simples

options(scipen = 999)
modelo <- lm(rendimentos_tributaveis_milhoes ~ rendimentos_isentos_milhoes, data = renda)

#7: Exportando resultados do modelo

summary(modelo)

nomes <- c("(Intercept)" = "Intercepto",
           "rendimentos_isentos_milhoes" = "Rendimentos Isentos (Milhões)",
           "Num.Obs." = "Observações")

modelsummary(modelo, coef_map = nomes, gof_map = c("nobs", "r.squared"), output = "tabela_modelo.html")
