
#' Set working directory to current directory
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


#' # ANNOTATION

tis = read_tsv('SCAN_tissue_info.txt')
tis

plas = read_tsv('SCAN_plasma_info.txt')

full_join(tis, plas) %>% view()

tis %>% count(run)
tis %>% count(seq_batch)

plas %>% count(date_ARN)

tis %>%
  select(-seq_batch) %>%
  rename(ID_seq_run = run) %>%
  mutate(sample_type = 'tissue') %>%
  bind_rows(plas %>%
              select(-nr_NGS, -nr_ARN) %>%
              mutate(ID_seq_run = 'D1472') %>%
              mutate(RNA_batch = ifelse(date_ARN == "02/05/2023",'batch_1', "unknown"),
                     RNA_batch = ifelse(date_ARN == "12/05/2023",'batch_2', RNA_batch),
                     RNA_batch = ifelse(date_ARN == "19/05/2023",'batch_3', RNA_batch),
                     RNA_batch = ifelse(date_ARN == "25/05/2023",'batch_4', RNA_batch),
                     RNA_batch = ifelse(date_ARN == "02/06/2023",'batch_5', RNA_batch),
                     RNA_batch = ifelse(date_ARN == "08/06/2023",'batch_6', RNA_batch)) %>%
              select(-date_ARN) %>%
              mutate(sample_type = 'plasma_EVs')) %>% 
  write_tsv('SCAN_info.txt')
  

tis %>%
  select(-seq_batch) %>%
  rename(ID_seq_run_2 = run) %>%
  full_join(plas %>%
              select(-nr_NGS, -nr_ARN) %>%
              mutate(ID_seq_run = 'D1472') %>%
              mutate(RNA_batch = ifelse(date_ARN == "02/05/2023",'batch_1', "unknown"),
                     RNA_batch = ifelse(date_ARN == "12/05/2023",'batch_2', RNA_batch),
                     RNA_batch = ifelse(date_ARN == "19/05/2023",'batch_3', RNA_batch),
                     RNA_batch = ifelse(date_ARN == "25/05/2023",'batch_4', RNA_batch),
                     RNA_batch = ifelse(date_ARN == "02/06/2023",'batch_5', RNA_batch),
                     RNA_batch = ifelse(date_ARN == "08/06/2023",'batch_6', RNA_batch)) %>%
              select(-date_ARN) ) %>%
  write_tsv('SCAN_info_2.txt')



tis %>%
  filter(time == 'pre',
         ID_SCAND %in% (plas %>% pull(ID_SCAND))) %>%
  select(run, ID_NGS, ID_SCAND, chemo_status) %>%
  rename(tissue_run = run, tissue_ID_NGS = ID_NGS) %>%
  full_join(plas %>% select(ID_SCAND, ID_SCAND_EV, chemo_status) %>%
              rename(EV_ID_SCAND = ID_SCAND_EV)) %>%
  left_join(read_tsv('EV_samplesheet.txt') %>%
              select(Sample_ID, Sample_Name) %>%
              rename(EV_ID_NGS = Sample_ID,
                     EV_ID_SCAND = Sample_Name) %>%
              mutate(EV_run = 'D1472',
                     EV_ID_NGS = paste('D1472', EV_ID_NGS, sep = ''))) %>%
  select(ID_SCAND, EV_ID_SCAND, chemo_status, 
         tissue_run, tissue_ID_NGS, EV_run, EV_ID_NGS) %>%
  write_tsv('matched_info.txt')


#' annotation long format

annotation_long = annotation %>%
  select(-EV_ID_SCAND, -tissue_run, -EV_run) %>%
  pivot_longer(cols = c(tissue_ID_NGS, EV_ID_NGS),
               names_to = 'sample_type',
               values_to = 'ID_NGS') %>%
  mutate(sample_type = str_replace(sample_type, '_ID_NGS', '')) %>%
  arrange(ID_NGS)

annotation_long

annotation_long %>% write_tsv('matched_info_long.txt')

#' # STAR + FEATURECOUNTS

annotation = read_tsv('matched_info_long.txt')

annotation

samples = dir("/Volumes/INTENSO/02_TNBC/05_featureCounts/")
samples

fc = tibble()

for (sample_x in samples){
  fc = fc %>%
    bind_rows(
      read_tsv(str_c('/Volumes/INTENSO/02_TNBC/05_featureCounts/', sample_x, '/', 
                     sample_x, '_FC.txt'),
               skip = 1) %>%
        mutate(ID_NGS = sample_x) %>%
        rename(read_count = str_c(sample_x, '.sorted.bam')))
}


fc = fc %>%
  rename(chr = Chr,
         start = Start,
         end = End,
         strand = Strand,
         length = Length) %>%
  select(-Geneid) %>%
  full_join(annotation)

fc = fc %>%
  mutate(gene_type_cat = ifelse(gene_type == 'protein_coding', 
                                'protein_coding', 'other'),
         gene_type_cat = ifelse(gene_type == 'lncRNA', 
                                'lncRNA', gene_type_cat),
         gene_type_cat = ifelse(gene_type == 'new', 
                                'new_scallop', gene_type_cat))

# add x and u info from scallop gtf
scallop_gtf = read_tsv('/Volumes/INTENSO/02_TNBC/04_cuffmerge_filtered/merged_filtered.gtf', 
                       col_names = c('version', 'Cufflinks', 'type', 'start', 'end', 'chr',
                                      'dot', 'strand', 'dot2', 'info'))
