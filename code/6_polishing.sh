#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J polishing
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load bwa
module load samtools
module load Pilon

bwa index Analyses/2_Genome_Assembly/1_Flye_output/assembly.fasta

bwa mem -t 2 Analyses/2_Genome_Assembly/1_Flye_output/assembly.fasta \
    Analyses/1_preprocessing/DNA_trimmed_data/out_DNA1_paired.fq.gz \
    Analyses/1_preprocessing/DNA_trimmed_data/out_DNA2_paired.fq.gz \
    | samtools sort -o /proj/uppmax2025-3-3/nobackup/work/Christos/aligned.bam
    

samtools index /proj/uppmax2025-3-3/nobackup/work/Christos/aligned.bam

mkdir mkdir -p Analyses/2_Genome_Assembly/3_polishing/pilon_output

java -jar $PILON_HOME/pilon.jar \
  --genome Analyses/2_Genome_Assembly/1_Flye_output/assembly.fasta \
  --frags /proj/uppmax2025-3-3/nobackup/work/Christos/aligned.bam \
  --output Analyses/2_Genome_Assembly/3_polishing/pilon_output \
  --threads 2 \
  --changes
