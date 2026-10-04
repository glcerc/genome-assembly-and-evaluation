#!/usr/bin/env bash

#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=busco
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/gercan/assembly_annotation_course/logs/busco_%A_%a.o
#SBATCH --error=/data/users/gercan/assembly_annotation_course/logs/busco_%A_%a.e

set -euo pipefail

WORKDIR="/data/users/gercan/assembly_annotation_course"
OUTROOT="${WORKDIR}/assembly_evaluation/busco"
CONTAINER="/containers/apptainer/busco_5.7.1.sif"
LINEAGE="brassicales_odb10"

case "${SLURM_ARRAY_TASK_ID}" in
    0)
        NAME="flye"
        INPUT="${WORKDIR}/assemblies/flye/assembly.fasta"
        MODE="genome"
        ;;
    1)
        NAME="hifiasm"
        INPUT="${WORKDIR}/assemblies/hifiasm/Co-4_hifiasm_primary.fa"
        MODE="genome"
        ;;
    2)
        NAME="lja"
        INPUT="${WORKDIR}/assemblies/lja/assembly.fasta"
        MODE="genome"
        ;;
    3)
        NAME="trinity"
        INPUT="${WORKDIR}/assemblies/Trinity/Trinity.fasta"
        MODE="transcriptome"
        ;;
    *)
        echo "Invalid array task ID: ${SLURM_ARRAY_TASK_ID}" >&2
        exit 1
        ;;
esac

OUTDIR="${OUTROOT}/${NAME}"
DOWNLOADDIR="${OUTROOT}/downloads_${NAME}"

mkdir -p "$OUTDIR" "$DOWNLOADDIR"

apptainer exec \
    --bind "$WORKDIR" \
    "$CONTAINER" \
    busco \
    -i "$INPUT" \
    -o "${NAME}_busco" \
    --out_path "$OUTDIR" \
    -m "$MODE" \
    -l "$LINEAGE" \
    -c "$SLURM_CPUS_PER_TASK" \
    --download_path "$DOWNLOADDIR"
