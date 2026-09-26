#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=04:00:00
#SBATCH --job-name=jellyfish
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/jellyfish_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/jellyfish_%j.e
#SBATCH --partition=pibu_el8

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
READS="${WORKDIR}/Co-4/ERR11437315.fastq.gz"
OUTDIR="${WORKDIR}/read_QC/kmer_counting"

mkdir -p "$OUTDIR"

module load Jellyfish/2.3.0-GCC-10.3.0

jellyfish count \
    -C \
    -m 21 \
    -s 5G \
    -t 4 \
    -o "${OUTDIR}/Co-4_k21.jf" \
    <(zcat "$READS")

jellyfish histo \
    -t 4 \
    "${OUTDIR}/Co-4_k21.jf" \
    > "${OUTDIR}/Co-4_k21.histo"
