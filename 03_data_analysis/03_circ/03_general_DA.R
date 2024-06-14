
#' ---
#' title: "data-analysis of circRNA detection in MDA-MB-231 cells and EVs, and TNBC pt tissues and EVs"
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
conflicts_prefer(dplyr::count)

# set theme
mytheme = theme_bw(base_size = 9) + 
  theme(text = element_text(size=9, colour='black'),
        title = element_text(size=9, colour='black'),
        line = element_line(linewidth =0.5),
        axis.title = element_text(size=9, colour='black'),
        axis.text = element_text(size=9, colour='black'),
        axis.line = element_line(colour = "black"),
        axis.ticks = element_line(linewidth=0.5),
        strip.background = element_blank(),
        strip.text.y = element_blank(),
        panel.grid = element_blank(),
        panel.border = element_blank(),
        legend.text=element_text(size=9)) 

mytheme_discrete_x = mytheme + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

# read data

circ = read_tsv('data/20240325_all_circ.txt')

# add annotation info

circ = circ %>%
  left_join(read_tsv('02_exon_anno/annotated_circ.tsv') %>%
              rename(transcript_name = ENST))

circ$tool = factor(circ$tool, levels = c('circrna_finder', 'find_circ',  'circexplorer2', 'ciriquant'))
circ$sample_origin = factor(circ$sample_origin, levels = c('cell_line', 'patient'))
circ$sample_type = factor(circ$sample_type, levels = c('tissue/cells', 'EV'))

#' number of detected circ per sample per tool

circ %>%
  #filter(BSJ_count >= 5) %>%
  ggplot(aes(ID_NGS, fill = tool)) +
  geom_bar(position = 'dodge') +
  ylab('number of detected circRNAs') + xlab('') +
  scale_y_continuous(labels = scales::comma_format()) +
  facet_grid(cols = vars(interaction(sample_type, sample_origin)), rows = vars(tool), scales = 'free_x', space = 'free') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

#' for FdF grant

circ %>%
  filter(!tool == 'circrna_finder',
         !sample_origin == "MDA-MB-231") %>%
  mutate(ID_SCAND = substr(ID_SCAND, 4,6)) %>%
  ggplot(aes(ID_SCAND, fill = tool)) +
  geom_bar(position = 'dodge') +
  ylab('number of detected circRNAs') + xlab('patient ID') +
  scale_y_continuous(labels = scales::comma_format()) +
  facet_grid(rows = vars(sample_type), cols = vars(tool), scales = 'free_y') +
  mytheme_discrete_x +
  theme(axis.text.x = element_text(size=7, colour='black',angle = 90, hjust = 1, vjust = 0.5),
        legend.position = "none")

#' for presentation unit seminar
circ %>%
  filter(!sample_origin == "cell_line",
         #BSJ_count >= 5
         ) %>%
  mutate(ID_SCAND = substr(ID_SCAND, 4,6)) %>%
  ggplot(aes(ID_SCAND, fill = tool)) +
  geom_bar(position = 'dodge') +
  ylab('number of detected circRNAs') + xlab('patient ID') +
  scale_y_continuous(labels = scales::comma_format()) +
  facet_grid(cols = vars(sample_type), rows = vars(tool)) +
  mytheme_discrete_x +
  theme(axis.text.x = element_text(size=7, colour='black',angle = 45, hjust = 1, vjust = 1))


# BSJ count distribution
circ %>%
  ggplot(aes(sample_type, BSJ_count, fill = tool)) +
  geom_boxplot() +
  scale_y_log10() +
  xlab('') + ylab('BSJ count distribution') +
  facet_grid(~sample_origin, space = "free", scales = 'free_x') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

#' for unit seminar
circ %>%
  filter(!sample_origin == "cell_line") %>%
  ggplot(aes(sample_type, BSJ_count, fill = tool)) +
  geom_boxplot() +
  scale_y_log10() +
  xlab('') + ylab('BSJ count distribution') +
  facet_grid(~sample_origin, space = "free", scales = 'free_x') +
  mytheme_discrete_x #+
  #geom_hline(yintercept = 5, color = 'red')

#' circ type

circ %>%
  ggplot(aes(tool, fill = circ_type)) +
  geom_bar(position = 'fill') + 
  facet_wrap(~sample_origin+sample_type, nrow = 1) +
  scale_y_continuous(labels = scales::percent_format()) +
  xlab('') + ylab('') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

#' for unit seminar
circ %>%
  filter(!sample_origin == "cell_line") %>%
  ggplot(aes(sample_type, fill = circ_type)) +
  geom_bar(position = 'fill') + 
  scale_y_continuous(labels = scales::percent_format()) +
  xlab('') + ylab('') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

#' Euler plots

circ_list = list()

circ_list["EVs_find_circ"] = circ %>% filter(sample_type == "EVs", tool == "find_circ", BSJ_count >= 5) %>% pull(circ_id) %>% list()
circ_list["EVs_circexplorer2"] = circ %>% filter(sample_type == "EVs", tool == "circexplorer2", BSJ_count >= 5) %>% pull(circ_id) %>% list()
circ_list["EVs_circrna_finder"] = circ %>% filter(sample_type == "EVs", tool == "circrna_finder", BSJ_count >= 5) %>% pull(circ_id) %>% list()

circ_list["cells_find_circ"] = circ %>% filter(sample_type == "cells", tool == "find_circ", BSJ_count >= 5) %>% pull(circ_id) %>% list()
circ_list["cells_circexplorer2"] = circ %>% filter(sample_type == "cells", tool == "circexplorer2", BSJ_count >= 5) %>% pull(circ_id) %>% list()
circ_list["cells_circrna_finder"] = circ %>% filter(sample_type == "cells", tool == "circrna_finder", BSJ_count >= 5) %>% pull(circ_id) %>% list()

