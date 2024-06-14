#!/bin/bash
#Torque Configuration
#PBS -l walltime=06:00:00
#PBS -l mem=16gb
#PBS -l nodes=1:ppn=1
#PBS -q batch
#PBS -N copy_data
#PBS -j oe
#PBS -o /data/tmp/mvromman/copy_data.txt


# make all the dirs
mkdir /data/tmp/mvromman/20240311_run/data/D1472T01
mkdir /data/tmp/mvromman/20240311_run/data/D1472T02
mkdir /data/tmp/mvromman/20240311_run/data/D1472T03
mkdir /data/tmp/mvromman/20240311_run/data/D1472T04
mkdir /data/tmp/mvromman/20240311_run/data/D1472T05
mkdir /data/tmp/mvromman/20240311_run/data/D1472T06
mkdir /data/tmp/mvromman/20240311_run/data/D1472T07
mkdir /data/tmp/mvromman/20240311_run/data/D1472T08
mkdir /data/tmp/mvromman/20240311_run/data/D1472T09
mkdir /data/tmp/mvromman/20240311_run/data/D1472T10
mkdir /data/tmp/mvromman/20240311_run/data/D1472T11
mkdir /data/tmp/mvromman/20240311_run/data/D1472T12
mkdir /data/tmp/mvromman/20240311_run/data/D1472T13
mkdir /data/tmp/mvromman/20240311_run/data/D1472T14
mkdir /data/tmp/mvromman/20240311_run/data/D1472T15
mkdir /data/tmp/mvromman/20240311_run/data/D1472T16
mkdir /data/tmp/mvromman/20240311_run/data/D1472T17
mkdir /data/tmp/mvromman/20240311_run/data/D1472T18
mkdir /data/tmp/mvromman/20240311_run/data/D1472T19
mkdir /data/tmp/mvromman/20240311_run/data/D1472T20
mkdir /data/tmp/mvromman/20240311_run/data/D1472T21
mkdir /data/tmp/mvromman/20240311_run/data/D1472T22
mkdir /data/tmp/mvromman/20240311_run/data/D1472T23
mkdir /data/tmp/mvromman/20240311_run/data/D1472T24
mkdir /data/tmp/mvromman/20240311_run/data/D1472T25
mkdir /data/tmp/mvromman/20240311_run/data/D1472T26
mkdir /data/tmp/mvromman/20240311_run/data/D1472T27
mkdir /data/tmp/mvromman/20240311_run/data/D1472T28
mkdir /data/tmp/mvromman/20240311_run/data/D1472T29
mkdir /data/tmp/mvromman/20240311_run/data/D1472T30
mkdir /data/tmp/mvromman/20240311_run/data/D1472T31
mkdir /data/tmp/mvromman/20240311_run/data/D1472T32
mkdir /data/tmp/mvromman/20240311_run/data/D1472T33
mkdir /data/tmp/mvromman/20240311_run/data/D1472T34
mkdir /data/tmp/mvromman/20240311_run/data/D1472T35
mkdir /data/tmp/mvromman/20240311_run/data/D1472T36
mkdir /data/tmp/mvromman/20240311_run/data/D1472T37
mkdir /data/tmp/mvromman/20240311_run/data/D1472T38
mkdir /data/tmp/mvromman/20240311_run/data/D1472T39
mkdir /data/tmp/mvromman/20240311_run/data/D1472T40
mkdir /data/tmp/mvromman/20240311_run/data/D1472T41
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T33
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T34
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T35
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T39
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T40
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T41
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T42
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T43
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T44
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T45
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T46
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T47
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T48
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T49
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T50
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T51
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T52
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T53
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T56
mkdir /data/tmp/mvromman/20240311_run/data/D307-D303T57
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T25
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T26
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T27
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T28
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T29
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T35
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T36
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T38
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T39
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T40
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T42
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T43
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T44
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T45
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T46
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T47
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T48
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T49
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T50
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T51
mkdir /data/tmp/mvromman/20240311_run/data/D492-D485T52
mkdir /data/tmp/mvromman/20240311_run/data/D886T01
mkdir /data/tmp/mvromman/20240311_run/data/D886T03

