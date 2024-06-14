
#' ---
#' title: "SCANDARE cohort - STAR and FeatureCounts results"
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

#' ## Read data

STAR_mapped = read_tsv('data/20231116_all_STAR_log.txt') %>%
  pivot_longer(cols = c(STAR_unique_mapped, STAR_multi_mapped, 
                        STAR_unmapped_too_short, STAR_unmapped_other),
               names_to = 'category', values_to = 'perc') %>%
  mutate(category = str_replace(category, 'STAR_', ''),
         perc = perc/100)

STAR_mapped$category = factor(STAR_mapped$category,
                              levels = c( 'unmapped_other', 'unmapped_too_short',
                                          'multi_mapped', 'unique_mapped'))

annotation = read_tsv('matched_info_long.txt')

fc = read_tsv('data/20231213_all_scallop.txt')
fc$gene_type_cat = factor(fc$gene_type_cat, levels = c('protein_coding', 'lncRNA', 'other', 'new_scallop_u', 'new_scallop_x', 'new_scallop_xu'))

fc_out = read_tsv('data/20231213_all_scallop.out')

fc_out$status = factor(fc_out$status,
                       levels = c('Unassigned_MappingQuality', 'Unassigned_NoFeatures', 'Assigned'))

#' # Results
#' ## Percentage mapped reads by STAR

#' histogram
STAR_mapped %>%
  ggplot(aes(ID_SCAND, perc, fill = category)) + 
  geom_bar(stat = 'identity') +
  facet_grid(rows = vars(sample_type), space = 'fixed') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_continuous(labels = scales::percent_format()) +
  ylab('% reads uniquely mapped by STAR')

#' quantiles per sample type
STAR_mapped %>% 
  filter(sample_type == 'tissue',
         category == "unique_mapped") %>%
  pull(perc) %>%
  quantile()*100

STAR_mapped %>% 
  filter(sample_type == 'EV',
         category == "unique_mapped") %>%
  pull(perc) %>%
  quantile()*100

#' ## New genome annotation file

fc %>% 
  select(gene_id, gene_type_cat) %>%
  unique() %>%
  ggplot(aes(gene_type_cat, fill = gene_type_cat)) +
  geom_bar() +
  geom_text(stat='count', aes(label=scales::comma(..count..)), vjust=-1) +
  scale_y_continuous(labels = scales::comma_format(), limits = c(0, 30000)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))


#' ## Nr of identified genes by FeatureCounts

#' ### General

#' histogram out file

fc_out %>%
  ggplot(aes(ID_SCAND, nr, fill = status)) +
  geom_bar(position = "fill", stat = "identity") +
  facet_grid(rows = vars(sample_type), space = 'fixed') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_continuous(labels = scales::percent_format()) +
  ylab('% of reads that could be assigned to a feature')

#' histogram
fc %>%
  mutate(gene_type_cat_bin = ifelse(gene_type == "new", 'new_scallop', 'reference_genome')) %>%
  filter(read_count >= 10) %>%
  ggplot(aes(ID_SCAND, fill = gene_type_cat_bin)) +
  geom_bar() +
  facet_grid(rows = vars(sample_type), space = 'fixed') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_continuous(labels = scales::comma_format()) +
  ylab('nr of transcripts identified by FeatureCounts')

fc %>%
  filter(read_count >= 10) %>%
  group_by(ID_SCAND, sample_type) %>%
  count() %>%
  group_by(sample_type) %>% summarise(med = median(n))

#' distribution of the counts
fc %>%
  ggplot(aes(ID_SCAND, read_count, fill = chemo_status)) +
  geom_boxplot() +
  facet_grid(rows = vars(sample_type), space = 'fixed') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_log10(labels = scales::comma_format(),
                breaks = c(1, 10, 100, 1000, 10000, 100000, 1000000))

