#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 01:00:00
#SBATCH -J prokka
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load prokka/1.14.5-gompi-2024a

mkdir -p ~/genome_analysis/analyses/04_annotation/

prokka \
    --outdir ~/genome_analysis/analyses/04_annotation/ \
    --prefix efaecium_e745 \
    --genus Enterococcus \
    --species faecium \
    --strain E745 \
    --cpus 2 \
    ~/genome_analysis/analyses/02_assembly/canu/efaecium_e745.contigs.fasta
