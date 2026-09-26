#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=flye
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/flye_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/flye_%j.e

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
READDIR="/data/courses/assembly-annotation-course/raw_data/Co-4"
READS="${READDIR}/ERR11437315.fastq.gz"
OUTDIR="${WORKDIR}/assemblies/flye"
CONTAINER="/containers/apptainer/flye_2.9.5.sif"

mkdir -p "${WORKDIR}/assemblies"

apptainer exec \
    --bind "$WORKDIR" \
    --bind "$READDIR" \
    "$CONTAINER" \
    flye \
    --pacbio-hifi "$READS" \
    --out-dir "$OUTDIR" \
    --threads "$SLURM_CPUS_PER_TASK"
