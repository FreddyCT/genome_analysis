#!/bin/bash -l
#SBATCH -A uppmax2026-1-61
#SBATCH -p pelle
#SBATCH -c 1
#SBATCH -t 05:00:00
#SBATCH -J htseq
#SBATCH --mail-type=ALL
#SBATCH --output=%x.%j.out

module load HTSeq/2.1.2-gfbf-2024a

GFF=~/genome_analysis/analyses/04_annotation/efaecium_e745_clean.gff
BAMDIR=~/genome_analysis/data/bam_files
OUTDIR=~/genome_analysis/analyses/07_counting

mkdir -p $OUTDIR

for sample in ERR1797969 ERR1797970 ERR1797971 ERR1797972 ERR1797973 ERR1797974; do
    echo "Counting $sample"
    htseq-count \
        --format bam \
        --order pos \
        --stranded no \
        --type CDS \
        --idattr ID \
        --additional-attr gene \
        --additional-attr product \
        $BAMDIR/${sample}.sorted.bam \
        $GFF \
        > $OUTDIR/${sample}_counts.txt
    echo "Done with $sample"
done

echo "All samples counted"
