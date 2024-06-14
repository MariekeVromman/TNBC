
#' ---
#' title: "SCANDARE cohort - describe patient cohort"
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

data = read_tsv('SCAND_anno.txt') %>%
  mutate(ID_seqrun = substr(ID_NGS, 1,5))

data

#' # Data description
#' ## Check batch effect
#' how are the samples distributed by chemotherapy over the seq run batches

data %>%
  ggplot(aes(ID_seqrun, fill = chemo_status)) +
  geom_bar() +
  facet_grid(~sample_type, scales = 'free_x', space = 'free') +
  mytheme_discrete_x

#' ## nr of reads per sample

stats = read_tsv('data/D307-D303_multiqc_stats.txt') %>%
  mutate(run = 'D307-D303',
         batch = 'tissue') %>%
  bind_rows(read_tsv('data/D492-D485_multiqc_stats.txt') %>%
              mutate(run = 'D492-D485',
                     batch = 'tissue')) %>%
  bind_rows(read_tsv('data/D1472_multiqc_stats.txt') %>%
              mutate(run = 'D1472',
                     batch = 'EVs',
                     stats_Number_of_reads = stats_Number_of_frag))


stats

stats = stats %>%
  mutate(ID_NGS = ifelse(nchar(Sample) == 12,
                         substr(Sample, 6, 12),
                         Sample)) %>%
  inner_join(data %>% 
               select(chemo_status, ID_NGS, ID_SCAND))

stats

stats %>%
  ggplot(aes(ID_SCAND, stats_Number_of_reads, fill = chemo_status)) + 
  geom_bar(stat = 'identity') +
  facet_grid(rows = vars(batch), space = 'fixed', scales = 'free_y') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_continuous(labels = scales::comma_format()) +
  ylab('nr of reads')

stats %>%
  filter(batch == 'tissue') %>%
  pull(stats_Number_of_reads) %>%
  quantile()

stats %>%
  filter(batch == 'EVs') %>%
  pull(stats_Number_of_reads) %>%
  quantile()
