
#' ---
#' title: "tidy data of circRNA detection in MDA-MB-231 cells and EVs, and TNBC pt tissues and EVs"
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

#' ## Set figure theme
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

#' read in data

gen_type = read_tsv('data/20240503_gen_type.txt')

#' plot

gen_type$sample_type = factor(gen_type$sample_type,
                              levels = c('tumor', 'EV'))

gen_type %>%
  filter(sample_origin == 'patient') %>%
  ggplot(aes(ID_SCAND, count, fill = gen_type)) +
  geom_bar(stat = 'identity', position = 'fill') + 
  facet_wrap(~sample_type) +
  mytheme_discrete_x +
  scale_y_continuous(labels = scales::percent_format())+
  theme(legend.title = element_blank(),
        strip.text = element_text(size=12)) +
  xlab('') +
  ylab('percentage of reads that map to ...')

# get numbers

gen_type %>%
  filter(sample_origin == 'patient') %>%
  group_by(ID_SCAND, sample_type) %>%
  mutate(total_count = sum(count)) %>%
  ungroup() %>%
  mutate(perc = count/total_count) %>%
  group_by(sample_type, gen_type) %>%
  summarise(med_perc = median(perc))
