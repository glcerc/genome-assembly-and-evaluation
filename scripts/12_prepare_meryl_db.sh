#!/usr/bin/env bash

#SBATCH --job-name=meryl
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=08:00:00
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/meryl_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/meryl_%j.e

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
READS="${WORKDIR}/Co-4/ERR11437315.fastq.gz"
OUTDIR="${WORKDIR}/assembly_evaluation/merqury"
CONTAINER="/containers/apptainer/merqury_1.3.sif"
K=18

mkdir -p "$OUTDIR"

apptainer exec \
    --bind /data \
    "$CONTAINER" \
    meryl \
    k="$K" \
    count \
    threads="$SLURM_CPUS_PER_TASK" \
    memory=64 \
    output "${OUTDIR}/Co-4_k${K}.meryl" \
    "$READS"
