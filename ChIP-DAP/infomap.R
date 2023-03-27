#!/usr/bin/Rscript
# Usage: Rscript infomap1.r networkfile kcore_output
# The network file should be separated by tab

require(igraph)
args<-commandArgs(TRUE)
data <-read.table(args[1],sep='\t',header=F)
network <- graph.data.frame(data,directed=F)

net_simple <- simplify(network)
clusters <- cluster_infomap(net_simple)
out <- as.data.frame(list(names=clusters$names, mem=clusters$membership))
write.table(out,args[2],quote=F,sep='\t',row.names=F)
