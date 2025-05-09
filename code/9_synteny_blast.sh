#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:50:00
#SBATCH -J Blast_synteny
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load blast

mkdir -p Analyses/4_synteny/Blast_out

blastn -query Analyses/2_Genome_Assembly/3_polishing/pilon_output.fasta \
    -subject DATA/raw_data/reference_genome/R7_genome.fasta \
    -out Analyses/4_synteny/Blast_out/synteny.crunch \
    -outfmt 6
