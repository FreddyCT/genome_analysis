#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:10:00
#SBATCH -J busco
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load BUSCO/5.8.2-gfbf-2024a

ASSEMBLY=~/genome_analysis/analyses/02_assembly/canu/efaecium_e745.contigs.fasta
OUTDIR=~/genome_analysis/analyses/03_assembly_eval/busco/

mkdir -p $OUTDIR

busco \
  -i $ASSEMBLY \
  -o busco_efaecium_e745 \
  -l enterococcus_odb12 \
  -m genome \
  -c 2 \
  --out_path $OUTDIR
