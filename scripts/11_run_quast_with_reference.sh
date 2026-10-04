#!/usr/bin/env bash

#SBATCH --time=08:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=quast_ref
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/quast_ref_%j.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/quast_ref_%j.e

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
REFDIR="/data/courses/assembly-annotation-course/references"

FLYE="${WORKDIR}/assemblies/flye/assembly.fasta"
HIFIASM="${WORKDIR}/assemblies/hifiasm/Co-4_hifiasm_primary.fa"
LJA="${WORKDIR}/assemblies/lja/assembly.fasta"

REFERENCE="${REFDIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
ANNOTATION="${REFDIR}/Arabidopsis_thaliana.TAIR10.57.gff3"

OUTDIR="${WORKDIR}/assembly_evaluation/quast/with_reference"
CONTAINER="/containers/apptainer/quast_5.2.0.sif"

mkdir -p "${WORKDIR}/assembly_evaluation/quast"

apptainer exec \
    --bind "$WORKDIR" \
    --bind "$REFDIR" \
    "$CONTAINER" \
    quast.py \
    "$FLYE" "$HIFIASM" "$LJA" \
    --labels "Flye,Hifiasm,LJA" \
    --eukaryote \
    --large \
    --threads "$SLURM_CPUS_PER_TASK" \
    --reference "$REFERENCE" \
    --features "gene:${ANNOTATION}" \
    --output-dir "$OUTDIR"
