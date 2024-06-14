
#' ---
#' title: "normalize circ and rna counts"
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

fc = read_tsv('../data/20240502_all_fc_anno.txt')

fc

circ = read_tsv('../../03_circ/data/20240502_all_circ_med.txt')
#circ = read_tsv('../data/20240426_circ_ciriquant.txt')

circ

#' filter data based on counts

fc = fc %>%
  group_by(ENSG) %>%
  filter(any(count >= 20)) %>%
  ungroup()

fc

circ = circ %>%
  filter(substr(circ_id, 0, 3) == 'chr') %>%
  group_by(circ_id) %>%
  filter(any(median_BSJ_count >= 5)) %>%
  ungroup()

#' make one data frame for DeSeq2

counts_table = circ %>% 
  select(circ_id, median_BSJ_count, ID_NGS) %>%
  rename(ENSG = circ_id,
         count = median_BSJ_count) %>%
  bind_rows(fc %>%
              select(ENSG, count, ID_NGS)) %>%
  pivot_wider(names_from = ID_NGS, values_from = count)
  
counts_table

counts_table %>% write_tsv('../data/20240502_counts_table.tsv')

#' make matrix from df
counts_matrix = as.matrix(counts_table %>% select(-ENSG))
rownames(counts_matrix) = counts_table$ENSG

counts_matrix


#' remove NAs

counts_matrix[is.na(counts_matrix)] <- 0
counts_matrix = round(counts_matrix,0) # to remove 0.0

counts_matrix

#' save column info

coldata = circ %>%
  select(ID_NGS, sample_type) %>% unique() %>%
  mutate(sample = as.factor(ID_NGS),
         condition = as.factor(sample_type)) %>%
  select(-sample_type, -ID_NGS)

coldata

coldata_matrix = as.matrix(coldata %>% select(-sample))

rownames(coldata_matrix) = coldata$sample

coldata = coldata %>% select(-sample)

#' check if sample names are in same order

all(rownames(coldata_matrix) == colnames(counts_matrix))

#' make DESeq object

dds_object = DESeqDataSetFromMatrix(countData = counts_matrix,
                              colData = coldata_matrix,
                              design = ~ condition)

#' get size factors

size_factors = estimateSizeFactors(dds_object)

sizeFactors(size_factors)

normalized_counts = counts(size_factors, normalized=TRUE)

write.table(normalized_counts, file="../data/20240502_normalized_filtered_counts_raw.txt", sep="\t", quote=F, col.names=NA)
#write.table(normalized_counts, file="../data/20240426_normalized_filtered_counts_raw_ciriquant.txt", sep="\t", quote=F, col.names=NA)


#' make normalized counts into a tidy dataframe
normalized_counts = read_tsv("../data/20240502_normalized_filtered_counts_raw.txt")
#normalized_counts = read_tsv("../data/20240426_normalized_filtered_counts_raw_ciriquant.txt")

normalized_counts = normalized_counts %>%
  rename(gene = `...1`)

normalized_counts = normalized_counts %>%
  pivot_longer(cols = -gene, names_to = "ID_NGS", values_to = "norm_count") %>%
  filter(norm_count > 0)

#' add meta data
meta = read_tsv('../../00_sample_annotation/SCAND_anno.txt')

normalized_counts = normalized_counts %>%
  full_join(meta) 

#' add gene type info
normalized_counts = normalized_counts %>%
  rename(ENSG = gene) %>%
  full_join(fc %>% select(ENSG, length, gene_name, gene_type) %>% unique()) 

normalized_counts = normalized_counts %>%
  mutate(gene_type = ifelse(substr(ENSG, 1, 4) == 'ENSG',
                            gene_type,
                            'circRNA')) 

normalized_counts = normalized_counts %>%
  mutate(gene_type_cat = ifelse(gene_type %in% c('circRNA', 'lncRNA', 'protein_coding'),
                            gene_type,
                            'other'))

normalized_counts %>% write_tsv('../data/20240502_normalized_filtered_counts.txt')
#normalized_counts %>% write_tsv('../data/20240426_normalized_filtered_counts_ciriquant.txt')


## double check gtf to count existing transcripts
# gtf = read_tsv('/Users/marieke/Documents/references/Gencode/gencode.v44.chr_patch_hapl_scaff.annotation_ENST.txt')
# 
# gtf %>%
#   mutate(gene_id = substr(gene_id, 1, 15)) %>%
#   select(transcript_id, transcript_type) %>% unique() %>% count(transcript_type) %>% arrange(desc(n))

## double check relationship read depth and nr of counts
fc %>% 
  filter(sample_type == "EV",
         sample_origin == 'patient') %>%
  group_by(ID_NGS) %>%
  summarize(total_count = sum(count)) %>%
  full_join(read_tsv('/Users/marieke/Downloads/tmp.txt') %>%
              select(`Total Fragments`, `Sample ID`) %>%
              rename(ID_NGS = `Sample ID`)) %>% 
  ggplot(aes(total_count, `Total Fragments`)) +
  geom_point() +
  geom_abline() +
  geom_smooth(color = 'blue', method = 'lm') +
  scale_x_continuous(labels = scales::comma_format(), limits = c(0, 50000000)) +
  scale_y_continuous(labels = scales::comma_format(), limits = c(0, 50000000)) +
  coord_fixed() +
  xlab('sum of all counts') +
  ylab('total nr of reads (fragments)')
