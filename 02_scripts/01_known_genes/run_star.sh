nextflow run \
        ~/Documents/GitHub/RNA_seq/STAR/star.nf \
        -profile local,arm \
        -w /Users/marieke/Documents/nf-work \
        --out_dir /Volumes/INTENSO/02_TNBC/all \
        --in_reads '/Volumes/INTENSO/02_TNBC/data/D307-D303T39/D307-D303T39{_trimmed_R1,_trimmed_R2,_trimmed.R1,_trimmed.R2}.fastq.gz'