#' distribution of the counts simplified
fc %>%
  ggplot(aes(sample_type, read_count, fill = gene_type_cat)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_log10(labels = scales::comma_format(), 
                breaks = c(1, 10, 100, 1000, 10000, 100000, 1000000))

#' ### Per gene type
fc %>%
  filter(read_count > 0) %>%
  ggplot(aes(sample_type, fill = gene_type_cat)) +
  geom_bar(position = 'dodge') +
  #facet_grid(cols = vars(gene_type_cat), space = 'fixed') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_continuous(labels = scales::comma_format()) +
  ylab('nr of genes identified by FeatureCounts')


fc %>% select(gene_type_cat, gene_id) %>% unique() %>%
  count(gene_type_cat)

fc %>%
  filter(read_count > 0) %>%
  group_by(sample_type, gene_type_cat) %>%
  summarise(nr_genes = n()) %>%
  pivot_wider(names_from = sample_type,
              values_from = nr_genes) %>%
  mutate(ratio = tissue/EV)

#' ## Overlap between samples
#' 
#' ### Concordance analysis

conc = fc %>%
  filter(sample_type == 'EV') %>%
  select(gene_id, read_count, ID_SCAND, gene_type) %>%
  rename(read_count_EV = read_count) %>%
  full_join(fc %>%
              filter(sample_type == 'tissue') %>%
              select(gene_id, read_count, ID_SCAND, gene_type) %>%
              rename(read_count_tissue = read_count))

conc_stat =
  conc %>% 
  filter(read_count_EV >= 10 | read_count_tissue >= 10 | read_count_EV == 0 & read_count_tissue == 0) %>%
  mutate(conc_label = ifelse(read_count_EV == 0 & read_count_tissue == 0, 'yes', 'unknown'),
                  conc_label = ifelse(read_count_EV > 0 & read_count_tissue > 0, 'yes', conc_label),
                  conc_label = ifelse(read_count_EV > 0 & read_count_tissue == 0, 'unique_EV', conc_label),
                  conc_label = ifelse(read_count_EV == 0 & read_count_tissue > 0, 'unique_tissue', conc_label)) %>%
  mutate(gene_type_cat_bin = ifelse(gene_type == "new", 'new_scallop', 'reference_genome')) %>%
  group_by(ID_SCAND, gene_type_cat_bin) %>%
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
  geom_text(stat='identity',
            data = conc_stat,
            #position_stack(vjust = 0.5),
            aes(x = xpos, label = paste(sprintf("%0.0f", round((100*perc), digits = 1)), '%', sep = ''))) +
  scale_fill_manual(values = c('orange', 'grey', 'seagreen2')) +
  facet_grid(~gene_type_cat_bin) +
  mytheme

conc_stat %>%
  filter(type == 'concordant') %>%
  group_by(gene_type_cat) %>%
  summarize(quant25 = quantile(perc, probs = .25)*100, 
            quant50 = quantile(perc, probs = .5)*100,
            quant75 = quantile(perc, probs = .75)*100)


#' ### Venn diagram

fc_list = list()

fc_list['chemoS_EV'] = fc %>% filter(chemo_status == 'chemoS', sample_type == 'EV', read_count > 0) %>% pull(gene_id) %>% unique() %>% list()
fc_list['chemoR_EV'] = fc %>% filter(chemo_status == 'chemoR', sample_type == 'EV', read_count > 0) %>% pull(gene_id) %>% unique() %>% list()
fc_list['chemoS_tissue'] = fc %>% filter(chemo_status == 'chemoS', sample_type == 'tissue', read_count > 0) %>% pull(gene_id) %>% unique() %>% list()
fc_list['chemoR_tissue'] = fc %>% filter(chemo_status == 'chemoR', sample_type == 'tissue', read_count > 0) %>% pull(gene_id) %>% unique() %>% list()

fc_list_simple = list()
fc_list_simple['EV'] = fc %>% filter(sample_type == 'EV', read_count > 0) %>% pull(gene_id) %>% unique() %>% list()
fc_list_simple['tissue'] = fc %>% filter(sample_type == 'tissue', read_count > 0) %>% pull(gene_id) %>% unique() %>% list()



library('VennDiagram')

fc_venn = venn.diagram(fc_list, 
             filename = NULL)
grid::grid.newpage()
grid::grid.draw(fc_venn)

fc_venn = venn.diagram(fc_list_simple, 
                       filename = NULL)
grid::grid.newpage()
grid::grid.draw(fc_venn)


#' ### Euler plot
library('eulerr')

fc_euler = euler(fc_list)

plot(fc_euler)

fc_euler = euler(fc_list_simple)

plot(fc_euler)

#' ## Correlation of the counts
library("ggpubr")

fc_cor = fc %>%
  filter(sample_type == 'tissue') %>%
  select(gene_id, read_count, ID_SCAND, chemo_status) %>%
  rename(read_count_tissue = read_count) %>%
  full_join(fc %>%
              filter(sample_type == 'EV') %>%
              select(gene_id, read_count, ID_SCAND, chemo_status) %>%
              rename(read_count_EV = read_count))

fc_cor

fc_cor %>%
  #filter(read_count_EV > 0, read_count_tissue > 0) %>%
  filter(ID_SCAND == '01-030') %>%
  #filter(gene_id == 'ENSG00000251562.11') %>%
  ggplot(aes(read_count_tissue, read_count_EV)) +
  geom_point(alpha = 0.3) +
  scale_x_log10(labels = scales::comma_format()) +
  scale_y_log10(labels = scales::comma_format()) +
  #geom_abline(slope = 1, intercept = 0, color = '#D46363') +
  facet_wrap(~chemo_status) +
  coord_fixed() +
  geom_smooth(method = "lm", color = '#00B9F2') +
  stat_regline_equation(label.y = 6.5, label.x = 0.001) +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "*`,`~")),
           label.y= 6, label.x = 0.001, method = 'spearman')

