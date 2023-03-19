#!/bin/bash

## Set directories
gtf=~/data/genomes/TAIR10_annotation.gtf
ref=~/data/genomes/ncbi-genomes-2022-03-15/TAIR10.fasta
peak_dir=~/data/ChIP_DAP/peaks
homer_dir=~/data/ChIP_DAP/annotations

## Annotate peaks
annotatePeaks.pl $peak_dir/master_peaks_overlapped.bed $ref -gtf $gtf > $homer_dir/all_peaks_homer.txt
cut -f10,12 $homer_dir/all_peaks_homer.txt | sed '1d' | cut -f2 | sort | uniq > $homer_dir/all_PLT_peaks.list