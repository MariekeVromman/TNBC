#!/bin/bash
#Torque Configuration
#PBS -l walltime=36:00:00
#PBS -l mem=16gb
#PBS -l nodes=1:ppn=1
#PBS -q batch
#PBS -N circ_anno
#PBS -j oe
#PBS -o /data/tmp/mvromman/20240311_run/20240325_nf_runner.txt

source ~/.bashrc

# commit d119033
/data/users/mvromman/software/nextflow/nextflow run \
    /data/users/mvromman/github/circrna \
    -profile singularity \
    -c /data/users/mvromman/projects/06_TNBC_circ/20240322_nextflow.config \
    -w /data/tmp/mvromman/20240311_run/nf-work \
    -params-file /data/users/mvromman/projects/06_TNBC_circ/20240311_nf-params_anno.json \
    -resume 6b5b49c3-1b81-4c44-a9fe-b853d87aa35c
