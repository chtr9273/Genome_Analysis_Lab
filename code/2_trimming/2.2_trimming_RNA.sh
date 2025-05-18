#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 0:30:00
#SBATCH -J Trimming_RNA
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load FastQC
module load trimmomatic

for file in DATA/raw_data/RNA_short_reads/*1.fastq.gz; do
    name_without_prefix=$(basename "$file" .fastq.gz | sed 's/_1$//')
    folder="output_${name_without_prefix}"
    output_dir=Analyses/1_preprocessing/RNA_trimmed_data/"$folder"
    
    mkdir -p "$output_dir"
    trimmomatic PE \
        $file DATA/raw_data/RNA_short_reads/"${name_without_prefix}_2.fastq.gz" \
        "$output_dir"/"out_${name_without_prefix}_1_paired.fq.gz" "$output_dir"/"out_${name_without_prefix}_1_unpaired.fq.gz" \
        "$output_dir"/"out_${name_without_prefix}_2_paired.fq.gz" "$output_dir"/out_${name_without_prefix}_2_unpaired.fq.gz \
        ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:20 SLIDINGWINDOW:4:20 \
	MINLEN:25
  
done

for file in Analyses/1_preprocessing/RNA_trimmed_data/*/*_paired.fq.gz; do
    filename=$(basename "$file" .fq.gz)
    folder="output_${filename}"
    output_dir=Analyses/1_preprocessing/fastQC_RNA_trim/"$folder"

    mkdir -p "$output_dir"
    fastqc -o "$output_dir" "$file"
done
