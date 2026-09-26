#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --job-name=fastp_rnaseq
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/fastp_rnaseq_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/fastp_rnaseq_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/gercan/assembly_annotation_course
READS_DIR=$WORKDIR/RNAseq_Sha
OUTDIR=$WORKDIR/read_QC/fastp/RNAseq_Sha

mkdir -p $OUTDIR

module load fastp/0.23.4-GCC-10.3.0

fastp \
    -i $READS_DIR/ERR754081_1.fastq.gz \
    -I $READS_DIR/ERR754081_2.fastq.gz \
    -o $OUTDIR/ERR754081_1.trimmed.fastq.gz \
    -O $OUTDIR/ERR754081_2.trimmed.fastq.gz \
    --detect_adapter_for_pe \
    --thread 4 \
    --html $OUTDIR/RNAseq_Sha_fastp.html \
    --json $OUTDIR/RNAseq_Sha_fastp.json
