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

<img width="400" height="1198" alt="bild" src="https://github.com/user-attachments/assets/f825b147-136b-465b-a736-6e90e78b4ae6" /> <br>

## Repository Structure <br>
```
.
├── README.md
├── analyses/
│   ├── 01_qc/
│   ├── 02_assembly/
│   ├── 03_assembly_eval/
│   ├── 04_annotation/
│   ├── 05_synteny/
│   ├── 06_rna_mapping/
│   ├── 07_counting/
│   └── 08_deseq2
├── code/
│   ├── 01_qc.sh
│   ├── 02_trimming.sh
│   ├── 03_assembly.sh
│   ├── 04_assembly_eval.sh
│   ├── 05_annotation.sh
│   ├── 06_synteny.sh
│   ├── 07_rna_mapping.sh
│   ├── 08_htseq.sh
│   └── 09_deseq2.R
└── data/
    ├── metadata/ 
    │	└──sample_information.csv
    ├── raw_data/
    │   ├── DNA/
    │   └── RNA/
    └── trimmed_data/
```
