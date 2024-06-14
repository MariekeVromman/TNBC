#!/bin/bash
#Torque Configuration
#PBS -l walltime=01:00:00
#PBS -l mem=8gb
#PBS -l nodes=1:ppn=1
#PBS -q batch
#PBS -N copy_data
#PBS -j oe
#PBS -o /data/tmp/mvromman/download_ref.txt

# download and unzip Gencode genome fasta file

cd /data/tmp/mvromman/20240311_run/references
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/GRCh38.p14.genome.fa.gz
gunzip GRCh38.p14.genome.fa.gz

# download and unzip Gencode gtf file

wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.chr_patch_hapl_scaff.annotation.gtf.gz
gunzip gencode.v44.chr_patch_hapl_scaff.annotation.gtf.gz