#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=trinity
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/trinity_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/trinity_%j.e

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
READDIR="${WORKDIR}/read_QC/fastp/RNAseq_Sha"
LEFT="${READDIR}/ERR754081_1.trimmed.fastq.gz"
RIGHT="${READDIR}/ERR754081_2.trimmed.fastq.gz"
OUTDIR="${WORKDIR}/assemblies/Trinity"

mkdir -p "${WORKDIR}/assemblies"

module load Trinity/2.15.1-foss-2021a

Trinity \
    --seqType fq \
    --max_memory 60G \
    --CPU "$SLURM_CPUS_PER_TASK" \
    --left "$LEFT" \
    --right "$RIGHT" \
    --output "$OUTDIR"
