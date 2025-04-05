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
    folder="output_${file%%.fastq.gz}"
    mkdir ~/Genome_Analysis_Lab/Analyses/1_preprocessing/fastQC_DNA_raw/"$folder"
    fastqc -o ~/Genome_Analysis_Lab/Analyses/1_preprocessing/fastQC_DNA_raw/"$folder" file
done
