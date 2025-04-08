#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J Quality_control_trim
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load FastQC

for file in Analyses/1_preprocessing/DNA_trimmed_data/*_paired.fq.gz; do
    filename=$(basename "$file" .fq.gz)
    folder="output_${filename}"
    output_dir=Analyses/1_preprocessing/fastQC_DNA_trim/"$folder"

    mkdir -p "$output_dir"
    fastqc -o "$output_dir" "$file"
done

for file in Analyses/1_preprocessing/RNA_trimmed_data/*/*_paired.fq.gz; do
    filename=$(basename "$file" .fq.gz)
    folder="output_${filename}"
    output_dir=Analyses/1_preprocessing/fastQC_RNA_trim/"$folder"

    mkdir -p "$output_dir"
    fastqc -o "$output_dir" "$file"
done



