#!/usr/bin/env bash

#SBATCH --job-name=merqury
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=08:00:00
#SBATCH --array=0-2
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/merqury_%A_%a.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/merqury_%A_%a.e

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
MERYLDB="${WORKDIR}/assembly_evaluation/merqury/Co-4_k18.meryl"
CONTAINER="/containers/apptainer/merqury_1.3.sif"
export MERQURY="/usr/local/share/merqury"

case "$SLURM_ARRAY_TASK_ID" in
    0)
        NAME="flye"
        ASSEMBLY="${WORKDIR}/assemblies/flye/assembly.fasta"
        ;;
    1)
        NAME="hifiasm"
        ASSEMBLY="${WORKDIR}/assemblies/hifiasm/Co-4_hifiasm_primary.fa"
        ;;
    2)
        NAME="lja"
        ASSEMBLY="${WORKDIR}/assemblies/lja/assembly.fasta"
        ;;
esac

OUTDIR="${WORKDIR}/assembly_evaluation/merqury/${NAME}"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

apptainer exec \
    --bind /data \
    "$CONTAINER" \
    "$MERQURY/merqury.sh" \
    "$MERYLDB" \
    "$ASSEMBLY" \
    "$NAME"
