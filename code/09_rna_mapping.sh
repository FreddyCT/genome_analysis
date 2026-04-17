#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 2
#SBATCH -t 05:00:00
#SBATCH -J rna_mapping
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load BWA/0.7.19-GCCcore-13.3.0
module load SAMtools/1.22.1-GCC-13.3.0

set -euo pipefail

GENOME=~/genome_analysis/analyses/04_annotation/efaecium_e745.fna
TRIMMED=/proj/uppmax2026-1-61/nobackup/chiki/trimmed_data
OUTDIR=/proj/uppmax2026-1-61/nobackup/chiki/rna_mapping

mkdir -p $OUTDIR

bwa index $GENOME

# Map all samples (Serum and BHI)
for sample in ERR1797969 ERR1797970 ERR1797971 ERR1797972 ERR1797973 ERR1797974; do
    echo "Mapping $sample"
    bwa mem -t 2 $GENOME \
        $TRIMMED/${sample}_1_paired.fastq.gz \
        $TRIMMED/${sample}_2_paired.fastq.gz \
        | samtools sort -@ 2 -o $OUTDIR/${sample}.sorted.bam

    echo "Indexing $sample BAM"
    samtools index $OUTDIR/${sample}.sorted.bam

    echo "Flagstat for $sample, for quick stats"
    samtools flagstat $OUTDIR/${sample}.sorted.bam \
        > $OUTDIR/${sample}.flagstat.txt

    echo "Done with $sample"
done

echo "Script finished"
