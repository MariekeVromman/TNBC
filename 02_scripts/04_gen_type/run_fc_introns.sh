# nextflow run \
#         ~/Documents/GitHub/RNA_seq/fc/fc_introns.nf \
#         -profile local,arm \
#         -w /Users/marieke/Documents/nf-work \
#         --out_dir /Volumes/INTENSO/02_TNBC/04_gen_type \
#         --in_bam '/Volumes/INTENSO/02_TNBC/02_unknown_genes/pt_samples/01_STAR/*/*{sorted.bam,_STAR.out}' \
#         --ref_gtf '/Users/marieke/OneDrive/projects/02_TNBC/04_gen_type/introns/18_gen_types.saf'


nextflow run \
        ~/Documents/GitHub/RNA_seq/fc/fc_introns.nf \
        -profile local,arm \
        -w /Users/marieke/Documents/nf-work \
        --out_dir /Volumes/INTENSO/ \
        --in_bam '/Volumes/INTENSO/02_TNBC/02_unknown_genes/pt_samples/01_STAR/D307-D303T42/D307-D303T42{.sorted.bam,_STAR.out}' \
        --ref_gtf '/Users/marieke/OneDrive/projects/02_TNBC/04_gen_type/introns/18_gen_types.saf'