scallop_gtf_tmp = scallop_gtf %>%
  filter(type == 'exon') %>%
  select(dot2) %>%
  separate(dot2, into = c('gene_id', 'rest'),
           sep = ';', extra = "merge") 


scallop_gtf_tmp = scallop_gtf_tmp %>%
  mutate(class_code = str_extract(rest, 'class_code \"[u,x]'),
         class_code = substr(class_code, 13, 13),
         gene_id = substr(gene_id, 10, 20)) %>%
  select(gene_id, class_code) %>% 
  unique() %>%
  group_by(gene_id) %>%
  mutate(gene_type_cat = ifelse(n() == 2, 'new_scallop_xu', 'unknown'),
         gene_type_cat = ifelse(gene_type_cat == "unknown" & class_code == 'u', "new_scallop_u", gene_type_cat),
         gene_type_cat = ifelse(gene_type_cat == "unknown" & class_code == 'x', "new_scallop_x", gene_type_cat)) %>%
  ungroup() %>%
  select(gene_id, gene_type_cat) %>%
  unique() 

scallop_gtf_tmp %>%
  count(gene_type_cat)

fc_tmp = fc %>%
  filter(gene_type == 'new') %>%
  select(-gene_type_cat) %>%
  left_join(scallop_gtf_tmp) %>%
  bind_rows(fc %>% filter(!gene_type == 'new'))

fc_tmp %>% write_tsv('data/20231213_all_scallop.txt')
#fc %>% write_tsv('/Volumes/INTENSO/02_TNBC/05_featureCounts/20231212_all_STAR_FC.txt')


#' # FC output

annotation = read_tsv('matched_info_long.txt')

annotation

samples = dir("/Volumes/INTENSO/02_TNBC/05_featureCounts/")
samples

fc = tibble()

for (sample_x in samples){
  fc = fc %>%
    bind_rows(
      read_tsv(str_c('/Volumes/INTENSO/02_TNBC/05_featureCounts/', sample_x, '/', 
                     sample_x, '_FC.summary.txt'),
               col_names = c('status', 'nr'),
               skip = 1) %>%
        mutate(ID_NGS = sample_x))
}


fc = fc %>%
  filter(nr > 0) %>%
  full_join(annotation)

fc

fc %>% write_tsv('data/20231213_all_scallop.out')
#fc %>% write_tsv('/Volumes/INTENSO/02_TNBC/20231208_featureCounts/20231208_all_STAR_FC.out')


# # STAR out
samples = annotation %>% pull(ID_NGS)

samples

STAR_out = tibble()

for (sample_x in samples){
  
  STAR_out = STAR_out %>%
    bind_rows(
      #### % mapped
      tibble(STAR_unique_mapped = 
               read_lines(str_c('/Volumes/INTENSO/02_TNBC/01_STAR/', sample_x, '/', 
                                sample_x, '_Log.final.out'), 
                          skip = 9, n_max = 1))  %>%
        mutate(ID_NGS = sample_x,
               STAR_unique_mapped = as.numeric(substr(STAR_unique_mapped, 51, 55 ))) %>%
        
        #### % multimapped
        full_join(tibble(STAR_multi_mapped = 
                           read_lines(str_c('/Volumes/INTENSO/02_TNBC/01_STAR/', sample_x, '/', 
                                            sample_x, '_Log.final.out'), 
                                      skip = 24, n_max = 1))  %>%
                    mutate(ID_NGS = sample_x,
                           STAR_multi_mapped = as.numeric(str_replace(substr(
                             STAR_multi_mapped, 51, 55),
                             '%', '')))) %>%
        
        #### % unmapped_MM
        full_join(tibble(STAR_unmapped_MM = 
                           read_lines(str_c('/Volumes/INTENSO/02_TNBC/01_STAR/', sample_x, '/', 
                                            sample_x, '_Log.final.out'), 
                                      skip = 29, n_max = 1))  %>%
                    mutate(ID_NGS = sample_x,
                           STAR_unmapped_MM = as.numeric(str_replace(substr(
                             STAR_unmapped_MM, 51, 55),
                             '%', '')))) %>%
        
        #### % unmapped_too_short
        full_join(tibble(STAR_unmapped_too_short = 
                           read_lines(str_c('/Volumes/INTENSO/02_TNBC/01_STAR/', sample_x, '/', 
                                            sample_x, '_Log.final.out'), 
                                      skip = 31, n_max = 1))  %>%
                    mutate(ID_NGS = sample_x,
                           STAR_unmapped_too_short = as.numeric(str_replace(substr(
                             STAR_unmapped_too_short, 51, 55),
                             '%', '')))) %>%
        
        #### unmapped_other
        full_join(tibble(STAR_unmapped_other = 
                           read_lines(str_c('/Volumes/INTENSO/02_TNBC/01_STAR/', sample_x, '/', 
                                            sample_x, '_Log.final.out'), 
                                      skip = 33, n_max = 1))  %>%
                    mutate(ID_NGS = sample_x,
                           STAR_unmapped_other = as.numeric(str_replace(substr(
                             STAR_unmapped_other, 51, 55),
                             '%', '')))))
}
  


STAR_out 


STAR_out %>%
  relocate(ID_NGS) %>%
  select(-STAR_unmapped_MM) %>%
  full_join(annotation) %>%
  write_tsv('data/20231116_all_STAR_log.txt')

STAR_out %>% mutate(total = STAR_unique_mapped + STAR_multi_mapped + STAR_unmapped_too_short + STAR_unmapped_other)  %>% view()


