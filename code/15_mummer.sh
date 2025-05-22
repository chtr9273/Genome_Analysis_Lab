#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:50:00
#SBATCH -J mummer
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load MUMmer

mkdir -p Analyses/2_Genome_Assembly/comparison/mum_out

nucmer --prefix=Analyses/2_Genome_Assembly/comparison/mum_out/pre_pol \
    DATA/raw_data/reference_genome/HP126_genome.fasta \
    Analyses/2_Genome_Assembly/1_Flye_output/assembly.fasta

nucmer --prefix=Analyses/2_Genome_Assembly/comparison/mum_out/post_pol \
    DATA/raw_data/reference_genome/HP126_genome.fasta \
    Analyses/2_Genome_Assembly/3_polishing/pilon_output.fasta

mummerplot --png --layout --fat --color --filter \
    -p Analyses/2_Genome_Assembly/comparison/mum_out/pre_pol \
    Analyses/2_Genome_Assembly/comparison/mum_out/pre_pol.delta

mummerplot --png --layout --fat --color --filter \
    -p Analyses/2_Genome_Assembly/comparison/mum_out/post_pol \
    Analyses/2_Genome_Assembly/comparison/mum_out/post_pol.delta
