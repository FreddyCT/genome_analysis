#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:05:00
#SBATCH -J synteny_blast
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load BLAST+/2.17.0-gompi-2024a

mkdir -p ~/genome_analysis/analyses/05_synteny/

QUERY=~/genome_analysis/analyses/02_assembly/canu/efaecium_e745.contigs.fasta
REFERENCE=~/genome_analysis/data/reference/Aus0004.fasta
OUTDIR=~/genome_analysis/analyses/05_synteny/

makeblastdb \
    -in $REFERENCE \
    -dbtype nucl \
    -out $OUTDIR/Aus0004_db

blastn \
    -query $QUERY \
    -db $OUTDIR/Aus0004_db \
    -outfmt 6 \
    -out $OUTDIR/e745_vs_Aus0004.blast \
    -num_threads 2 \
    -evalue 1e-5
