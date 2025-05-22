#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 15:00:00
#SBATCH -J refinement_hmmer
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load eggNOG-mapper

mkdir -p Analyses/6_extra_analyses/refinement_hmmer

date

emapper.py -i Analyses/3_Annotation/with_ref2/annotation_ref.faa -o annotation_refinement \
	--output_dir Analyses/6_extra_analyses/refinement_hmmer \
	--cpu 2 --override -m hmmer -d Actinobacteria \
	--decorate_gff Analyses/3_Annotation/with_ref2/annotation_ref_no_fasta.gff \
	--decorate_gff_ID_field locus_tag --excel

date
