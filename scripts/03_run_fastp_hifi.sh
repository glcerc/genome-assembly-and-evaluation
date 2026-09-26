#!/usr/bin/env bash
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --job-name=fastp_hifi
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/fastp_hifi_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/fastp_hifi_%j.e
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/gercan/assembly_annotation_course
ACCESSION=Co-4
READS=$WORKDIR/$ACCESSION/ERR11437315.fastq.gz
OUTDIR=$WORKDIR/read_QC/fastp/$ACCESSION

mkdir -p $OUTDIR

module load fastp/0.23.4-GCC-10.3.0

fastp \
    -i $READS \
    --disable_adapter_trimming \
    --disable_quality_filtering \
    --disable_length_filtering \
    --disable_trim_poly_g \
    --thread 4 \
    --html $OUTDIR/${ACCESSION}_fastp.html \
    --json $OUTDIR/${ACCESSION}_fastp.json
