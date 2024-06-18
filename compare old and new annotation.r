###compare old and new annotation

#refgene hg18 vs hg19

getwd()
[1] "/home/efransen/outputAnnovar"

setwd("/home/efransen/outputAnnovar")
list.files(getwd())
library(vcfR)
library(tidyverse)

#read in annotated files as csv
newVCF<-read.table("myNewanno.hg19_multianno.csv",header=T,sep=",",fill=T,na.strings = ".")
oldVCF<-read.table("myOldanno.hg19_multianno.csv",header=T,sep=",",fill=T,na.strings = ".")

# not all fields are same
# search for common info fields
commonCOLS<-intersect(names(newVCF),names(oldVCF))
commonINFO<-commonCOLS[6:length(commonCOLS)]

i<-1
grepCol<-grep(commonINFO[i],names(newVCF))
tmpNew<-newVCF[,c(1:5,grepCol)]
names(tmpNew)[6]<-"new"


grepCol<-grep(commonINFO[i],names(oldVCF))
tmpOld<-oldVCF[,c(1:5,grepCol)]
names(tmpOld)[6]<-"old"
tmpOld<-tmpOld[!is.na(tmpOld$old)&!is.na(tmpOld$Start),]

oldNew<-merge(tmpOld,tmpNew)

table(is.na(newVCF$SIFT_score))
table(is.na(oldVCF$SIFT_score))

oldNew_non_na <- oldNew %>% 
    filter_at(vars(old,new),any_vars(!is.na(.)))
dim(oldNew_non_na)
# 375156      7


#columns with .refgene annotation
refgeneCol<-grep("refGene",names(oldVCF))
oldRefgene<-oldVCF[,refgeneCol]
newRefgene<-newVCF[,refgeneCol]

names(oldRefgene)

names(oldVCF)<-gsub("refGene","refGeneOld",names(oldVCF))
names(newVCF)<-gsub("refGene","refGeneNew",names(newVCF))

vcfMerge<-merge(oldVCF,newVCF)
vcfMerge[is.na()]

