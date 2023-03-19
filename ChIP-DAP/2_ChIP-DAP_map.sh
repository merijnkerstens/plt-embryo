#!/bin/bash

ref=~/data/genomes/ncbi-genomes-2022-03-15/TAIR10.fasta

## Indexing reference genome
samtools faidx $ref
bwa index -a bwtsw $ref

## PE: Mapping reads to reference genome
cd ~/data/ChIP_DAP/reads/PE
parallel --jobs 3 bwa mem -M -t 2 -V $ref '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}'.R1.fastq.gz '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}'.R2.fastq.gz '|' samtools sort -n -T '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}' -O bam -o '{= s:\.[^.]+$::;s:\.[^.]+$::;s:\.[^.]+$::; =}'_sorted.bam - ::: *.fastq.gz
mv *.bam ~/data/ChIP_DAP/alignments/PE/

## Separate Novaseq data
mkdir Novaseq
mv ~/data/ChIP_DAP/alignments/PE/*MK* Novaseq

## SE: Mapping reads to reference genome
cd ~/data/ChIP_DAP/reads/SE
parallel --jobs 3 bwa mem -M -t 2 -V $ref '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.fastq.gz '|' samtools sort -T '{= s:\.[^.]+$::;s:\.[^.]+$::; =}' -O bam -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'_sorted.bam - ::: *.fastq.gz
mv *.bam ~/data/ChIP_DAP/alignments/SE/
