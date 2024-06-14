
#' ---
#' title: "generate index to estimate intron reads"
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



gtf = read_tsv('/Users/marieke/Documents/references/Gencode/gencode.v44.chr_patch_hapl_scaff.annotation.gtf',
               col_names = c('chr', 'havana', 'type', 'start', 'end', 'dot', 
                             'strand', 'dot2', 'info'),
               skip = 5)

gtf %>%
  filter(type == "exon") %>%
  mutate(name = 'exon',
         score = '.') %>%
  select(chr, start, end, name, score, strand) %>%
  unique() %>%
  filter(substr(chr, 0, 3) == 'chr') %>%
  write_tsv('01_exons.bed', col_names = FALSE)

# get introns

library(GenomicFeatures)

## make TxDb from GTF file 
txdb <- makeTxDbFromGFF('/Users/marieke/Documents/references/Gencode/gencode.v44.chr_patch_hapl_scaff.annotation.gtf')

## get intron information
all.introns <- bed(txdb)

introns = as.data.frame(all.introns) %>%
  mutate(name = 'intron',
         score = '.') %>%
  select(seqnames, start, end, name, score, strand)

introns %>%
  filter(substr(seqnames, 0, 3) == 'chr') %>%
  write_tsv('04_introns.bed',
            col_names = FALSE)

# clean merged
read_tsv("03_exons.sorted.merged.bed",
         col_names = c('chr', 'start', 'end', 'name', 'score', 'strand')) %>%
  separate(name, into = c('name'), sep = ',', extra = 'drop') %>%
  separate(strand, into = c('strand'), sep = ',', extra = 'drop') %>%
  separate(score, into = c('score'), sep = ',', extra = 'drop') %>%
  write_tsv('03_exons.cleaned.bed', 
            col_names = FALSE)
  
read_tsv("06_introns.sorted.merged.bed",
         col_names = c('chr', 'start', 'end', 'name', 'score', 'strand')) %>%
  separate(name, into = c('name'), sep = ',', extra = 'drop') %>%
  separate(strand, into = c('strand'), sep = ',', extra = 'drop') %>%
  separate(score, into = c('score'), sep = ',', extra = 'drop') %>%
  write_tsv('06_introns.cleaned.bed', 
            col_names = FALSE)

read_tsv('12_intergenic.sorted.bed',
         col_names = c('chr', 'start', 'end', 'strand')) %>%
  mutate(score = '.',
         name = 'intergenic') %>%
  select(chr, start, end, name, score, strand) %>%
  write_tsv('12_intergenic.cleaned.bed',
            col_names = FALSE)

# bed to gtf
read_tsv('17_all.sorted.bed',
         col_names = c('chr', 'start', 'end', 'name', 'score', 'strand')) %>%
  select(name, chr, start, end, strand) %>%
  write_tsv('18_gen_types.saf',
        col_names = F)

