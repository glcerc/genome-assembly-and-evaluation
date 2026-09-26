#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=hifiasm
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/hifiasm_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/hifiasm_%j.e

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
READDIR="/data/courses/assembly-annotation-course/raw_data/Co-4"
READS="${READDIR}/ERR11437315.fastq.gz"
OUTDIR="${WORKDIR}/assemblies/hifiasm"
PREFIX="${OUTDIR}/Co-4_hifiasm"
CONTAINER="/containers/apptainer/hifiasm_0.25.0.sif"

mkdir -p "$OUTDIR"

apptainer exec \
    --bind "$WORKDIR" \
    --bind "$READDIR" \
    "$CONTAINER" \
    hifiasm \
    -o "$PREFIX" \
    -t "$SLURM_CPUS_PER_TASK" \
    "$READS"

awk '/^S/{print ">"$2; print $3}' \
    "${PREFIX}.bp.p_ctg.gfa" \
    > "${OUTDIR}/Co-4_hifiasm_primary.fa"
