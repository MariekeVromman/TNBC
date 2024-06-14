
#' ---
#' title: "prepare exon gtf file"
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

#' first make a list of all unique circRNAs in the dataset

circ = read_tsv('data/20240325_all_circ.txt')

circ_u = circ %>%
  mutate(score = 0) %>%
  select(chr, start, stop, circ_id, score, strand) %>% unique()

circ_u

circ_u %>% write_tsv('02_exon_anno/unique_circ.bed')

#' then with bedtools intersect, the circRNAs are intersected with exon list (see sh script)

circ_e = read_tsv('02_exon_anno/circ_exons.bed',
                  col_names = c('chr', 'start', 'end', 'circ_id', 'score', 'strand',
                                'exon_chr', 'exon_start', 'exon_end', 'ENST',
                                'score_2', 'exon_strand', 'overlap_size'))

#' how many circ did match at least one transcript
circ_e %>% select(circ_id) %>% unique()

#' get exon nrs in separate columns
circ_e = circ_e %>%
  separate(ENST, into = c('ENST', 'exon_nr'), sep = '_') %>%
  select(-score, -score_2)

circ_e

#' which are on wrong strand?
circ_e %>%
  filter(!strand == exon_strand)

circ_e = circ_e %>%
  filter(strand == exon_strand)

circ_e %>% select(circ_id) %>% unique()

#' add nr of exons info

circ_e = circ_e %>%
  select(-exon_chr, -exon_start, -exon_end, -exon_strand) %>%
  mutate(exon_nr = as.numeric(exon_nr)) %>%
  group_by(circ_id, ENST, chr, start, end, strand ) %>%
  summarise(nr_exons = n(),
            exon_min = min(exon_nr),
            exon_max = max(exon_nr),
            circ_size_s = sum(overlap_size)) %>%
  ungroup() %>%
  mutate(exons = ifelse(exon_min == exon_max,
                        exon_min,
                        paste(as.character(exon_min),
                              as.character(exon_max),
                              sep = "_"))) %>%
  select(-exon_min, -exon_max)

circ_e

#' add info on genes (canonical?)
exon_can = read_tsv('/Users/marieke/Documents/references/Gencode/gencode.v44.chr_patch_hapl_scaff.annotation_canonical.gtf')

circ_e = circ_e %>%
  left_join(exon_can %>% rename(ENST = transcript_id) %>%
              select(ENST, gene_type, gene_name,canonical))

#' check nr of matches per circ

circ_e %>% 
  select(circ_id, ENST) %>%
  unique() %>%
  group_by(circ_id) %>%
  count() %>%
  ggplot(aes(n)) +
  geom_bar()


circ_e %>% 
  select(circ_id, gene_name) %>%
  unique() %>%
  group_by(circ_id) %>%
  count() %>%
  ggplot(aes(n)) +
  geom_bar()

circ_e %>% 
  select(circ_id, ENST) %>%
  unique() %>%
  group_by(circ_id) %>%
  count() %>%
  arrange(desc(n))



#' how to deal with multiple hits?

#' what are canonical transcripts?
#' also gives gene name and type!


#' list of all unique (that only have one hit)

circ_1 = circ_e %>% 
  group_by(circ_id) %>%
  filter(n() == 1) %>% ungroup() %>%
  left_join(exon_can %>% rename(ENST = transcript_id) %>%
              select(ENST, gene_type, gene_name,canonical))

circ_1

circ_1 %>% count(canonical)

# from all that have multiple matches => check which once are canonical
circ_can = circ_e %>% 
  group_by(circ_id) %>%
  filter(n() > 1) %>% ungroup() %>% #select(circ_id) %>% unique()
  left_join(exon_can %>% rename(ENST = transcript_id) %>%
              select(ENST, gene_type, gene_name,canonical))

circ_can %>% count(canonical)

circ_can2 = circ_can %>%
  filter(canonical == 'yes') %>%
  group_by(circ_id) %>%
  filter(n() == 1) %>%
  ungroup()

circ_can2


#' make list with all the info
#' first all that have a clear match

exon_circ = circ_e %>%
  select(circ_id) %>% unique() %>%
  left_join(circ_1 %>%
              bind_rows(circ_can2))

# ambiguous ones

exon_circ = exon_circ %>%
  mutate(ENST = ifelse(is.na(ENST), "ambiguous", ENST),
         gene_type = ifelse(is.na(gene_type), "ambiguous", gene_type),
         gene_name = ifelse(is.na(gene_name), "ambiguous", gene_name),
         canonical = ifelse(is.na(canonical), "no", canonical))

#' original list => NAs
exon_circ

final = circ_u %>%
  select(-score) %>%
  left_join(exon_circ)

final %>% count(ENST) %>%
  arrange(desc(n))

final %>% select(circ_id) %>% unique()

final %>% write_tsv('02_exon_anno/annotated_circ.tsv')
