#work in conda environment - put all input files in R folder
getwd()
# "/home/efransen/R"

library(vcfR)
library(tidyverse)
library(readr)

# store all VCF into 1 folder
setwd("../ownVCF")

# read in VCF using vcfR
myVCF<-read.vcfR("NA12878.vcf")

# how large is metapart?
metapart<-myVCF@meta
nMetaRows<-length(metapart)
# 48 rows

# read in meta part, headerline and body using read.table from entire VCF
#to later do selection of rows in body VCF

# meta part
metapart<-read.table("NA12878.vcf",comment.char = "",nrows = nMetaRows,sep="\t")

# header row (between meta part and body)
headerrow<-read.table("NA12878.vcf",comment.char = "",skip=nMetaRows,nrows = 1,sep="\t")

# read in the non-metapart as dataframe (skipping meta lines and header line)

bodyVCF<-read.table("NA12878.vcf",skip=(1+nMetaRows),sep="\t")
nrow<-dim(bodyVCF)[1]

names(headerrow)<-names(bodyVCF1)

# compose first VCF
# metapart = add to every VCF before annotation
# headerline between metapart and fixed+info+gt
# generate random 10,000 index numbers
# split fixed part and GT with 
# 

rows1<-sample(1:nrow,100000,replace=FALSE)
bodyVCF1<-vcfAsDF[rows1,]
test<-rbind(headerrow,bodyVCF1)

