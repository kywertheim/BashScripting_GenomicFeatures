# BashScripting_GenomicFeatures
Context: This is the solution to the second exam of the Coursera course entitled 'Command Line Tools for Genomic Data Science'. The genome of one strain (wu_0_A) of the plant Arabidopsis thaliana has been sequenced and assembled. Then, the reads were mapped back to the assembled genome. The resulting BAM file is in the archive 'gencommand_proj2_data.tar.gz'. 

About:
1. Working within a Unix shell, the Bash script 'analysis.sh' quantifies the relations between the reads and their alignments.
2. Some of the commands are redundant. For example, 'samtools view athal_wu_0_A.bam | cut -f6 | grep "D" | wc -l' and 'samtools view athal_wu_0_A.bam | cut -f6 | grep –c "D"' generate equivalent results.

Files:
1. 'gencommand_proj2_data.tar.gz' is the archive file.
2. 'analysis.sh' should be placed in the same directory as 'gencommand_proj2_data.tar.gz'.

Software:
1. samtools v.1.2.
2. bedtools v.2.24.0.
