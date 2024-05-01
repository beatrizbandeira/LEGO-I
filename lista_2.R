# Lista 2 - LEGO I

# Pacotes usados -------------------------------------------------------------

library(tidyverse)
library(stringr)
library(dplyr)
library(readr)
library(ggplot2)
library(geobr)
library(gt)
library(sf)

# 1) Importação e manipulação dos dados --------------------------------------------------------------------------

# Manual
setwd("C:/Users/beatr/OneDrive/Documentos/2023-2024/Mestrado e Doutorado/Doutorado - Disciplinas/2024.1/LEGO I/Lista 2/lista2/csvs")

lista_1 <- read_delim("capes_1987-1992.csv", delim = ",", locale = locale(encoding = "UTF-8"))
lista_2 <- read_delim("capes_1993-1998.csv", delim = ",", locale = locale(encoding = "UTF-8"))
lista_3 <- read_delim("capes_1999-2004.csv", delim = ",", locale = locale(encoding = "UTF-8"))
lista_4 <- read_delim("capes_2005-2010.csv", delim = ",", locale = locale(encoding = "UTF-8"))
lista_5 <- read_delim("capes_2011-2016.csv", delim = ",", locale = locale(encoding = "UTF-8"))
lista_6 <- read_delim("capes_2017-2022.csv", delim = ",", locale = locale(encoding = "UTF-8"))

dados_geral <- bind_rows(lista_1, lista_2, lista_3, lista_4, lista_5, lista_6) 
#Emplilha data frames com o mesmo número de colunas

View(dados_geral)

ano <- read_delim("C:/Users/beatr/OneDrive/Documentos/2023-2024/Mestrado e Doutorado/Doutorado - Disciplinas/2024.1/LEGO I/Lista 2/lista2/programas.csv", 
                  delim = ",", 
                  locale = locale(encoding = "UTF-8"))

ano <- ano %>% #Primeiro o nome que eu quero usar, depois a variável que já existe
  rename(codigo_programa = CD_PROGRAMA)

dados <- left_join(dados_geral, ano, by = "codigo_programa") #Base com todas as informações geral + ano

dados_cp <- dados %>%
  rename(uf = UF,
         conceito = CONCEITO) %>%
  mutate(uf = if_else(is.na(uf), "Ausente", uf),
         conceito = as.character(conceito),
         conceito = case_when(
           conceito == "A" ~ "5",
           is.na(conceito) ~ "0", #Obs: mantive os casos NA como 0
            TRUE ~ conceito),
         conceito = as.numeric(conceito),
         palavras_chave = if_else(is.na(palavras_chave), "Ausente", palavras_chave),
         nivel = case_when(
           nivel == "DOUTORADO" ~ "Doutorado",
           nivel == "MESTRADO" ~ "Mestrado",
           nivel == "MESTRADO PROFISSIONAL" ~ "Mestrado", #Presumi que todos os trabalhos de ME são dissertações
            TRUE ~ nivel)) %>%
  filter(area_avaliacao == "CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS" &
          conceito %in% c(4, 5, 6, 7)) %>% #Eliminei todos os NA(0)
  select(ano, codigo_programa, sigla_ies, nome_ies, uf, nome_programa, conceito, everything()) %>%
  mutate(across(c(titulo, palavras_chave, resumo), tolower))
  
# 2) Seleção de palavras-chave -----------------------------------------------------------------------
# Solução do ChatGPT foi criar uma nova coluna com todas as informações (título, palavras-chave e resumo)
# Depois procurar os termos dentro delas

dados_arg <- dados_cp %>% 
  rowwise() %>% #Realiza operações em cada linha do conjunto de dados
  mutate(texto_completo = paste(titulo, palavras_chave, resumo, collapse = " ")) %>% #Reúne título, palavras_chave e resumo em uma única célula
  filter(str_detect(texto_completo, "argentina|peronismo|politica externa"))

setwd("C:/Users/beatr/OneDrive/Documentos/2023-2024/Mestrado e Doutorado/Doutorado - Disciplinas/2024.1/LEGO I/Lista 2")
write_delim(dados_arg, "dados_arg.csv", delim = ";", na = "NA")

# 3) Visualização de dados --------------------------------------------------------------------------

setwd("C:/Users/beatr/OneDrive/Documentos/2023-2024/Mestrado e Doutorado/Doutorado - Disciplinas/2024.1/LEGO I/Lista 2")
dados_arg <- read_delim("dados_arg.csv", delim = ";", locale = locale(encoding = "UTF-8")) #Dados organizados

# 3.1) Evolução ao longo do tempo ----

#Sem facetas

grafico_1 <- ggplot(dados_arg, aes(x = ano)) +
  geom_bar(
    fill = "#9D86F1",
    alpha = 0.8) +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.caption = element_text(hjust = 0)) +
  labs(title = "Teses e Dissertações x Ano",
       subtitle = "Ciência Política e Relações Internacionais",
       x = "Anos",
       y = "Nº trabalhos",
       caption = "Nota. Os trabalhos foram selecionados com base em três palavras-chave: argentina, peronismo e politica externa")

#Com facetas

grafico_2 <- ggplot(dados_arg, aes(x = ano)) +
  geom_bar(
    fill = "#613FDF",
    alpha = 0.8) +
  facet_wrap(~ nivel, ncol = 2) +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.caption = element_text(hjust = 0)) +
  labs(title = "Teses e Dissertações x Ano",
       subtitle = "Ciência Política e Relações Internacionais",
       x = "Anos",
       y = "Nº trabalhos",
       caption = "Nota: os trabalhos foram selecionados com base em três palavras-chave argentina, peronismo e politica externa")

