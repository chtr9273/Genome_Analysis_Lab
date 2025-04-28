#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J rna_map
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load samtools
module load bwa

bwa index Analyses/2_Genome_Assembly/3_polishing/pilon_output.fasta

for file in DATA/raw_data/RNA_short_reads/*1.fastq.gz; do
    file_basename=$(basename "$file")
    file_prefix="${file_basename%%_*}"
    
    file1=$file
    file2=DATA/raw_data/RNA_short_reads/${file_prefix}_2.fastq.gz

    bwa mem -t 2 Analyses/2_Genome_Assembly/3_polishing/pilon_output.fasta \
        $file1 \
        $file2 \
        | samtools sort -o /proj/uppmax2025-3-3/nobackup/work/Christos/${file_prefix}aligned.bam

    samtools index /proj/uppmax2025-3-3/nobackup/work/Christos/${file_prefix}aligned.bam
done



    
