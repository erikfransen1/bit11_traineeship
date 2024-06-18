###compare old and new annotation

#refgene hg18 vs hg19

getwd()
[1] "/home/efransen/outputAnnovar"

setwd("/home/efransen/outputAnnovar")
list.files(getwd())
library(vcfR)
library(tidyverse)

#read in annotated files as csv
newVCF<-read.table("myNewAnno.hg19_multianno.csv",header=T,sep=",",fill=T,na.strings = ".")
oldVCF<-read.table("myOldAnno.hg18_multianno.csv",header=T,sep=",",fill=T,na.strings = ".")

table(is.na(newVCF$Gene.refGene))
table(is.na(oldVCF$Gene.refGene))

newVCF_non_na <- newVCF %>% filter_at(vars(Gene.refGene,GeneDetail.refGene,ExonicFunc.refGene,AAChange.refGene),any_vars(!is.na(.)))



#columns with .refgene annotation
refgeneCol<-grep("refGene",names(oldVCF))
oldRefgene<-oldVCF[,refgeneCol]
newRefgene<-newVCF[,refgeneCol]

names(oldRefgene)

names(oldVCF)<-gsub("refGene","refGeneOld",names(oldVCF))
names(newVCF)<-gsub("refGene","refGeneNew",names(newVCF))

vcfMerge<-merge(oldVCF,newVCF)
vcfMerge[is.na()]

