#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=04:00:00
#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/fastqc_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/fastqc_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/gercan/assembly_annotation_course
ACCESSION=Co-4
OUTDIR=$WORKDIR/read_QC/fastqc

mkdir -p $OUTDIR

module load FastQC/0.11.9-Java-11

fastqc -t 4 -o $OUTDIR \
    $WORKDIR/$ACCESSION/ERR11437315.fastq.gz \
    $WORKDIR/RNAseq_Sha/ERR754081_1.fastq.gz \
    $WORKDIR/RNAseq_Sha/ERR754081_2.fastq.gz
