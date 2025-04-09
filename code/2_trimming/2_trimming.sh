#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J Trimming_RNA_and_DNA
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
    ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE.fa:2:30:10 LEADING:15 TRAILING:15 SLIDINGWINDOW:4:20 MINLEN:150

for file in DATA/raw_data/RNA_short_reads/*1.fastq.gz; do
    name_without_prefix=$(basename "$file" .fastq.gz | sed 's/_1$//')
    folder="output_${name_without_prefix}"
    output_dir=Analyses/1_preprocessing/RNA_trimmed_data/"$folder"
    
    mkdir -p "$output_dir"
    trimmomatic PE \
        $file DATA/raw_data/RNA_short_reads/"${name_without_prefix}_2.fastq.gz" \
        "$output_dir"/"out_${name_without_prefix}_1_paired.fq.gz" "$output_dir"/"out_${name_without_prefix}_1_unpaired.fq.gz" \
        "$output_dir"/"out_${name_without_prefix}_2_paired.fq.gz" "$output_dir"/out_${name_without_prefix}_2_unpaired.fq.gz \
        ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE.fa:2:30:10 TRAILING:3 SLIDINGWINDOW:4:15 \
  
done
