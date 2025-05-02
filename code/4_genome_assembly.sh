#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH -J Genome_Assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load Flye

mkdir -p Analyses/2_Genome_Assembly/1_Flye_output/

flye --nano-raw DATA/raw_data/DNA_long_reads/SRR24413066.fastq.gz \
    --out-dir Analyses/2_Genome_Assembly/1_Flye_output/ -t 2
