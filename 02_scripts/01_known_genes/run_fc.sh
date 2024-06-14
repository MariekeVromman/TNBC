nextflow run \
        ~/Documents/GitHub/RNA_seq/fc/fc.nf \
        -profile local,arm \
        -w /Users/marieke/Documents/nf-work \
        -resume e53a588b-06a0-4444-b8e3-0940ccfc7c38 \
        --out_dir /Volumes/INTENSO/ \
        --in_bam '/Volumes/INTENSO/02_TNBC/pt_samples/01_STAR/*/*{sorted.bam,_STAR.out}'