#' per sample
fc_cor_sub = fc_cor %>%
  filter(read_count_EV > 0, read_count_tissue > 0) %>%
  filter(ID_SCAND == '01-030')

cor_test = cor.test(fc_cor_sub$read_count_EV, fc_cor_sub$read_count_tissue, method = 'spearman')
cor_test$estimate

#' for all samples

fc_cor_stat = tibble()

for (sample_x in fc_cor %>% pull(ID_SCAND) %>% unique()) {
  fc_tmp_sub = fc_cor %>% filter(ID_SCAND == sample_x) %>%
    filter(read_count_EV > 0, read_count_tissue > 0)
  cor_test_tmp = cor.test(fc_tmp_sub$read_count_EV, fc_tmp_sub$read_count_tissue, method = 'spearman')
  
  fc_cor_stat = fc_cor_stat %>%
    bind_rows(tibble(ID_SCAND = sample_x,
                     rho = cor_test_tmp$estimate))
}
  
fc_cor_stat

fc_cor_stat = fc_cor_stat %>%
  mutate(R_2 = rho^2)


fc_cor_stat

fc_cor_stat %>%
  ggplot(aes(R_2, ID_SCAND)) +
  geom_bar(stat = 'identity')

#' per gene type
#' 
fc_cor = fc %>%
  filter(sample_type == 'tissue') %>%
  select(gene_id, read_count, ID_SCAND, chemo_status, gene_type_cat) %>%
  rename(read_count_tissue = read_count) %>%
  full_join(fc %>%
              filter(sample_type == 'EV') %>%
              select(gene_id, read_count, ID_SCAND, chemo_status) %>%
              rename(read_count_EV = read_count))

fc_cor_stat = tibble()

for (sample_x in fc_cor %>% pull(ID_SCAND) %>% unique()) {
  
  for (gene_type_x in fc_cor %>% pull(gene_type_cat) %>% unique()){
    
    fc_tmp_sub = fc_cor %>% filter(ID_SCAND == sample_x) %>%
      filter(read_count_EV > 0, read_count_tissue > 0) %>%
      filter(gene_type_cat == gene_type_x)
      
    cor_test_tmp = cor.test(fc_tmp_sub$read_count_EV, fc_tmp_sub$read_count_tissue, method = 'spearman')
    
    fc_cor_stat = fc_cor_stat %>%
      bind_rows(tibble(ID_SCAND = sample_x,
                       rho = cor_test_tmp$estimate,
                       gene_type_cat = gene_type_x))
  }
}

fc_cor_stat

fc_cor_stat = fc_cor_stat %>%
  mutate(R_2 = rho^2)


fc_cor_stat

fc_cor_stat$gene_type_cat = factor(fc_cor_stat$gene_type_cat, levels = c('protein_coding', 'lncRNA', 'other', 'new_scallop_u', 'new_scallop_x', 'new_scallop_xu'))

fc_cor_stat %>%
  ggplot(aes(ID_SCAND, R_2, fill = gene_type_cat)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  facet_wrap(~gene_type_cat) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) 
  


#' with z-score normalisation
fc_norm = fc %>%
  filter(read_count > 0) %>%
  group_by(ID_NGS) %>%
  mutate(read_count_mean = mean(read_count), 
         read_count_sd = sd(read_count)) %>%
  ungroup() %>%
  mutate(Z_score = (read_count - read_count_mean ) / read_count_sd)

