
#' ---
#' title: "tidy STAR + FC data"
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
conflict_prefer("filter", "dplyr")
conflict_prefer("select", "dplyr")
conflict_prefer("slice", "dplyr")
conflict_prefer("rename", "dplyr")
conflict_prefer('intersect', 'dplyr')
conflicts_prefer(dplyr::count)

#' # Read in data

fc = tibble()

sample_list = list.dirs('/Volumes/INTENSO/02_TNBC/01_known_genes/02_featureCounts')

for (sample in sample_list) {
  
  sample_id = str_split(sample, '/')[[1]][7]

  file_path = paste("/Volumes/INTENSO/02_TNBC/01_known_genes/02_featureCounts/", 
                    sample_id, "/", sample_id, "_FC.txt", 
                    sep = "")
  
  if (file.exists(file_path)) {
    
    fc = fc %>%
      bind_rows(
        read_tsv(file_path,
                 skip = 2,
                 col_names = c('ENSG', 'chr', 'start', 'end', 'strand', 'length', 
                               'gene_id', 'gene_name', 'gene_type', 'count')) %>%
          mutate(ID_NGS = sample_id)) 
  }
}

fc

#' # Tidy the dataframe
#' remove double columns

fc %>% filter(!ENSG == gene_id)

fc = fc %>%
  select(-gene_id)

#' save tidy dataframe

fc %>% write_tsv('../data/20240502_all_fc.txt')

fc = read_tsv('../data/20240502_all_fc.txt')


#' # add annotation
#' first fix difference in ID_NGS

fc = fc %>%
  mutate(ID_NGS = ifelse(nchar(ID_NGS) == 12,
                         substr(ID_NGS, 6, 12),
                         ID_NGS))

fc

#' read in annotation
anno = read_tsv('../../00_sample_annotation/SCAND_anno.txt')

anno

fc = fc %>% full_join(anno)

fc %>% write_tsv('../data/20240502_all_fc_anno.txt')

#' # Combine circ and lin data

circ = read_tsv('../../03_circ/data/20240502_all_circ.txt')

circ

#' summarize circRNA counts from different tools into one count by taking the median

circ = circ %>%
  mutate(ENST = substr(ENST, 1, 15),
         ENSG = substr(ENSG, 1, 15)) %>% # substring because some circ have multiple ENST matches
  group_by(chr, start, end, circ_id, strand, circ_type, 
           ID_NGS, ID_SCAND, chemo_status, RCB_score, sample_type, sample_origin) %>%
  summarise(n_tools = n(),
            tools = paste(tool, collapse = ','),
            ENST = paste(ENST, collapse = ','),
            ENSG = paste(ENSG, collapse = ','),
            median_BSJ_count = median(BSJ_count)) %>%
  ungroup()

circ

circ %>% write_tsv('../data/202400502_all_circ_med.txt')

#' #' try only one tool
#' circ %>% filter(tool == 'ciriquant') %>% 
#'   rename(median_BSJ_count = BSJ_count) %>%
#'   write_tsv('../data/20240426_circ_ciriquant.txt')

