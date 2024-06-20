
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

counts_table = read_tsv('../../01_data/01_known_genes/20240502_counts_table.tsv')

circ = read_tsv('../../01_data/03_circ/20240502_all_circ_med.txt')

circ

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

coldata = 
  coldata %>%
  arrange(factor(sample, levels = colnames(counts_matrix)))


rownames(coldata_matrix) = coldata$sample

coldata = coldata %>% select(-sample)

#' check if sample names are in same order

all(rownames(coldata_matrix) == colnames(counts_matrix))

#' make DESeq object

dds_object = DESeqDataSetFromMatrix(countData = counts_matrix,
                                    colData = coldata_matrix,
                                    design = ~ condition)

#' perform diff exp

dds = DESeq(dds_object)

dds

dds = results(dds)
dds

summary(dds)

diff_exp = as.data.frame(dds) %>%
  rownames_to_column("gene_id")

diff_exp

normalized_counts = read_tsv('../../01_data/01_known_genes/20240502_normalized_filtered_counts.txt')

diff_exp = diff_exp %>%
  rename(ENSG = gene_id) %>%
  left_join(normalized_counts %>% select(ENSG, gene_type_cat, gene_name) %>% unique())

diff_exp %>% write_tsv('../../01_data/01_known_genes/20240620_diff_exp_types.tsv')


diff_exp = diff_exp %>%
  mutate(diffexpressed = "NO") %>%
  mutate(diffexpressed = ifelse(log2FoldChange > 0.6 & padj < 0.05, "UP", diffexpressed)) %>%
  mutate(diffexpressed = ifelse(log2FoldChange < -0.6 & padj < 0.05, "DOWN", diffexpressed)) %>%
  mutate(label_on = NA) %>%
  mutate(gene_name = ifelse(is.na(gene_name), ENSG, gene_name)) %>%
  mutate(label_on = ifelse(-log10(padj) > 1, gene_name, NA)) %>%
  mutate(gene_type_cat_color = ifelse(log2FoldChange > 0.6 & padj < 0.05, gene_type_cat, NA),
         gene_type_cat_color = ifelse(log2FoldChange < -0.6 & padj < 0.05, gene_type_cat, gene_type_cat_color))

diff_exp$gene_type_cat_color = factor(diff_exp$gene_type_cat_color,
                                      levels = c('protein_coding', 'lncRNA', 'circRNA', 'other', NA))

ggplot(data=diff_exp, 
       aes(x=log2FoldChange, y=-log10(padj),
           label = label_on)) + 
  geom_point(alpha = 0.5, 
             aes(color=gene_type_cat_color)) +
  theme_minimal() +
  geom_vline(xintercept=c(-0.6, 0.6)) +
  geom_hline(yintercept=-log10(0.05)) +
  geom_text_repel() +
  theme(legend.title = element_blank())

