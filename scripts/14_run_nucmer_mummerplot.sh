#!/usr/bin/env bash

#SBATCH --job-name=nucmer
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=08:00:00
#SBATCH --array=0-5
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/nucmer_%A_%a.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/nucmer_%A_%a.e

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
CONTAINER="/containers/apptainer/mummer4_gnuplot.sif"

TAIR10="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
FLYE="${WORKDIR}/assemblies/flye/assembly.fasta"
HIFIASM="${WORKDIR}/assemblies/hifiasm/Co-4_hifiasm_primary.fa"
LJA="${WORKDIR}/assemblies/lja/assembly.fasta"

case "$SLURM_ARRAY_TASK_ID" in
    0)
        NAME="tair10_vs_flye"
        REFERENCE="$TAIR10"
        QUERY="$FLYE"
        ;;
    1)
        NAME="tair10_vs_hifiasm"
        REFERENCE="$TAIR10"
        QUERY="$HIFIASM"
        ;;
    2)
        NAME="tair10_vs_lja"
        REFERENCE="$TAIR10"
        QUERY="$LJA"
        ;;
    3)
        NAME="flye_vs_hifiasm"
        REFERENCE="$FLYE"
        QUERY="$HIFIASM"
        ;;
    4)
        NAME="flye_vs_lja"
        REFERENCE="$FLYE"
        QUERY="$LJA"
        ;;
    5)
        NAME="hifiasm_vs_lja"
        REFERENCE="$HIFIASM"
        QUERY="$LJA"
        ;;
esac

OUTDIR="${WORKDIR}/assembly_evaluation/mummer/${NAME}"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

apptainer exec \
    --bind /data \
    "$CONTAINER" \
    nucmer \
    --prefix="$NAME" \
    --breaklen 1000 \
    --mincluster 1000 \
    "$REFERENCE" \
    "$QUERY"

apptainer exec \
    --bind /data \
    "$CONTAINER" \
    mummerplot \
    -R "$REFERENCE" \
    -Q "$QUERY" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    --prefix="$NAME" \
    "${NAME}.delta"
