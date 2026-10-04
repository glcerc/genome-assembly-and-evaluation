#!/usr/bin/env bash

#SBATCH --time=08:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=quast_no_ref
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/quast_no_ref_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/quast_no_ref_%j.e

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
FLYE="${WORKDIR}/assemblies/flye/assembly.fasta"
HIFIASM="${WORKDIR}/assemblies/hifiasm/Co-4_hifiasm_primary.fa"
LJA="${WORKDIR}/assemblies/lja/assembly.fasta"
OUTDIR="${WORKDIR}/assembly_evaluation/quast/no_reference"
CONTAINER="/containers/apptainer/quast_5.2.0.sif"

mkdir -p "${WORKDIR}/assembly_evaluation/quast"

apptainer exec \
    --bind "$WORKDIR" \
    "$CONTAINER" \
    quast.py \
    "$FLYE" "$HIFIASM" "$LJA" \
    --labels "Flye,Hifiasm,LJA" \
    --eukaryote \
    --large \
    --est-ref-size 135000000 \
    --threads "$SLURM_CPUS_PER_TASK" \
    --output-dir "$OUTDIR"