# 4) Diferenças regionais ----
# 4.1) Mapa BR-UF ----

mapa_br <- read_state(year = 2020, simplified = TRUE, showProgress = TRUE)

dados_arg_uf <- dados_arg %>%
  group_by(uf) %>% 
  count() %>% 
  left_join(mapa_br, by = c("uf" = "abbrev_state")) %>% #Dica do Carlos
  rename(total_trabalhos = n)

mapa_arg_uf <- ggplot() +
  geom_sf(data = mapa_br, fill = "white", color = "black") +  # Geometria do mapa
  geom_sf(data = dados_arg_uf, aes(geometry = geom, fill = total_trabalhos)) +  # Dados dos trabalhos
  labs(title = "Trabalhos x UF",
       fill = "Total Trabalhos") +
  scale_fill_gradient(low = "#56B1F7", high =  "#132B43") +
  theme_bw()

# 4.2) Tabela BR-Região ----

tabela_arg_reg <- dados_arg_uf %>%
  group_by(name_region) %>% 
  summarise(total = sum(total_trabalhos)) %>%
  arrange(desc(total)) %>% 
  gt() %>%
  cols_label(
    name_region = "Região",
    total = "Trabalhos") %>% 
  tab_header(
    title = md("**Trabalhos x Região**"),
    subtitle = "Ciência Política e Relações Internacionais") %>% 
  tab_source_note(md("**Fonte**: elaboração da autora (2024)"))
  
# 5) Produção por programa ---------------------------------------------------

dados_arg_pr <- dados_arg %>%
      mutate(nome_programa = as.character(nome_programa),
      nome_programa = recode(nome_programa,
                                  "CIENCIA POLITICA" = "CIÊNCIA POLÍTICA",
                                  "CIÊNCIA  POLÍTICA" = "CIÊNCIA POLÍTICA",
                                  "RELACOES INTERNACIONAIS" = "RELAÇÕES INTERNACIONAIS",
                                  "Relações Internacionais" = "RELAÇÕES INTERNACIONAIS",
                                  "RELAÇÕES INTERNACIONAIS (UNESP/UNICAMP/PUC-SP)" = "RELAÇÕES INTERNACIONAIS",
                                  "RELAÇÕES INTERNACIONAIS (UNESP - UNICAMP - PUC-SP)" = "RELAÇÕES INTERNACIONAIS",
                                  "Estudos Estratégicos Internacionais" = "ESTUDOS ESTRATÉGICOS INTERNACIONAIS",
                                  "RELAÇÕES INTERNACIONAIS: POLÍTICA INTERNACIONAL" = "RELAÇÕES INTERNACIONAIS:POLÍTICA INTERNACIONAL",
                                  "INTEGRAÇÃO CONTEMPORÂNEA DA AMÉRICA LATINA - ICAL" = "INTEGRAÇÃO CONTEMPORÂNEA DA AMÉRICA LATINA",
                                  .default = as.character(nome_programa)))

producao_programas <- dados_arg_pr %>%
 mutate(programa_ies = paste(sigla_ies, nome_programa, sep = " - "),
        tipo_trabalho = case_when(nivel == "Mestrado" ~ "Dissertação",
                                  nivel == "Doutorado" ~ "Tese")) %>% 
  count(programa_ies, conceito, tipo_trabalho) %>%
  pivot_wider(names_from = tipo_trabalho,
              values_from = n, values_fill = 0) %>% #Solução do ChatGPT
  rename("Programa" = programa_ies,
         "Conceito" = conceito,
         "Dissertações" = Dissertação,
         "Teses" = Tese) %>%
  arrange(desc(Teses)) %>% 
  slice(1:10) %>% 
  gt() %>%
  tab_header(
    title = md("**Produção por programa**"),
    subtitle = "Ciência Política e Relações Internacionais") %>% 
  tab_source_note(md("**Fonte**: elaboração da autora (2024)"))

# 6) Exportação ---------------------------------------------------------------

dados_final <- dados_arg %>% 
  select(ano, sigla_ies, uf, nome_programa, autor, titulo, resumo)

setwd("C:/Users/beatr/OneDrive/Documentos/2023-2024/Mestrado e Doutorado/Doutorado - Disciplinas/2024.1/LEGO I/Lista 2")
write_delim(dados_final, "dados_final.csv", delim = ";", na = "NA")
  
        
        
        
# Rascunhos -------------------------------------------------------------------        

dados_arg_pr %>%
  mutate(num = if_else(nivel == "Mestrado", 1, if_else(nivel == "Doutorado", 2, 0))) %>% 
  select(programa_ies, conceito, nivel, num) %>%
  group_by(programa_ies, conceito) %>%
  summarise(dissertacoes = sum(num == 1),
            teses = sum(num == 2),
            .groups = "drop") %>% 
  arrange(desc(teses)) %>%
  gt() %>%
  cols_label(
    programa_ies = "Programa",
    conceito = "Avaliação",
    dissertacoes = "Dissertações",
    teses = "Teses") %>% 
  tab_header(
    title = md("**Produção por programa**"),
    subtitle = "Ciência Política e Relações Internacionais") %>% 
  tab_source_note(md("**Fonte**: elaboração da autora (2024)"))

