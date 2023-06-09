# charger les dépendances ------------------------------------------------------
if(!existsFunction('read_excel')) library('readxl')
if(!existsFunction('%>%')) library('tidyverse')

# clé --------------------------------------------------------------------------
# il avait quatre hauteurs différentes dans les traitements :
#     24" au dessus  du latéral  = _h2        # Contrôle A, C et E 
#      4" au dessus  du latéral  = _h1        # Traitement C et E1 
#      4" en dessous du latéral  = _b1        # Contrôle B et Traitement E2
#     24" en dessous du latéral  = _b2        # Traitement A, B, E3


# lire les données des systèmes ------------------------------------------------
systeme <- c('A','A','B','B','C','C','E','E','E','E')
traitement <- c('C','T','C','T','C','T','C','T','T','T')

# initialiser les noms des fichiers --------------------------------------------
file_name_SN <- '../données/Compilation donnée érablière - 2023.xlsm'
file_name_CE <- '../données/Projet_chalumeau_2022 2 (1).xlsx'

# extraire les metadonnées -----------------------------------------------------
info <- readxl::read_excel(path = file_name_SN,
                           sheet = 'Paramètres', range = 'B19:K19',
                           col_types = c(rep('numeric', 10)),
                           col_names = FALSE) %>% 
  pivot_longer(cols = 1:10, values_to = 'n_arbres') %>%
  add_column(systeme, traitement, .before = 1) %>% 
  select(-name) %>% 
  add_column(h = c('h2', 'b2', 'b1', 'b2', 'h2', 'h1', 'h2', 'h1', 'b1', 'b2'),
             colour = c('#008837','#7b3294','#c2a5cf','#7b3294','#008837',
                        '#a6dba0','#008837','#a6dba0','#c2a5cf','#7b3294'),
             sym = c(21, 21, 22, 22, 23, 23, 24, 24, 24, 24))

# initialise column names and column types -------------------------------------
col_names_SN <- c(
  'date','time', 'compteur_1', 'coulee_m3_1', 'coulee_l_1', 'coulee_cum_1',
  'rendement_1', 'compteur_2', 'coulee_m3_2', 'coulee_l_2', 'coulee_cum_2',
  'rendement_2', 'compteur_3', 'lecture', 'coulee_m3_3', 'coulee_l_3',
  'coulee_cum_3', 'rendement_3', 'brix', 'commentaires', 'diff_compteur',
  'diff_compteur_1', 'debit', 'debit_cum', 'rendement', 'rendement_cum')
col_types_SN <- c('date', 'text', rep('numeric', 17), 'text', rep('numeric', 6))

# lire les données du système A contrôle (24" au dessus) -----------------------
A_h2 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(1)', skip = 4, na = '-',
                           col_types = col_types_SN, 
                           col_names = col_names_SN) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'h2', systeme = 'A', h = 60.96)

# lire les données du système A traitement (24" en dessous) --------------------
A_b2 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(2)', skip = 4, na = '-',
                           col_types = col_types_SN,
                           col_names = col_names_SN) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'b2', systeme = 'A', h = -60.96)

# lire les données du système B contrôle (4" en dessous) -----------------------
B_b1 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(3)', skip = 4, na = '-',
                           col_types = col_types_SN,
                           col_names = col_names_SN) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'b1', systeme = 'B', h = -10.16)

# lire les données du système B traitement (24" en dessous) --------------------
B_b2 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(4)', skip = 4, na = '-',
                           col_types = col_types_SN,
                           col_names = col_names_SN) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'b2', systeme = 'B', h = -60.96)

# lire les données du système C contrôle (24" au dessus) -----------------------
C_h2 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(5)', skip = 4, na = '-',
                           col_types = col_types_SN,
                           col_names = col_names_SN) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'h2', systeme = 'C', h = 60.96)

# lire les données du système C traitement (4" au dessus) ----------------------
C_h1 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(6)', skip = 4, na = '-',
                           col_types = col_types_SN,
                           col_names = col_names_SN) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'h1', systeme = 'C', h = 10.16)

# lire les données du système E contrôle (24" au dessus) -----------------------
E_h2 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(7)', skip = 4, na = '-',
                           col_types = col_types_SN[-c(13:18, 22)],
                           col_names = col_names_SN[-c(13:18, 22)]) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'h2', systeme = 'E', h = 60.96)

