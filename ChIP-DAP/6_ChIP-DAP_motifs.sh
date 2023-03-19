#!/bin/bash

## Set directories
ref=~/data/genomes/ncbi-genomes-2022-03-15/TAIR10.fasta
peak_dir=~/data/ChIP_DAP/peaks
motif_dir=~/data/ChIP_DAP/motifs
motif=~/data/ChIP_DAP/motifs/overlap_motif/meme_out/meme.xml
ol_dir=~/data/ChIP_DAP/overlap
fimo_dir=~/data/ChIP_DAP/motif_hits

## Build background model (order 3)
fasta-get-markov -m 3 ~/data/genomes/ncbi-genomes-2022-03-15/TAIR10.fasta $motif_dir/bg_model.bg

## Extract peak summits from the deduplicated overlapping peak files
cat $peak_dir/*summits.bed > $peak_dir/master_peaks.bed
cat $ol_dir/PLT_overlapped_peaks_dedup.list | while read -r line
	do
        grep "	$line	" $peak_dir/master_peaks.bed
done > $peak_dir/master_peaks_overlapped.bed

## Extract summits +- 50 bp sequences with overlap
cat $peak_dir/master_peaks_overlapped.bed | awk '{$2-=50; print}' | awk '{$3+=50; print}' | awk '$2+0<0{$2=0}1' | sed 's/ /	/g' > $peak_dir/master_peaks_overlapped.bed.tmp
bedtools getfasta -name -fi $ref -bed $peak_dir/master_peaks_overlapped.bed.tmp -fo $peak_dir/master_peaks_overlapped.fasta
rm $peak_dir/*.tmp

## Run meme-chip on the master peak seqs to generate a consensus motif of  length 16 (known length)
meme-chip -bfile $motif_dir/bg_model.bg -meme-nmotifs 1 -minw 16 -maxw 16 $peak_dir/master_peaks_overlapped.fasta -oc $motif_dir/overlap_motif -spamo-skip -fimo-skip
