#' ---
#' title: "SCANDARE cohort"
#' author: "Marieke Vromman"
#' output: 
#'    html_document:
#'       toc: TRUE
#'       toc_float: TRUE
#'       theme: paper
#'       df_print: paged
#'       highlight: tango
#' ---
#' 

#' # File set-up

#' ## Set working directory to current directory
if (rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

#' ## Load standard libraries and resolves conflicts
library(tidyverse)
library(conflicted)
conflict_prefer("filter", "dplyr")
conflict_prefer("select", "dplyr")
conflict_prefer("slice", "dplyr")
conflict_prefer("rename", "dplyr")
conflict_prefer('intersect', 'dplyr')

#' ## Set figure theme
mytheme = theme_bw(base_size = 10) + 
  theme(text = element_text(size=10, colour='black'),
        title = element_text(size=10, colour='black'),
        line = element_line(size=0.5),
        axis.title = element_text(size=10, colour='black'),
        axis.text = element_text(size=10, colour='black'),
        axis.line = element_line(colour = "black"),
        axis.ticks = element_line(size=0.5),
        strip.background = element_blank(),
        strip.text.y = element_blank(),
        panel.grid = element_blank(),
        panel.border = element_blank(),
        legend.text=element_text(size=10)) 

mytheme_discrete_x = mytheme + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

#' read data

# scallop = tibble()
# 
# for (file_n in dir('data/scallop/', pattern = "*.gtf")){
#   scallop = scallop %>%
#     bind_rows(
#       as.data.frame(rtracklayer::import(
#         str_c('data/scallop/', file_n))) %>%
#       mutate(ID_NGS = str_replace(file_n, '.gtf', '')))
# }
# 
# scallop
# 
# annotation = read_tsv('matched_info.txt')
# 
# annotation_long = annotation %>%
#  select(ID_SCAND, chemo_status, tissue_ID_NGS, EV_ID_NGS) %>%
#  pivot_longer(cols = c(tissue_ID_NGS, EV_ID_NGS),
#               names_to = 'sample_type',
#               values_to = 'ID_NGS') %>%
#  mutate(sample_type = str_replace(sample_type, '_ID_NGS', ''))
# 
# annotation_long
# 
# scallop = scallop %>%
#  inner_join(annotation_long)
# 
# scallop %>% count(ID_NGS)
# 
# scallop %>% write_tsv('data/all_scallop.txt')

scallop = read_tsv('data/all_scallop.txt')


scallop = scallop %>%
  filter(type == 'transcript')

scallop %>%
  ggplot(aes(ID_SCAND, fill = chemo_status)) +
  geom_bar() +
  facet_grid(rows = vars(sample_type), scales = 'free_y') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_continuous(labels = scales::comma_format()) +
  ylab('nr of identified transcripts')
  
scallop %>%
  group_by(ID_SCAND, sample_type) %>%
  summarise(nr_transcripts = n()) %>%
  filter(sample_type == 'EV') %>%
  pull(nr_transcripts) %>%
  quantile()

scallop %>%
  mutate(RPKM = as.numeric(RPKM)) %>%
  ggplot() +
  geom_density(aes(RPKM, ..scaled..,
                   color = interaction(chemo_status, sample_type))) +
  scale_x_log10(labels = scales::comma_format(), 
                breaks = c(0, 0.001,0.01, 0.1, 1, 10, 100)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

kallisto %>%
  filter(ID_SCAND == '01-030') %>%
  count(sample_type)

library(eulerr)


kallisto_eulerr = list()

# cpm_eulerr['EV_chemoS'] = cpm %>% 
#   filter(cpm_EV > 0, chemo_status == "chemoS") %>%
#   pull(ENSG) %>% unique() %>% list()
# 
# cpm_eulerr['EV_chemoR'] = cpm %>% 
#   filter(cpm_EV > 0, chemo_status == "chemoR") %>%
#   pull(ENSG) %>% unique() %>% list()

kallisto_eulerr['tissue'] = kallisto %>% 
  filter(ID_SCAND == '01-030', sample_type == "tissue",
         tpm > 0) %>%
  pull(ENSG) %>% unique() %>% list()

kallisto_eulerr['EVs'] = kallisto %>% 
  filter(ID_SCAND == '01-030', sample_type == "EV",
         tpm > 0) %>%
  pull(ENSG) %>% unique() %>% list()

kallisto.eulerr = euler(kallisto_eulerr)

plot(kallisto.eulerr,
     fills = list(alpha = 0.7),
     legend = FALSE,
     labels = list(fontsize = 9, font = 1),
     quantities = TRUE)
