Commands used to search for manY_2 in my autoannotation (Prokka)

wget -O ~/genome_analysis/data/reference/CP014529_proteins.faa \
    "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP014529&rettype=fasta_cds_aa&retmode=text"

#To find the sequence
grep -A5 "manY" ~/genome_analysis/data/reference/CP014529_proteins.faa

#Create file (fasta formated) and paste the sequence
nano manY2.faa

module load BLAST+/2.17.0-gompi-2024a

#Create my db from my annotation
makeblastdb \
    -in ~/genome_analysis/analyses/04_annotation/efaecium_e745.faa \
    -dbtype prot \
    -out ~/genome_analysis/extra_analyses/efaecium_e745_prot_db

#Blast manY_2 against the db
blastp \
    -query manY2.faa \
    -db ~/genome_analysis/extra_analyses/efaecium_e745_prot_db \
    -outfmt 6 \
    -evalue 1e-5 \
    -out manY2_results.txt

cat manY2_results.txt

manY_2  AENJPLPP_02100  100.000 267     0       0       1       267     1       267     0.0     514
manY_2  AENJPLPP_02959  30.328  244     162     3       21      263     21      257     1.30e-40        137
manY_2  AENJPLPP_02317  26.667  240     172     2       3       241     2       238     8.01e-28        104
manY_2  AENJPLPP_02944  29.952  207     128     6       39      237     1       198     1.58e-23        91.7
manY_2  AENJPLPP_01705  24.528  265     181     5       1       257     3       256     2.02e-20        84.3
manY_2  AENJPLPP_02033  30.660  212     139     5       29      237     28      234     1.67e-19        82.0
manY_2  AENJPLPP_02715  25.616  203     147     2       42      243     2       201     3.98e-19        80.1
manY_2  AENJPLPP_00292  21.519  237     172     6       28      254     34      266     2.61e-07        47.0

#manY_2 is named AENJPLPP_02100