# lire les données du système E traitement 1 (4" au dessus) --------------------
E_h1 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(8)', skip = 4, na = '-',
                           col_types = col_types_SN[-c(13:18, 22)],
                           col_names = col_names_SN[-c(13:18, 22)]) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'h1', systeme = 'E', h = 10.16)

# lire les données du système E traitement 2 (4" en dessous) -------------------
E_b1 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(9)', skip = 4, na = '-',
                           col_types = col_types_SN[-c(13:18, 22)],
                           col_names = col_names_SN[-c(13:18, 22)]) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'b1', systeme = 'E', h = -10.16)

# lire les données du système E traitement 3 (24" en dessous) ------------------
E_b2 <- readxl::read_excel(path = file_name_SN,
                           sheet = '(10)', skip = 4, na = '-',
                           col_types = col_types_SN[-c(13:18, 22)],
                           col_names = col_names_SN[-c(13:18, 22)]) %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(date, datetime, debit, debit_cum, rendement, rendement_cum, brix) %>%
  add_column(t = 'b2', systeme = 'E', h = -60.96)

# combiner tous les données pertinentes ----------------------------------------
d <- rbind(A_h2, A_b2, B_b1, B_b2, C_h2, C_h1, E_h2, E_h1, E_b1, E_b2) %>% 
  select(systeme, t, h, date, datetime, rendement, brix) %>% 
  filter(rendement > 0)

# supprime les lignes sans date, car elles sont les moyennes -------------------
d <- d %>% filter(!is.na(date)) 

# ajouter le site et convertir les caractères en facteurs ----------------------
d <- d %>% mutate(t = factor(t, levels = c('h2', 'h1', 'b1', 'b2')),
                  systeme = factor(systeme, levels = c('A', 'B', 'C', 'E'))) %>% 
  add_column(site = 'SN',
             yr = factor('2023')) %>% 
  relocate(yr, site, systeme, t, h, date, datetime, rendement, brix)

# initialiser les noms des colonnes --------------------------------------------
col_names_CE <- c('date', 'comp1', 'r1', 'r2', 'var1', 'comp2', 'r3', 'r4', 
                  'var2', 'compteur1', 'volume1', 'rendement1', 'variation1',
                  'compteur2', 'volume2', 'rendement2', 'variation2', 
                  'compteur3', 'volume3', 'rendement3', 'variation3',
                  'compteur4', 'volume4', 'rendement4', 'variation4')

# lire les données du CE (au-dessus de latéral) --------------------------------
CE_h3 <- readxl::read_excel(path = file_name_CE,
                            sheet = 'Prise de données', range = 'B14:Z52',
                            col_types = c('date', rep('numeric', 24)),
                            col_names = col_names_CE) %>% 
  select(-c(comp1, r1, r2, var1, comp2, r3, r4, var2, compteur1, volume1, 
            compteur2, variation1, volume2, variation2, compteur3, volume3, 
            rendement3, variation3, compteur4, volume4, rendement4, 
            variation4)) %>% 
  filter(!is.na(rendement1) | !is.na(rendement2)) %>% 
  mutate(datetime = date,
         date = as_date(date),
         t = factor('h3'),
         h = NA, # TR - Dois le remplir eventuellement
         yr = factor('2022'),
         systeme = factor('F'),
         site = factor('CE'),
         rendement = rowMeans(select(., rendement1, rendement2))) %>%
  select(-c(rendement1, rendement2)) %>% add_column(brix = NA) %>% 
  relocate(yr, site, systeme, t, h, date, datetime, rendement, brix)

# lire les données du CE (en-dessous de latéral) -------------------------------
CE_b3 <- readxl::read_excel(path = file_name_CE,
                            sheet = 'Prise de données', range = 'B14:Z52',
                            col_types = c('date', rep('numeric', 24)),
                            col_names = col_names_CE) %>% 
  select(-c(comp1, r1, r2, var1, comp2, r3, r4, var2, compteur1, volume1, 
            rendement1, variation1, compteur2, volume2, rendement2, variation2,
            compteur3, volume3, variation3, compteur4, volume4, variation4)) %>% 
  filter(!is.na(rendement3) | !is.na(rendement4)) %>% 
  mutate(datetime = date, 
         date = as_date(date),
         t = factor('b3'),
         h = NA, # TR - Dois le remplir eventuellement
         yr = factor('2022'),
         systeme = factor('F'),
         site = factor('CE'),
         rendement = rowMeans(select(., rendement3, rendement4))) %>%
  select(-c(rendement3, rendement4)) %>% add_column(brix = NA) %>% 
  relocate(yr, site, systeme, t, h, date, datetime, rendement, brix)

