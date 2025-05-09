#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 0:30:00
#SBATCH -J Trimming_DNA
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load trimmomatic

output_dir=Analyses/1_preprocessing/DNA_trimmed_data
mkdir -p "$output_dir" 

trimmomatic PE \
    DATA/raw_data/DNA_short_reads/SRR24413065_1.fastq.gz DATA/raw_data/DNA_short_reads/SRR24413065_2.fastq.gz \
    "$output_dir"/out_DNA1_paired.fq.gz "$output_dir"/out_DNA1_unpaired.fq.gz \
    "$output_dir"/out_DNA2_paired.fq.gz "$output_dir"/out_DNA2_unpaired.fq.gz \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:50

