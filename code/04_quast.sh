#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -t 00:20:00
#SBATCH -J quast
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load QUAST/5.3.0

mkdir -p ~/genome_analysis/analyses/03_assembly_eval/quast/

ASSEMBLY=~/genome_analysis/analyses/02_assembly/canu/efaecium_e745.contigs.fasta
REFERENCE=~/genome_analysis/data/reference/CP014529_chromosome.fasta

quast.py $ASSEMBLY \
    -r $REFERENCE \
    -o ~/genome_analysis/analyses/03_assembly_eval/quast/
