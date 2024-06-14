
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

gen_type = tibble()

dir_path = '/Volumes/INTENSO/02_TNBC/04_gen_type/02_featureCounts'
sample_list = list.dirs(dir_path)

for (sample in sample_list) {
  
  sample_id = str_split(sample, '/')[[1]][7]
  file_path = paste(dir_path, "/", sample_id, "/", sample_id, "_FC.txt", 
                    sep = "")
  
  if (file.exists(file_path)) {
    
    gen_type = gen_type %>%
      bind_rows(
        read_tsv(file_path,
                 col_names = c('gen_type', 'chr', 'start', 'end', 'strand', 'length', 
                               'count'),
                 skip = 2) %>%
          mutate(ID_NGS = sample_id))
  }
}

gen_type

# clean up dataframe

gen_type = gen_type %>%
  select(gen_type, count, ID_NGS)

gen_type

gen_type %>% count(gen_type)

# add anno info

gen_type = gen_type %>%
  full_join(read_tsv("../00_sample_annotation/SCAND_anno.txt"))

gen_type %>% write_tsv('data/20240503_gen_type.txt')