# 41 EV samples
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T01/D1472T01.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T01/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T01/D1472T01.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T01/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T02/D1472T02.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T02/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T02/D1472T02.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T02/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T03/D1472T03.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T03/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T03/D1472T03.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T03/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T04/D1472T04.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T04/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T04/D1472T04.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T04/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T05/D1472T05.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T05/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T05/D1472T05.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T05/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T06/D1472T06.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T06/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T06/D1472T06.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T06/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T07/D1472T07.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T07/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T07/D1472T07.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T07/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T08/D1472T08.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T08/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T08/D1472T08.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T08/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T09/D1472T09.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T09/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T09/D1472T09.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T09/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T10/D1472T10.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T10/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T10/D1472T10.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T10/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T11/D1472T11.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T11/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T11/D1472T11.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T11/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T12/D1472T12.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T12/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T12/D1472T12.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T12/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T13/D1472T13.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T13/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T13/D1472T13.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T13/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T14/D1472T14.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T14/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T14/D1472T14.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T14/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T15/D1472T15.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T15/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T15/D1472T15.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T15/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T16/D1472T16.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T16/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T16/D1472T16.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T16/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T17/D1472T17.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T17/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T17/D1472T17.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T17/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T18/D1472T18.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T18/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T18/D1472T18.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T18/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T19/D1472T19.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T19/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T19/D1472T19.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T19/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T20/D1472T20.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T20/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T20/D1472T20.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T20/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T21/D1472T21.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T21/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T21/D1472T21.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T21/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T22/D1472T22.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T22/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T22/D1472T22.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T22/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T23/D1472T23.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T23/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T23/D1472T23.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T23/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T24/D1472T24.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T24/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T24/D1472T24.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T24/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T25/D1472T25.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T25/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T25/D1472T25.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T25/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T26/D1472T26.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T26/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T26/D1472T26.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T26/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T27/D1472T27.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T27/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T27/D1472T27.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T27/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T28/D1472T28.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T28/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T28/D1472T28.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T28/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T29/D1472T29.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T29/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T29/D1472T29.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T29/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T30/D1472T30.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T30/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T30/D1472T30.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T30/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T31/D1472T31.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T31/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T31/D1472T31.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T31/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T32/D1472T32.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T32/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T32/D1472T32.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T32/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T33/D1472T33.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T33/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T33/D1472T33.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T33/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T34/D1472T34.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T34/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T34/D1472T34.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T34/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T35/D1472T35.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T35/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T35/D1472T35.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T35/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T36/D1472T36.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T36/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T36/D1472T36.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T36/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T37/D1472T37.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T37/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T37/D1472T37.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T37/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T38/D1472T38.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T38/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T38/D1472T38.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T38/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T39/D1472T39.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T39/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T39/D1472T39.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T39/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T40/D1472T40.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T40/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T40/D1472T40.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T40/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T41/D1472T41.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T41/
cp /data/kdi_prod/dataset_all/2017725/export/user/D1472T41/D1472T41.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D1472T41/

# 41 tumor samples
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T33/D307-D303T33.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T33/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T33/D307-D303T33.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T33/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T34/D307-D303T34.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T34/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T34/D307-D303T34.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T34/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T35/D307-D303T35.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T35/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T35/D307-D303T35.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T35/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T39/D307-D303T39.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T39/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T39/D307-D303T39.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T39/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T40/D307-D303T40.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T40/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T40/D307-D303T40.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T40/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T41/D307-D303T41.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T41/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T41/D307-D303T41.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T41/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T42/D307-D303T42.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T42/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T42/D307-D303T42.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T42/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T43/D307-D303T43.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T43/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T43/D307-D303T43.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T43/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T44/D307-D303T44.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T44/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T44/D307-D303T44.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T44/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T45/D307-D303T45.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T45/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T45/D307-D303T45.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T45/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T46/D307-D303T46.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T46/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T46/D307-D303T46.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T46/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T47/D307-D303T47.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T47/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T47/D307-D303T47.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T47/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T48/D307-D303T48.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T48/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T48/D307-D303T48.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T48/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T49/D307-D303T49.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T49/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T49/D307-D303T49.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T49/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T50/D307-D303T50.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T50/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T50/D307-D303T50.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T50/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T51/D307-D303T51.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T51/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T51/D307-D303T51.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T51/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T52/D307-D303T52.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T52/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T52/D307-D303T52.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T52/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T53/D307-D303T53.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T53/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T53/D307-D303T53.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T53/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T56/D307-D303T56.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T56/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T56/D307-D303T56.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T56/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T57/D307-D303T57.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T57/
cp /data/kdi_prod/dataset_all/2010807/export/user/D307-D303T57/D307-D303T57.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D307-D303T57/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T25/D492-D485T25.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T25/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T25/D492-D485T25.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T25/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T26/D492-D485T26.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T26/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T26/D492-D485T26.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T26/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T27/D492-D485T27.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T27/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T27/D492-D485T27.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T27/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T28/D492-D485T28.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T28/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T28/D492-D485T28.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T28/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T29/D492-D485T29.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T29/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T29/D492-D485T29.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T29/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T35/D492-D485T35.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T35/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T35/D492-D485T35.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T35/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T36/D492-D485T36.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T36/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T36/D492-D485T36.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T36/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T38/D492-D485T38.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T38/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T38/D492-D485T38.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T38/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T39/D492-D485T39.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T39/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T39/D492-D485T39.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T39/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T40/D492-D485T40.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T40/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T40/D492-D485T40.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T40/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T42/D492-D485T42.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T42/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T42/D492-D485T42.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T42/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T43/D492-D485T43.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T43/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T43/D492-D485T43.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T43/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T44/D492-D485T44.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T44/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T44/D492-D485T44.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T44/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T45/D492-D485T45.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T45/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T45/D492-D485T45.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T45/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T46/D492-D485T46.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T46/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T46/D492-D485T46.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T46/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T47/D492-D485T47.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T47/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T47/D492-D485T47.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T47/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T48/D492-D485T48.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T48/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T48/D492-D485T48.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T48/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T49/D492-D485T49.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T49/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T49/D492-D485T49.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T49/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T50/D492-D485T50.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T50/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T50/D492-D485T50.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T50/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T51/D492-D485T51.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T51/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T51/D492-D485T51.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T51/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T52/D492-D485T52.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T52/
cp /data/kdi_prod/dataset_all/2012490/export/user/D492-D485T52/D492-D485T52.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D492-D485T52/


# cell line EVs and cells

cp /data/kdi_prod/dataset_all/2014817/export/user/D886T01/D886T01.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D886T01/
cp /data/kdi_prod/dataset_all/2014817/export/user/D886T01/D886T01.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D886T01/
cp /data/kdi_prod/dataset_all/2014817/export/user/D886T03/D886T03.R1.fastq.gz /data/tmp/mvromman/20240311_run/data/D886T03/
cp /data/kdi_prod/dataset_all/2014817/export/user/D886T03/D886T03.R2.fastq.gz /data/tmp/mvromman/20240311_run/data/D886T03/