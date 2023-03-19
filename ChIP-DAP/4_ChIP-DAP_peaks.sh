#!/bin/bash

## Call peaks with MACS3

## Define directories
PE_dir=~/data/ChIP_DAP/alignments/PE
NS_dir=~/data/ChIP_DAP/alignments/PE/Novaseq
SE_dir=~/data/ChIP_DAP/alignments/SE
out_dir=~/data/ChIP_DAP/peaks/

## Run predictd to estimate extsize. Add this number to the --extsize flag below.
macs3 predictd -g 1.19e8 -i {file} -m 3 50 (-f BAMPE)

## O'Malley et al 2016
macs3 callpeak -t $SE_dir/PLT1_DAP_trimmed_sorted.filtered.bam -c $PE_dir/HALO_ampDAP_trimmed_sorted.filtered.bam -g 1.19e8 --nomodel --extsize 140 -n PLT1_DAP -B -q 0.05 --outdir $out_dir
macs3 callpeak -t $SE_dir/PLT1_ampDAP_trimmed_sorted.filtered.bam -c $PE_dir/HALO_ampDAP_trimmed_sorted.filtered.bam -g 1.19e8 --nomodel --extsize 117 -n PLT1_ampDAP -B -q 0.05 --outdir $out_dir
macs3 callpeak -t $SE_dir/PLT3_DAP_trimmed_sorted.filtered.bam -c $PE_dir/HALO_ampDAP_trimmed_sorted.filtered.bam -g 1.19e8 --nomodel --extsize 124 -n PLT3_DAP -B -q 0.05 --outdir $out_dir
macs3 callpeak -t $SE_dir/PLT7_DAP_trimmed_sorted.filtered.bam -c $PE_dir/HALO_ampDAP_trimmed_sorted.filtered.bam -g 1.19e8 --nomodel --extsize 175 -n PLT7_DAP -B -q 0.05 --outdir $out_dir
macs3 callpeak -t $SE_dir/PLT7_ampDAP_trimmed_sorted.filtered.bam -c $PE_dir/HALO_ampDAP_trimmed_sorted.filtered.bam -g 1.19e8 --nomodel --extsize 125 -n PLT7_ampDAP -B -q 0.05 --outdir $out_dir

## Horstman et al 2017
macs3 callpeak -t $SE_dir/35S_BBM_GFP_ChIP_trimmed_sorted.filtered.bam -c $SE_dir/35S_BBM_ChIP_trimmed_sorted.filtered.bam -g 1.19e8 --nomodel --extsize 260 -n 35S_BBM_GFP_ChIP -B -q 0.05 --outdir $out_dir
macs3 callpeak -t $SE_dir/pBBM_BBM_YFP_ChIP_trimmed_sorted.filtered.bam -c $SE_dir/pBBM_GFP_ChIP_trimmed_sorted.filtered.bam -g 1.19e8 --nomodel --extsize 265 -n pBBM_BBM_YFP_ChIP -B -q 0.05 --outdir $out_dir

## Kerstens et al 2023
macs3 callpeak -f BAMPE -t $NS_dir/PLT3_MK_DAP_trimmed_sorted.filtered.bam -c $NS_dir/GFP_MK_DAP_trimmed_sorted.filtered.bam -g 1.19e8 --nomodel --extsize 156 -n PLT3_MK_DAP -B -q 0.05 --outdir $out_dir
