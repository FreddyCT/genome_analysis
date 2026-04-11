#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -t 00:10:00
#SBATCH -J mummer
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load MUMmer/4.0.1-GCCcore-13.3.0

mkdir -p ~/genome_analysis/analyses/03_assembly_eval/mummer/

ASSEMBLY=~/genome_analysis/analyses/02_assembly/canu/efaecium_e745.contigs.fasta
REFERENCE=~/genome_analysis/data/reference/CP014529_chromosome.fasta
PREFIX=~/genome_analysis/analyses/03_assembly_eval/mummer/efaecium_vs_reference

nucmer \
    --prefix $PREFIX \
    $REFERENCE \
    $ASSEMBLY

mummerplot \
    --png \
    --large \
    -R $REFERENCE \
    -Q $ASSEMBLY \
    --prefix $PREFIX \
    $PREFIX.delta
