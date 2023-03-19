#!/bin/bash

## Paired-end: Trim adapter sequences and filter out poly-G stretches (Nova-seq)
cd ~/data/ChIP_DAP/reads/PE/untrimmed

for i in *_R1.fastq.gz;
do
  SAMPLE=$(echo ${i} | sed "s/_R1\.fastq\.gz//")
  echo ${SAMPLE}_R1.fastq.gz ${SAMPLE}_R2.fastq.gz
  fastp --trim_poly_g --adapter_fasta ~/data/ChIP_DAP/code/adapters.fasta -i ${SAMPLE}_R1.fastq.gz -I ${SAMPLE}_R2.fastq.gz -o ${SAMPLE}_trimmed_R1.fastq.gz -O ${SAMPLE}_trimmed_R2.fastq.gz 
done

rename 's/trimmed_R/trimmed.R/' *.gz
mv *trimmed*.fastq.gz ~/data/ChIP_DAP/reads/PE/

# Single-end: Trim adapter sequences
cd ~/data/ChIP_DAP/reads/SE/untrimmed

parallel --jobs 6 fastp --adapter_fasta ~/data/ChIP_DAP/code/adapters.fasta -i {} -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'_trimmed.fastq.gz ::: *.fastq.gz
mv *trimmed.fastq.gz ~/data/ChIP_DAP/reads/SE/
