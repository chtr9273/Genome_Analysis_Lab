#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 05:00:00
#SBATCH -J 2htseq
#SBATCH --mail-type=ALL
#SBATCH --mail-user christos.tricopoulos.9273@student.uu.se
#SBATCH --output=output%x.%j.out

module load bioinfo-tools
module load htseq

mkdir -p Analyses/5_diff_expression

for file in /proj/uppmax2025-3-3/nobackup/work/Christos/SR*.bam; do
    file_basename=$(basename "$file")
    file_prefix="${file_basename%%aligned*}"
    
    htseq-count -f bam -t CDS --stranded=yes --idattr=locus_tag \
        /proj/uppmax2025-3-3/nobackup/work/Christos/${file_prefix}aligned.bam \
	Analyses/3_Annotation/with_ref2/annotation_ref_no_fasta.gff \
	> Analyses/5_diff_expression/${file_prefix}_counts.txt
done



    
