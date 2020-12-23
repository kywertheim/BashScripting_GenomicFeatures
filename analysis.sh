#Extract the files from the archive.
tar -xf gencommand_proj2_data.tar.gz

#1. How many alignments does the bam file contain?
samtools view athal_wu_0_A.bam | wc -l
samtools flagstat athal_wu_0_A.bam
samtools view athal_wu_0_A.bam | cut -f3 | grep -v "*" | wc -l

#2. In how many alignments does the read have an unmapped mate?
samtools view athal_wu_0_A.bam | cut -f7 | grep "*" | wc -l
samtools view athal_wu_0_A.bam | cut -f7 | grep -c "*"

#3. How many alignments contain a deletion (D)?
samtools view athal_wu_0_A.bam | cut -f6 | grep "D" | wc -l
samtools view athal_wu_0_A.bam | cut -f6 | grep -c "D"

#4. In how many alignments does the read have a mate mapped to the same chromosome?
samtools view athal_wu_0_A.bam | cut -f7 | grep "=" | wc -l
samtools view athal_wu_0_A.bam | cut -f7 | grep -c "="

#5. How many alignments are spliced?
samtools view athal_wu_0_A.bam | cut -f6 | grep "N" | wc -l
samtools view athal_wu_0_A.bam | cut -f6 | grep -c "N"

#Sort and index the bam file.
samtools sort athal_wu_0_A.bam athal_wu_0_A.sorted
nohup samtools sort athal_wu_0_A.bam athal_wu_0_A.sorted &
samtools index athal_wu_0_A.sorted.bam

#Extract the alignments in a region of interest (locus).
samtools view -b athal_wu_0_A.sorted.bam Chr3:11777000-11794000 > athal_wu_0_A.region.bam

#6. How many alignments in the locus of interest "Chr3:11,777,000-11,794,000" does the bam file contain?
samtools view athal_wu_0_A.sorted.bam Chr3:11,777,000-11,794,000 | wc -l
samtools flagstat athal_wu_0_A.region.bam

#7. In how many alignments in the locus of interest "Chr3:11,777,000-11,794,000" does the read have an unmapped mate?
samtools view athal_wu_0_A.sorted.bam Chr3:11,777,000-11,794,000 | cut -f7 | grep "*" | wc -l
samtools view athal_wu_0_A.region.bam | cut -f7 | grep -c "*"

#8. How many alignments in the locus of interest "Chr3:11,777,000-11,794,000" contain a deletion (D)?
samtools view athal_wu_0_A.sorted.bam Chr3:11,777,000-11,794,000 | cut -f6 | grep "D" | wc -l
samtools view athal_wu_0_A.region.bam | cut -f6 | grep -c "D"

#9. In how many alignments in the locus of interest "Chr3:11,777,000-11,794,000" does the read have a mate mapped to the same chromosome?
samtools view athal_wu_0_A.sorted.bam Chr3:11,777,000-11,794,000 | cut -f7 | grep "=" | wc -l
samtools view athal_wu_0_A.region.bam | cut -f7 | grep -c "="

#10. How many alignments in the locus of interest "Chr3:11,777,000-11,794,000" are spliced?
samtools view athal_wu_0_A.sorted.bam Chr3:11,777,000-11,794,000 | cut -f6 | grep "N" | wc -l
samtools view athal_wu_0_A.region.bam | cut -f6 | grep -c "N"

#11. How many sequences are in the reference genome file? 
samtools view -H athal_wu_0_A.bam
samtools view -H athal_wu_0_A.bam | grep -c SN:

#12. What is the length of the first sequence in the reference genome file?
samtools view -H athal_wu_0_A.bam
samtools view -H athal_wu_0_A.bam | grep SN: | more

#13. Which alignment tool was used?
samtools view -H athal_wu_0_A.bam
samtools view -H athal_wu_0_A.bam | grep @PG

#14. What is the read identifier (name) for the first alignment?
samtools view athal_wu_0_A.bam | head -1
samtools view athal_wu_0_A.bam | head -1 | cut -f1

#15. What is the start position of the first alignment read’s mate on the genome?
samtools view athal_wu_0_A.bam | head -1

#Convert the bam file into a bed file.
bedtools bamtobed -i athal_wu_0_A.bam > athal_wu_0_A.bed

#Create a bed file containing the intersection between the alignments in the locus of interest "Chr3:11,777,000-11,794,000" and the exons there.
bedtools intersect -abam athal_wu_0_A.region.bam -b athal_wu_0_A_annot.gtf -bed -wo > overlaps.bed

#16. How many alignment-exon overlaps in the locus of interest "Chr3:11,777,000-11,794,000" are reported?
bedtools intersect -wo -a athal_wu_0_A_annot.gtf -b athal_wu_0_A.bed | wc -l
wc -l overlaps.bed

#17. How many alignment-exon overlaps in the locus of interest "Chr3:11,777,000-11,794,000" have 10 or more bases?
bedtools intersect -wo -a athal_wu_0_A_annot.gtf -b athal_wu_0_A.bed | cut -f16 | awk '{if ($1 >= 10) print $1}' | wc -l
cut -f22 overlaps.bed | sort -nrk1 > lengths
cut -f22 overlaps.bed | sort -nrk1 | grep -n "^9" | head -1

#18. How many alignments in the original bam file overlap the exons in the locus of interest "Chr3:11,777,000-11,794,000"?
bedtools intersect -wo -a athal_wu_0_A_annot.gtf -b athal_wu_0_A.bed | wc -l
cut -f1-12 overlaps.bed | sort -u | wc -l

#19. How many exons in the locus of interest "Chr3:11,777,000-11,794,000" contain alignments?
bedtools intersect -wo -a athal_wu_0_A_annot.gtf -b athal_wu_0_A.bed | cut -f4 | sort -u | wc -l
cut -f13-21 overlaps.bed | sort -u | wc -l

#20. If you were to convert the transcript annotations in the file “athal_wu_0_A_annot.gtf” into BED format, how many BED records would be generated?
cut -f9 athal_wu_0_A_annot.gtf | cut -d " " -f1,2 | sort -u | wc -l