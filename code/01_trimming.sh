#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 05:00:00
#SBATCH -J trimmomatic
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load Trimmomatic/0.39-Java-17

INDIR=~/genome_analysis/data/raw_data/RNA
OUTDIR=~/genome_analysis/data/trimmed_data #Change directory to nobackup
ADAPTERS=~/genome_analysis/data/adapters/TruSeq3-PE.fa

mkdir -p $OUTDIR

# First 3 = Serum samples, Last 3 = BHI samples
for sample in ERR1797969 ERR1797970 ERR1797971 ERR1797972 ERR1797973 ERR1797974; do
    echo "Processing $sample..."
    trimmomatic PE -threads 2 \
        $INDIR/${sample}_1.fastq.gz \
        $INDIR/${sample}_2.fastq.gz \
        $OUTDIR/${sample}_1_paired.fastq.gz \
        $OUTDIR/${sample}_1_unpaired.fastq.gz \
        $OUTDIR/${sample}_2_paired.fastq.gz \
        $OUTDIR/${sample}_2_unpaired.fastq.gz \
        ILLUMINACLIP:${ADAPTERS}:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    echo "Done with $sample"
done