# combiner les données de St-Norbert (SN) et du Club d'encadrement téchnique en 
# acériculture de l'est (CE) ---------------------------------------------------
d <- rbind(d, CE_b3, CE_h3)

# re-définir les noms des colonnes ---------------------------------------------
col_names_SN <- c('date', 'time', 'responsable', 'periode', 'A_h2', 'C_h2', 
                  'C_h1', 'B_b1', 'A_b2', 'B_b2')

# lire les données pour atp ----------------------------------------------------
brix <- readxl::read_excel(path = '../données/Copie de 4010408_RécolteSN_V2JH.xlsx',
                           sheet = 'CompilationDonnées', range = 'A4:J14',
                           col_types = c('date', 'text', 'text', 'text', rep('numeric', 6)),
                           col_names = col_names_SN) %>% 
  pivot_longer(cols = c('A_h2', 'C_h2', 'C_h1', 'B_b1', 'A_b2', 'B_b2'), 
               names_to = c('systeme', 'h'), names_sep = '_') %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>%
  select(-c(responsable, periode, time, heure, minute))
atp <- readxl::read_excel(path = '../données/Copie de 4010408_RécolteSN_V2JH.xlsx',
                          sheet = 'CompilationDonnées', range = 'A25:J35',
                          col_types = c('date', 'text', 'text', 'text', rep('numeric', 6)),
                          col_names = col_names_SN) %>% 
  pivot_longer(cols = c('A_h2', 'C_h2', 'C_h1', 'B_b1', 'A_b2', 'B_b2'), 
               names_to = c('systeme', 'h'), names_sep = '_') %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>%
  select(-c(responsable, periode, time, heure, minute))
ph <-  readxl::read_excel(path = '../données/Copie de 4010408_RécolteSN_V2JH.xlsx',
                          sheet = 'CompilationDonnées', range = 'A47:J57',
                          col_types = c('date', 'text', 'text', 'text', rep('numeric', 6)),
                          col_names = col_names_SN) %>% 
  pivot_longer(cols = c('A_h2', 'C_h2', 'C_h1', 'B_b1', 'A_b2', 'B_b2'), 
               names_to = c('systeme', 'h'), names_sep = '_') %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>% 
  select(-c(responsable, periode, time, heure, minute))
sc <-  readxl::read_excel(path = '../données/Copie de 4010408_RécolteSN_V2JH.xlsx',
                          sheet = 'CompilationDonnées', range = 'A92:J102',
                          col_types = c('date', 'text', 'text', 'text', rep('numeric', 6)),
                          col_names = col_names_SN) %>% 
  pivot_longer(cols = c('A_h2', 'C_h2', 'C_h1', 'B_b1', 'A_b2', 'B_b2'), 
               names_to = c('systeme', 'h'), names_sep = '_') %>%
  mutate(date = as_date(date),
         heure = as.numeric(substr(time, 1, 2)),
         minute = as.numeric(substr(time, 6, 7)),
         datetime = ymd_hm(str_c(date, heure, minute, sep = " "))) %>%
  select(-c(responsable, periode, time, heure, minute)) 

# unir les données -------------------------------------------------------------
tmp1 <- full_join(brix, atp, by = c('date', 'datetime', 'systeme', 'h')) %>% 
  rename(brix = value.x, atp = value.y) %>%
  relocate(systeme, h, date, datetime, brix, atp)
tmp2 <- full_join(ph, sc, by = c('date', 'datetime', 'systeme', 'h')) %>% 
  rename(ph = value.x, sc = value.y) %>%
  relocate(systeme, h, date, datetime, ph, sc)
d1 <- full_join(tmp1, tmp2, by = c('systeme', 'h', 'date', 'datetime')) %>% 
  mutate(t = factor(h, levels = c('h2', 'h1', 'b1', 'b2')),
         systeme = factor(systeme, levels = c('A', 'B', 'C', 'E'))) %>% 
  mutate(h = case_when(h == 'h2' ~  60.96, 
                       h == 'h1' ~  10.16,
                       h == 'b1' ~ -10.16,
                       h == 'b2' ~ -60.96))

# nettoyer l'espace de travail -------------------------------------------------
rm(A_b2, A_h2, atp, B_b1, B_b2, brix, C_h1, C_h2, col_names_SN, col_types_SN, 
   E_b1, E_b2, E_h1, E_h2, file_name_CE, file_name_SN, ph, sc, systeme, tmp1, 
   tmp2, traitement)
