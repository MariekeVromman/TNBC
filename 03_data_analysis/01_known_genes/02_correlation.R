
#' ---
#' title: "correlation between circ and rna counts"
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
library("DESeq2")
library(ggrepel)
library(ggpubr)

conflict_prefer("filter", "dplyr")
conflict_prefer("select", "dplyr")
conflict_prefer("slice", "dplyr")
conflict_prefer("rename", "dplyr")
conflict_prefer('intersect', 'dplyr')
conflicts_prefer(dplyr::count)

#' ## Set figure theme
mytheme = theme_bw(base_size = 10) + 
  theme(text = element_text(size=10, colour='black'),
        title = element_text(size=10, colour='black'),
        line = element_line(linewidth=0.5),
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


#' ## Read data

normalized_counts = read_tsv('../data/20240502_normalized_filtered_counts.txt')

normalized_counts$gene_type_cat = factor(normalized_counts$gene_type_cat,
                                         levels = c("protein_coding", 'lncRNA', 
                                                    'circRNA', 'other'))

normalized_counts = normalized_counts %>%
  filter(sample_origin == 'patient')

#' # Data-analysis


#' RNA types

normalized_counts %>%
  filter(sample_origin == 'patient') %>%
  ggplot(aes(gene_type_cat, norm_count, fill = sample_type)) +
  geom_boxplot() +
  scale_y_log10(labels = scales::comma_format()) +
  mytheme_discrete_x +
  xlab('') +
  ylab('normalized filtered count') +
  theme(legend.title=element_blank(),
        strip.text = element_text(size=12))

#' get numbers
normalized_counts %>%
  filter(sample_origin == 'patient') %>%
  group_by(gene_type_cat, sample_type) %>%
  summarise(norm_count_med = median(norm_count)) 

#' correlation plot

corr = normalized_counts %>%
  filter(sample_origin == 'patient') %>%
  select(ENSG, norm_count, ID_SCAND, sample_type, gene_type, gene_type_cat) %>%
  pivot_wider(names_from = sample_type, values_from = norm_count) %>%
  filter(!is.na(EV),
         !is.na(tumor))

corr

corr %>%
  filter(ID_SCAND == '02-110') %>%
  ggplot(aes(tumor, EV, color = gene_type_cat)) +
  geom_point(alpha = 0.3) +
  geom_abline(color = "lightgrey") +
  scale_x_log10(labels = scales::comma_format(), limits = c(0.3,1000000000),
                breaks = c(1,100,10000,1000000)) +
  scale_y_log10(labels = scales::comma_format(), limits = c(0.3,1000000000),
                breaks = c(1,100,10000,1000000)) +
  facet_wrap(~gene_type_cat, nrow = 1) +
  coord_fixed() +
  geom_smooth(method = "lm", color = 'black') +
  stat_regline_equation(label.y = 9, label.x = 0.001) +
  stat_cor(aes(label = ..rr.label..),
           label.y= 8, label.x = 0.001, method = 'spearman') +
  stat_cor(aes(label = ..p.label..),
           label.y= 6.7, label.x = 0.001, method = 'spearman') +
  xlab('normalised count in tumor sample') +
  ylab('normalised count in EV plasma sample') +
  mytheme_discrete_x +
  theme(legend.position = 'none',
        strip.text = element_text(size=12))

#' get all stats

corr_stat = tibble()

for (sample_x in corr %>% pull(ID_SCAND) %>% unique()) {
  
  for (gene_type_x in corr %>% pull(gene_type_cat) %>% unique()){
    
    fc_tmp_sub = corr %>% filter(ID_SCAND == sample_x) %>%
      filter(EV > 0, tumor > 0) %>%
      filter(gene_type_cat == gene_type_x)
    
    cor_test_tmp = cor.test(fc_tmp_sub$EV, fc_tmp_sub$tumor, method = 'spearman')
    
    corr_stat = corr_stat %>%
      bind_rows(tibble(ID_SCAND = sample_x,
                       rho = cor_test_tmp$estimate,
                       gene_type_cat = gene_type_x))
  }
}

corr_stat 

corr_stat = corr_stat %>%
  mutate(R_2 = rho^2)


corr_stat

corr_stat$gene_type_cat = factor(corr_stat$gene_type_cat, levels = c('protein_coding', 'lncRNA', 'circRNA', 'other'))

corr_stat %>%
  left_join(read_tsv('../../00_sample_annotation/SCAND_anno.txt') %>%
              select(ID_SCAND, chemo_status) %>% unique()) %>%
  ggplot(aes(ID_SCAND, R_2, fill = gene_type_cat)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  facet_wrap(~gene_type_cat, nrow = 4) +
  mytheme_discrete_x +
  theme(legend.position = 'none',
        strip.text = element_text(size=12)) +
  xlab('patient ID') +
  ylab('R-squared')

corr_stat %>% arrange(desc(R_2))


#' ## Concordance analysis

conc = normalized_counts %>%
  filter(sample_type == 'EV',
         sample_origin == 'patient') %>%
  select(ENSG, norm_count, ID_SCAND, gene_type_cat) %>%
  rename(norm_count_EV = norm_count) %>%
  full_join(normalized_counts %>%
              filter(!sample_type == 'EV',
                     sample_origin == 'patient') %>%
              select(ENSG, norm_count, ID_SCAND, gene_type_cat) %>%
              rename(norm_count_tissue = norm_count)) %>%
  mutate(norm_count_EV = ifelse(is.na(norm_count_EV), 0, norm_count_EV),
         norm_count_tissue = ifelse(is.na(norm_count_tissue), 0, norm_count_tissue))

conc

conc_stat =
  conc %>% 
  #filter(norm_count_EV >= 10 | norm_count_tissue >= 10 | norm_count_EV == 0 & norm_count_tissue == 0) %>%
  mutate(conc_label = ifelse(norm_count_EV == 0 & norm_count_tissue == 0, 'yes', 'unknown'),
         conc_label = ifelse(norm_count_EV > 0 & norm_count_tissue > 0, 'yes', conc_label),
         conc_label = ifelse(norm_count_EV > 0 & norm_count_tissue == 0, 'unique_EV', conc_label),
         conc_label = ifelse(norm_count_EV == 0 & norm_count_tissue > 0, 'unique_tissue', conc_label)) %>%
  group_by(ID_SCAND, gene_type_cat) %>%
  summarise(concordant = sum(conc_label == 'yes')/n(),
            unique_EV = sum(conc_label == 'unique_EV') / n(),
            unique_tissue = sum(conc_label == 'unique_tissue') / n()) %>%
  pivot_longer(cols = c(concordant, unique_EV, unique_tissue),
               values_to = 'perc', names_to = 'type')

conc_stat

conc_stat$type = factor(conc_stat$type, levels = c('unique_tissue', 'concordant', 'unique_EV'))

conc_stat = conc_stat %>%
  mutate(xpos = ifelse(type == "unique_EV", 0.02, 0.35),
         xpos = ifelse(type == "unique_tissue", 0.85, xpos))

conc_stat %>%
  ggplot(aes(perc, ID_SCAND, fill = type)) +
  geom_bar(stat = 'identity') +
  scale_x_continuous(labels = scales::percent_format()) +
  #geom_text(stat='identity',
  #         data = conc_stat,
            #position_stack(vjust = 0.5),
  #          aes(x = xpos, label = paste(sprintf("%0.0f", round((100*perc), digits = 1)), '%', sep = ''))) +
  scale_fill_manual(values = c('orange', 'grey', 'seagreen2')) +
  facet_grid(~gene_type_cat) +
  mytheme_discrete_x +
  theme(strip.text = element_text(size=12),
        legend.title = element_blank())

conc_stat %>%
  filter(type == 'concordant') %>%
  group_by(gene_type_cat) %>%
  summarize(quant25 = quantile(perc, probs = .25)*100, 
            quant50 = quantile(perc, probs = .5)*100,
            quant75 = quantile(perc, probs = .75)*100)
conc_stat %>%
  group_by(gene_type_cat, type) %>%
  summarize(med = median(perc))

