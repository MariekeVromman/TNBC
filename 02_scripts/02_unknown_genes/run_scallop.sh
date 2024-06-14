nextflow run \
        ~/Documents/GitHub/RNA_seq/scallop/scallop.nf \
        -profile local \
        -resume \
        -w /Users/marieke/Documents/nf-work \
        --out_dir /Volumes/INTENSO/02_TNBC/tmp \
        --in_reads '/Volumes/INTENSO/02_TNBC/data/*/**{_trimmed_R1,_trimmed_R2,trimmed.R1,trimmed.R2}.fastq.gz'