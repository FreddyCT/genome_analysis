#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 06:00:00
#SBATCH -J trimmomatic
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load Trimmomatic/0.39-Java-17

mkdir -p ~/genome_analysis/data/trimmed_data/

INDIR=~/genome_analysis/data/raw_data/RNA
OUTDIR=~/genome_analysis/data/trimmed_data

# Serum samples — note _pass_ in filename
for sample in ERR1797969 ERR1797970 ERR1797971; do
    trimmomatic PE -threads 2 \
        $INDIR/${sample}_pass_1.fastq.gz \
        $INDIR/${sample}_pass_2.fastq.gz \
        $OUTDIR/${sample}_1_paired.fastq.gz \
        $OUTDIR/${sample}_1_unpaired.fastq.gz \
        $OUTDIR/${sample}_2_paired.fastq.gz \
        $OUTDIR/${sample}_2_unpaired.fastq.gz \
        ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done

# BHI samples — note no _pass_ in filename
for sample in ERR1797972 ERR1797973 ERR1797974; do
    trimmomatic PE -threads 2 \
        $INDIR/${sample}_1.fastq.gz \
        $INDIR/${sample}_2.fastq.gz \
        $OUTDIR/${sample}_1_paired.fastq.gz \
        $OUTDIR/${sample}_1_unpaired.fastq.gz \
        $OUTDIR/${sample}_2_paired.fastq.gz \
        $OUTDIR/${sample}_2_unpaired.fastq.gz \
        ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done
