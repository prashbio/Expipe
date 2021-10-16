#Shell script for analysing WES sample
#Indexing already done using bowtie2, BWA and samtools: /home/ngs/Data/hg38
#All scripts and commands are to be run from Expipe
#fastqc already one for all samples. Pl check the folder 
bowtie2 -x /home/ngs/Data/hg38/hg38  -1 T5_1.fastq -2 T5_2.fastq -S T5.sam
samtools import /home/ngs/Data/hg38/hg38.fa T5.sam T5.bam
samtools sort T5.bam T5.sorted
samtools index T5.sorted.bam T5.sorted.bam.bai &
samtools merge T5.merged.bam T5.*
samtools mpileup T5.sorted.bam > T5.mpileup.bam 
varscan mpileup2snp T5.mpileup.bam > T5.mpileup.snps &
varscan mpileup2indel T5.mpileup.bam > T5.mpileup.indels 
varscan filter T5.mpileup.snps >T5.mpileup.snps.filter 
varscan readcounts T5.mpileup.bam >T5.mpileup.readcounts
samtools mpileup -uf /home/ngs/Data/hg38/hg38.fa T5.sorted.bam | bcftools view ->T5.raw.bcf 
#samtools calmd -Abr T5.mpileup.bam/Data/hg38/hg38.fa > T5.baq.bam
bcftools view T5.raw.bcf >T5.vcf
