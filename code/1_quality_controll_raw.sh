#!/bin/bash -l
#SBATCH -A uppmax2025-3-3_1
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J Quality_controll_raw
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@sudent.uu.se
#SBATCH --output=~/Genome_Analysis_Lab/code/0_output%x.%j.out

module load bioinfo-tools
module load FastQC

for file in ~/Genome_Analysis_Lab/DATA/raw_data/DNA_short_reads/*.fastq.gz; do
    filename=$(basename "$file" .fastq.gz)
    folder="output_${filename}"
    output_dir=~/Genome_Analysis_Lab/Analyses/1_preprocessing/fastQC_DNA_raw/"$folder"
    
    mkdir -p "$output_dir"
    fastqc -o "$output_dir" "$file"
done

for file in ~/Genome_Analysis_Lab/DATA/raw_data/RNA_short_reads/*.fastq.gz; do
    filename=$(basename "$file" .fastq.gz)
    folder="output_${filename}"
    output_dir=~/Genome_Analysis_Lab/Analyses/1_preprocessing/fastQC_RNA_raw/"$folder"
    
    mkdir -p "$output_dir"
    fastqc -o "$output_dir" "$file"
done
