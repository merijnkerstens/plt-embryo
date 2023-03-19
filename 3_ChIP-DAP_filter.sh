#!/bin/bash

##### PE workflow #####
cd ~/data/ChIP_DAP/alignments/PE

## Remove secondary and unmapped reads
parallel --jobs 2 samtools fixmate -r -m {} '{= s:\.[^.]+$::; =}'.fixmate.bam ::: *_sorted.bam

## Re-sort
parallel --jobs 2 samtools sort -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.resorted.bam -O BAM {} ::: *.fixmate.bam

## Remove duplicates
parallel --jobs 2 sambamba markdup -r -t 4 {} '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.dedup.bam ::: *.resorted.bam

## Filter for mapping quality 30 (0.1% wrong), uniquely mapping and non-chimeric reads
parallel --jobs 2 sambamba view -t 4 -h -f bam -F '"mapping_quality >= 30 and not (unmapped or secondary_alignment)and not ([XA] != null or [SA] != null)"' {} -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.filtered.bam ::: *.dedup.bam

## PE workflow, Novaseq
cd ~/data/ChIP_DAP/alignments/PE/Novaseq

## Remove secondary and unmapped reads
parallel --jobs 2 samtools fixmate -r -m {} '{= s:\.[^.]+$::; =}'.fixmate.bam ::: *_sorted.bam

## Re-sort
parallel --jobs 2 samtools sort -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.resorted.bam -O BAM {} ::: *.fixmate.bam

## Remove duplicates
parallel --jobs 2 sambamba markdup -r -t 4 --overflow-list-size 600000 --hash-table-size 1000000 {} '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.dedup.bam ::: *.resorted.bam

## Filter for mapping quality 30 (0.1% wrong), uniquely mapping and non-chimeric reads
parallel --jobs 2 sambamba view -t 4 -h -f bam -F '"mapping_quality >= 30 and not (unmapped or secondary_alignment)and not ([XA] != null or [SA] != null)"' {} -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.filtered.bam ::: *.dedup.bam


##### SE workflow #####
cd ~/data/ChIP_DAP/alignments/SE

## Remove optical duplicates
parallel --jobs 2 sambamba markdup -r -t 4 {} '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.dedup.bam ::: *_sorted.bam

## Filter for mapping quality 30 (0.1% wrong), uniquely mapping and non-chimeric reads
parallel --jobs 2 sambamba view -t 4 -h -f bam -F '"mapping_quality >= 30 and not (unmapped or secondary_alignment)and not ([XA] != null or [SA] != null)"' {} -o '{= s:\.[^.]+$::;s:\.[^.]+$::; =}'.filtered.bam ::: *.dedup.bam
