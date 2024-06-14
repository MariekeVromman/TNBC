
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

circ = tibble()

sample_list = list.dirs('/Volumes/INTENSO/06_TNBC_circ/output/20240311_out')

for (sample in sample_list) {
  
  sample_id = str_split(sample, '/')[[1]][8]
  tool_ = str_split(sample, '/')[[1]][7]
  
  file_path = paste("/Volumes/INTENSO/06_TNBC_circ/output/20240311_out/", 
                    tool_, "/", sample_id, "/", sample_id, ".annotation.bed", 
                    sep = "")
  
  if (file.exists(file_path)) {
    
    circ = circ %>%
      bind_rows(
        read_tsv(file_path,
                 col_names = c('chr', 'start', 'stop', 'circ_id', 'BSJ_count', 
                               'strand', 'circ_type', 'ENSG', 'ENST')) %>%
          mutate(tool = tool_,
                 ID_NGS = sample_id))
  }
}


# add patient info

circ


circ = circ %>%
  full_join(read_tsv("data/matched_info_long.txt"))

circ %>% count(ID_NGS) %>% arrange(n)



circ %>%
  write_tsv("20240325_all_circ.txt")

# fix wrong chemo_status label + wrong sample IDs
tmp = read_tsv('data/20240325_all_circ.txt')

tmp %>% count(chemo_status)

tmp = tmp %>%
  select(-chemo_status,
         -sample_type, 
         -sample_origin) %>%
  full_join(read_tsv('../00_sample_annotation/SCAND_anno.txt'))

tmp = tmp %>%
  rename(end = stop)

tmp %>% write_tsv('20240502_all_circ.txt')
