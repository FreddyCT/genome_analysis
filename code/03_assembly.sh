#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 4
#SBATCH -t 05:00:00
#SBATCH -J canu_assembly
#SBATCH --mail-type=ALL
#SBATCH --output=~/genome_analysis/analyses/02_assembly/%x.%j.out

module load canu/2.3-GCCcore-13.3.0-Java-17

mkdir -p ~/genome_analysis/analyses/02_assembly/canu/

canu \
    -p efaecium_e745 \
    -d ~/genome_analysis/analyses/02_assembly/canu/ \
    genomeSize=3m \
    maxThreads=4 \
    useGrid=false \
    -pacbio ~/genome_analysis/data/raw_data/DNA/*.fastq.gz