fc_norm

fc_cor = fc_norm %>%
  #filter(sample_type == 'tissue') %>%
  select(gene_id, Z_score, ID_SCAND, chemo_status) %>%
  rename(Z_score_tissue = Z_score) %>%
  full_join(fc_norm %>%
              filter(sample_type == 'EV') %>%
              select(gene_id, Z_score, ID_SCAND, chemo_status) %>%
              rename(Z_score_EV = Z_score))
fc_cor

fc_cor %>%
  #filter(ID_SCAND == '01-030') %>%
  #filter(!gene_id == "ENSG00000289740.1") %>%
  ggplot(aes(Z_score_tissue, Z_score_EV)) +
  geom_point(alpha = 0.3) +
  scale_x_log10(labels = scales::comma_format()) +
  scale_y_log10(labels = scales::comma_format()) +
  geom_abline(slope = 1, intercept = 0, color = '#D46363') +
  facet_wrap(~chemo_status) +
  coord_fixed() +
  geom_smooth(method = "lm", color = '#00B9F2') +
  stat_regline_equation(label.y = 4, label.x = -4) +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "*`,`~")),
           label.y= 3.5, label.x = -4, method = 'spearman')

fc_norm %>% filter(Z_score > 150) %>% view()

#' ## Check strandedness
fc %>% filter(gene_name %in% c('MALAT1', 'TALAM1')) %>%
  ggplot(aes(ID_SCAND, read_count, color = sample_type)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  facet_wrap(~gene_name, nrow = 2) +
  scale_y_log10(labels = scales::comma_format())

#' ## Differential expression

library("DESeq2")
library(ggrepel)

counts_table = fc %>%
  #filter(gene_type_cat %in% c("protein_coding", 'lncRNA', 'other')) %>%
  mutate(sample = paste(sample_type, substr(ID_SCAND, 4, 6), sep = '_')) %>%
  select(gene_id, sample, read_count) %>%
  pivot_wider(names_from = sample, values_from = read_count)

counts_table

counts_matrix = as.matrix(counts_table %>% select(-gene_id))
rownames(counts_matrix) = counts_table$gene_id

counts_matrix


# remove NAs

counts_matrix[is.na(counts_matrix)] <- 0

counts_matrix = round(counts_matrix,0)

# column info

coldata = fc %>%
  mutate(sample = paste(sample_type, substr(ID_SCAND, 4, 6), sep = '_')) %>%
  select(sample, sample_type) %>% unique() %>%
  mutate(sample = as.factor(sample),
         condition = as.factor(sample_type)) %>%
  select(-sample_type)

coldata

coldata_matrix = as.matrix(coldata %>% select(-sample))

rownames(coldata_matrix) = coldata$sample

coldata = coldata %>% select(-sample)

#' check if sample names are in same order

all(rownames(coldata_matrix) == colnames(counts_matrix))

dds <- DESeqDataSetFromMatrix(countData = counts_matrix,
                              colData = coldata_matrix,
                              design = ~ condition)
dds = DESeq(dds)

dds

dds = results(dds)
dds

summary(dds)

diff_exp = as.data.frame(dds) %>%
  rownames_to_column("gene_id")

diff_exp

diff_exp = diff_exp %>%
  mutate(diffexpressed = "NO") %>%
  mutate(diffexpressed = ifelse(log2FoldChange > 0.6 & padj < 0.05, "UP", diffexpressed)) %>%
  mutate(diffexpressed = ifelse(log2FoldChange < -0.6 & padj < 0.05, "DOWN", diffexpressed)) %>%
  mutate(label_on = NA) %>%
  mutate(label_on = ifelse(-log10(padj) > 22, gene_id, NA))


# add info about gene type

diff_exp = diff_exp %>%
  left_join(fc %>% select(gene_id, gene_type_cat) %>% unique()) %>%
  mutate(gene_type_simple = ifelse(gene_type_cat %in% 
                                     c("protein_coding", 'lncRNA', 'other'),
                                   'gencode', 'new_scallop'))


ggplot(data=diff_exp, 
       aes(x=log2FoldChange, y=-log10(padj),
           #label = label_on
           )) + 
  geom_point(alpha = 0.4, 
             aes(color=diffexpressed, shape = gene_type_simple)) +
  theme_minimal() +
  geom_vline(xintercept=c(-0.6, 0.6), col="red") +
  geom_hline(yintercept=-log10(0.05), col="red") +
  scale_color_manual(values=c("coral", "black", "darkolivegreen3")) #+
  #geom_text_repel()

diff_exp %>%
  filter(diffexpressed == 'DOWN') %>%
  count(gene_type_simple)

#' ## heatmap
library(ComplexHeatmap)

fc.matrix = 
  fc %>%
  filter(sample_type == 'EV',
         #gene_type_cat == 'lncRNA',
         #substr(chr, 1, 3) == 'chr'
         ) %>%
  select(read_count, ID_NGS, gene_id) %>%
  group_by(gene_id) %>%
  filter(median(read_count) > 10000) %>%
  pivot_wider(names_from = ID_NGS, values_from = read_count) %>%
  ungroup()

fc.matrix

row.names = fc.matrix %>% select(gene_id)
col.names = colnames(fc.matrix %>% select(-gene_id))

fc.matrix = as.matrix(fc.matrix %>% select(-gene_id))
head(fc.matrix[1:10,1:5])

#fc.matrix_cor = cor(fc.matrix, method = 'spearman')
fc.matrix_cor = fc.matrix

fc_hm = draw(Heatmap(fc.matrix_cor,
        name = "heatmap",
        column_title_side = "bottom",
        column_names_rot = 45,
        
        #cluster_rows = FALSE,
        #show_row_dend = FALSE,
        
        clustering_distance_columns = 'euclidean',
        clustering_distance_rows = 'euclidean'))

fc_hm

column_order(fc_hm)

chemo_anno = annotation %>% 
  filter(sample_type == "EV") %>%
  select(ID_NGS, chemo_status) %>%
  #arrange(desc(ID_NGS)) %>%
  slice(column_order(fc_hm)) %>%
  select(chemo_status) %>%
  pull(chemo_status)

column_ha = HeatmapAnnotation(chemo = chemo_anno,
                              #col = list(bar = c("a" = "red", "b" = "green", "c" = "blue"))
                              which = 'column')

fc_hm = draw(Heatmap(fc.matrix_cor,
                     name = "heatmap",
                     column_title_side = "bottom",
                     column_names_rot = 45,
                     
                     #cluster_rows = FALSE,
                     #show_row_dend = FALSE,
                     
                     clustering_distance_columns = 'euclidean',
                     clustering_distance_rows = 'euclidean',
                     
                     bottom_annotation = column_ha))




#' ## Gene Ontology
#' use dev version to build on mac https://github.com/sgrote/GOfuncR
library(GOfuncR) 

in_genes = fc %>%
  filter(read_count > 0) %>%
  mutate(is_candidate = ifelse(sample_type == "tissue", 0, 1)) %>%
  select(gene_name, is_candidate) %>%
  unique() %>%
  as.data.frame()

in_genes


GO_out = go_enrich(in_genes)

GO_res = GO_out$results

GO_res

GO_over = GO_res[GO_res$raw_p_overrep<=0.05,]
GO_under = GO_res[GO_res$raw_p_underrep<=0.05,]



Genes<- GO_out$genes
Candidate_Gene <-Genes[Genes$is_candidate==1,]

Gene_all_GO<-get_anno_categories(Candidate_Gene$gene_name)


Out_Over_Representation<-merge(GO_over,Gene_all_GO, by.x = "node_id",by.y = "go_id", all.x = TRUE, all.y = FALSE)

Out_Under_Representation<-merge(GO_under,Gene_all_GO, by.x = "node_id",by.y = "go_id", all.x = TRUE, all.y = FALSE)


Results_Over_Representation<- Out_Over_Representation %>% group_by(node_id) %>% mutate(gene= paste(gene, collapse=",")) %>% unique %>% na.omit
Results_Under_Representation<- Out_Under_Representation %>% group_by(node_id) %>% mutate(gene= paste(gene, collapse=",")) %>% unique %>% na.omit
Results_Over_Representation[ ,c(9,10)] <- NULL 
Results_Under_Representation[ ,c(9,10)] <- NULL



## HOTAIR

fc %>% 
  filter(gene_id == "ENSG00000228630.7") %>%
  ggplot(aes(ID_SCAND, read_count)) +
  geom_point() +
  facet_wrap(~sample_type, scales = 'free_y', nrow = 2) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  scale_y_log10()
