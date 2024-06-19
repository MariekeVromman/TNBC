# TNBC
This repo contains all the scripts and analyses performed for the SCANDARE project, in collab with Anna Almeida and Nouritza Torossian.

The samples consits of matched 41 TNBC plasma EV and tumor samples from multiple sequencing runs.
- D1472 (07/2023, in RNA_PROFILING_CANCER) contains the 41 EV samples
- D307-D303 (05/2022, in SCANDARE-TNBC) contains 20 of the tumor samples
- D492-D485 (11/2021, in SCANDARE-TNBC) contains 21 of the tumor samples

Additionally, 2 MDA-MB-231 cell line samples (one EV and one cells) are included from sequencing run D886 (in TNBC_EV). 

> [!WARNING]  
> The labeling of the samples changed. Previously, all samples with an RCB score of 0 or 1 were considered chemosensitive, but now only an RCB score of 0 is considered chemosensitive (and RCB 1 is considered chemoresistant). Be aware that old annotation might accidentaly still be present in some files.


This repository contains 4 folders
1. **data**  

This folders contains the output data from mapping the fastq files with STAR and generating counts with FeatureCounts, and the output data from running the circRNA pipeline. As this is a big folder, it is not included in the github repo itself, but it is present on the hard disk. 

2. **scripts**

This folder contains al scripts used on the cluster to run the pipelines to generate the data in the `data` folder. The pipelines are stored in a separate GitHub repo: [RNA_seq](https://github.com/MariekeVromman/RNA_seq).

- 01_known_genes: scripts to run STAR on the fastq files and then FeatureCount on the bam files
- 02_unknown_genes: scripts to run the scallop pipeline (STAR, Scallop, CuffMerge, FeatureCounts)
- 03_circ: scripts to run the nf-core [circRNA pipeline](https://github.com/nf-core/circrna)
  - There is already a nextflow version on the cluster, up it is not kept up to date. To install your own version of nextflow, follow these [instructions](https://www.nextflow.io/docs/latest/install.html) and install nextflow in your homedir `/data/users/username`.
  - This pipeline is currently under development and no stable version has been published yet. Running it requires some optimization and it's possible to run into errors. Often, these errors are fixed by reruning/resuming the pipeline. The nf-core community is very helpful and question can be asked thourgh the dedicated [Slack `#circrna` channel](https://nfcore.slack.com/channels/circrna).
  - For consistency, the circRNA pipeline was run with this specific [commit](https://github.com/nf-core/circrna/commit/c29124feafb089482cbb709f01c648b74139460a): `d119033`
  - Mostly, default parameters are used.
  - As some of the samples are quite large, some adjustments were made to avoid errors:
  - a `env.TMPDIR` was asigned, required for the CIRCRNA_FINDER_FILTER process to run (see `02_scripts/02_circ/run2/20240610_nf.config`)
- 04_gen_type: scripts to run FeatureCounts to get a genetype for each match


3. **data-analysis**

This folder contains the R scripts used to analyse the data further, and to generate the figures.

4. **figures**

This folder contains all the generated figures. See also the presentation on Teams in `General - morillon’ s team/Marieke/TNBC_tissue_EV_updates.pptx`.