to_select = names(circ_list)[c(3,6)]
circ_list_simpel = circ_list[to_select] 

library('eulerr')

circ_euler = euler(circ_list_simpel)

plot(circ_euler,
     quantities = TRUE)

#' Correlation

#' ## Correlation of the counts
library("ggpubr")

circ_cor = circ %>%
  filter(sample_type == 'cells') %>%
  select(circ_id, BSJ_count, tool) %>%
  rename(BSJ_count_cells = BSJ_count) %>%
  full_join(circ %>%
              filter(sample_type == 'EVs') %>%
              select(circ_id, BSJ_count, tool) %>%
              rename(BSJ_count_EVs = BSJ_count))

circ_cor

circ_cor %>%
  filter(BSJ_count_cells > 0, BSJ_count_EVs > 0) %>%
  ggplot(aes(BSJ_count_cells, BSJ_count_EVs)) +
  geom_point(alpha = 0.3) +
  scale_x_log10(labels = scales::comma_format()) +
  scale_y_log10(labels = scales::comma_format()) +
  #geom_abline(slope = 1, intercept = 0, color = '#D46363') +
  facet_wrap(~tool) +
  coord_fixed() +
  geom_smooth(method = "lm", color = '#00B9F2') +
  stat_regline_equation(label.y = 6.5, label.x = 0.001) +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "*`,`~")),
           label.y= 6, label.x = 0.001, method = 'spearman')

#' spec circ
set.seed(50)

circ %>%
  filter(circ_id == 'chr14:61720381-61727655:+') %>%
  ggplot(aes(ID_NGS, BSJ_count, color = tool)) +
  #geom_point() +
  geom_jitter(width = 0.1, height = 0, alpha = 0.7) +
  facet_grid(rows = vars(sample_type), cols = vars(sample_origin), scales = 'free_x', space = 'free') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

circ %>%
  filter(circ_id == 'chr14:61720381-61727655:+') %>%
  ggplot(aes(ID_NGS, BSJ_count, color = tool)) +
  geom_boxplot() +
  facet_grid(rows = vars(sample_type), cols = vars(sample_origin), scales = 'free_x', space = 'free') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

circ %>%
  filter(circ_id == 'chrX:107840669-107854704:+') %>%
  mutate(sample_origin = ifelse(is.na(chemo_status),
                                sample_origin,
                                paste(sample_origin, chemo_status, sep = "_")),
         ID_SCAND = ifelse(is.na(ID_SCAND), 'cell_line', ID_SCAND)) %>%
  ggplot(aes(ID_SCAND, BSJ_count, color = tool)) +
  #geom_point() +
  geom_jitter(width = 0.1, height = 0, alpha = 0.7) +
  facet_grid(rows = vars(sample_type), cols = vars(sample_origin), scales = 'free_x', space = 'free') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

circ %>%
  filter(circ_id == 'chr14:61720381-61727655:+') %>%
  mutate(sample_origin = ifelse(is.na(chemo_status),
                                sample_origin,
                                paste(sample_origin, chemo_status, sep = "_")),
         ID_SCAND = ifelse(is.na(ID_SCAND), 'cell_line', ID_SCAND)) %>%
  ggplot(aes(ID_SCAND, BSJ_count, color = tool)) +
  #geom_point() +
  geom_jitter(width = 0.1, height = 0, alpha = 0.7) +
  facet_grid(rows = vars(sample_type), cols = vars(sample_origin), scales = 'free_x', space = 'free') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

circ %>%
  filter(circ_id == 'chrX:107840669-107854704:+') %>%
  filter(sample_type == "tissue/cells") %>%
  select(ID_NGS, chemo_status) %>% unique() %>% 
  count(chemo_status)


# Reno circ

circ %>%
  filter(chr == 'chr15',
         start == 58620365,
         end == 58624800)

#' # nr of exons

circ = circ %>%
  mutate(exon_cat = ifelse(is.na(nr_exons), 'NA', 'undetermined'),
         exon_cat = ifelse(transcript_name == 'ambiguous', 'ambiguous', exon_cat),
         exon_cat = ifelse(nr_exons == 1, 'single_exon', exon_cat),
         exon_cat = ifelse(nr_exons > 1 & nr_exons < 6, '2-5 exons', exon_cat),
         exon_cat = ifelse(nr_exons > 5 & nr_exons < 10, '6-9 exons', exon_cat),
         exon_cat = ifelse(nr_exons > 9, '≥ 10 exons', exon_cat))

circ$exon_cat = factor(circ$exon_cat, levels = c('≥ 10 exons', '6-9 exons', '2-5 exons','single_exon', 'ambiguous', 'NA'))

circ %>% count(transcript_name) %>% arrange(desc(n))

circ %>% 
  ggplot(aes(sample_type)) +
  geom_bar(aes(fill = exon_cat), position = 'fill') +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_manual(name = "circRNAs with ...",
                    values = c("#0072B2", '#00B9F2', '#00A875', "#E69F00", '#CC79A7', '#99999')) +
  facet_wrap(~sample_origin)

circ %>% 
  ggplot(aes(tool)) +
  geom_bar(aes(fill = exon_cat), position = 'fill') +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_manual(name = "circRNAs with ...",
                    values = c("#0072B2", '#00B9F2', '#00A875', "#E69F00", '#CC79A7', '#99999')) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

