#!/bin/bash
dir=~/data/ChIP_DAP/peaks
ol_dir=~/data/ChIP_DAP/overlap

## Add 150 bp surrounding the peaks
cd $dir
for file in *summits.bed
        do
        cat $file | awk '{$2-=150; print}' | awk '{$3+=150; print}' | awk '$2+0<0{$2=0}1' | sed 's/ /	/g' > $file.overlapIP
done

## Find peak overlap; skip pBBM::BBM-YFP vs 35S::BBM-GFP
A=~/data/ChIP_DAP/peaks/PLT1_DAP_summits.bed.overlapIP
B=~/data/ChIP_DAP/peaks/PLT1_ampDAP_summits.bed.overlapIP
C=~/data/ChIP_DAP/peaks/PLT3_DAP_summits.bed.overlapIP
D=~/data/ChIP_DAP/peaks/PLT7_DAP_summits.bed.overlapIP
E=~/data/ChIP_DAP/peaks/PLT7_ampDAP_summits.bed.overlapIP
F=~/data/ChIP_DAP/peaks/PLT3_MK_DAP_summits.bed.overlapIP
G=~/data/ChIP_DAP/peaks/PLT2_ChIP_summits.bed.overlapIP
H=~/data/ChIP_DAP/peaks/35S_BBM_GFP_ChIP_summits.bed.overlapIP
I=~/data/ChIP_DAP/peaks/pBBM_BBM_YFP_ChIP_summits.bed.overlapIP

bedtools intersect -a $A -b $B $C $D $E $F $G $H $I -wo -sorted -f 0.75 -r | grep -v "^mt" | grep -v "^cp" | cut -f4,10 > $ol_dir/part1.overlap
bedtools intersect -a $B -b $A $C $D $E $F $G $H $I -wo -sorted -f 0.75 -r | grep -v "^mt" | grep -v "^cp" | cut -f4,10 > $ol_dir/part2.overlap
bedtools intersect -a $C -b $B $A $D $E $F $G $H $I -wo -sorted -f 0.75 -r | grep -v "^mt" | grep -v "^cp" | cut -f4,10 > $ol_dir/part3.overlap
bedtools intersect -a $D -b $B $C $A $E $F $G $H $I -wo -sorted -f 0.75 -r | grep -v "^mt" | grep -v "^cp" | cut -f4,10 > $ol_dir/part4.overlap
bedtools intersect -a $E -b $B $C $D $A $F $G $H $I -wo -sorted -f 0.75 -r | grep -v "^mt" | grep -v "^cp" | cut -f4,10 > $ol_dir/part5.overlap
bedtools intersect -a $F -b $B $C $D $E $A $G $H $I -wo -sorted -f 0.75 -r | grep -v "^mt" | grep -v "^cp" | cut -f4,10 > $ol_dir/part6.overlap
bedtools intersect -a $G -b $B $C $D $E $F $A $H $I -wo -sorted -f 0.75 -r | grep -v "^mt" | grep -v "^cp" | cut -f4,10 > $ol_dir/part7.overlap
bedtools intersect -a $H -b $B $C $D $E $F $G $A -wo -sorted -f 0.75 -r | grep -v "^mt" | grep -v "^cp" | cut -f4,10 > $ol_dir/part8.overlap
bedtools intersect -a $I -b $B $C $D $E $F $G $A -wo -sorted -f 0.75 -r | grep -v "^mt" | grep -v "^cp" | cut -f4,10 > $ol_dir/part9.overlap

## Gather all overlap files and deduplicate
cat $ol_dir/part*.overlap > $ol_dir/PLT_overlapped_peaks.list

## Cluster peaks
Rscript $ol_dir/infomap.R $ol_dir/PLT_overlapped_peaks.list $ol_dir/PLT_overlapped_peaks_clustered

## Deduplicate based on cluster membership
cat $ol_dir/PLT_overlapped_peaks_clustered | sed '1d' | sort -nk2 | awk '!seen[$2]++' | cut -f1 > $ol_dir/PLT_overlapped_peaks_dedup.list
