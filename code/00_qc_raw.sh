#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 00:15:00
#SBATCH -J fastqc_raw
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load FastQC/0.12.1-Java-17
module load MultiQC/1.28-foss-2024a

mkdir -p ~/genome_analysis/analyses/01_qc/fastqc_raw/

# Run FastQC on all raw RNA-Seq files
fastqc -t 2 \
    -o ~/genome_analysis/analyses/01_qc/fastqc_raw/ \
    ~/genome_analysis/data/raw_data/RNA/*.fastq.gz

# Combine all reports into one
multiqc ~/genome_analysis/analyses/01_qc/fastqc_raw/ \
    -o ~/genome_analysis/analyses/01_qc/fastqc_raw/multiqc/
