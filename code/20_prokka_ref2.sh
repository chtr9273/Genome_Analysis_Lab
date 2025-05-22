#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J prokka_ref2
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load prokka

mkdir -p Analyses/3_Annotation/with_ref2

prokka Analyses/2_Genome_Assembly/3_polishing/pilon_output.fasta \
	--genus Streptomyces --species rimosus \
	--outdir Analyses/3_Annotation/with_ref2 \
	--prefix annotation_ref \
	--proteins DATA/ann_ref/sequence.gb \
	--cpus 2 --force
