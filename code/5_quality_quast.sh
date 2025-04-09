#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:30:00
#SBATCH -J Qaust_assembly_controll
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load quast

mkdir -p Analyses/2_Genome_Assembly/2_quast_output/

quast assembly.fasta -o Analyses/2_Genome_Assembly/2_quast_output/ \
	-r DATA/raw_data/reference_genome/HP126_genome.fasta --threads 2

