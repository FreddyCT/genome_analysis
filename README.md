# genome_analysis
Pipeline for re-analysis of core methods in Paper 1 Zhang et al. 2017<br>

```
Covers:
- Genome assembly of *E. faecium* E745 (PacBio long-reads)
- Assembly evaluation + annotation
- Synteny comparision
- Trimming
- RNA-Seq DE between serum and BHI medium
```

<img width="400" height="600" alt="bild" src="https://github.com/user-attachments/assets/f825b147-136b-465b-a736-6e90e78b4ae6" /> <br>

## Repository Structure <br>
```
.
├── README.md
├── analyses/
│   ├── 01_qc/
│   │   ├── fastqc_raw/
│   │   └── fastqc_trimmed/
│   ├── 02_assembly/
│   │   └── canu/
│   ├── 03_assembly_eval/
│   │   ├── busco/
│   │   ├── quast/
│   │   └── mummer/
│   ├── 04_annotation/
│   ├── 05_synteny/
│   ├── 06_rna_mapping/
│   ├── 07_counting/
│   └── 08_deseq2
├── code/
└── data/
    ├── adapters/
    ├── bam_files/
    ├── metadata/ 
    │	└──sample_information.csv
    ├── raw_data/
    │   ├── DNA/
    │   └── RNA/
    ├── reference/
    │   └──CP014529_chromosome.fasta
    └── trimmed_data/
```
