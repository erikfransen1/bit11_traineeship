###compare old and new annotation

#refgene hg18 vs hg19

getwd()
[1] "/home/efransen/outputAnnovar"

setwd("/home/efransen/outputAnnovar")
list.files(getwd())
library(vcfR)
library(tidyverse)

#read in annotated files as csv
newVCF<-read.table("myNewanno.hg19_multianno.txt",header=T,sep="\t",fill=T,na.strings = ".")
oldVCF<-read.table("myOldanno.hg19_multianno.txt",header=T,sep="\t",fill=T,na.strings = ".") 
# nolint

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

# if no annotation --> no merge and move to next column
if(sum(is.na(tmpOld$old), is.na(tmpNew$new))==dim(tmpNew)[1]+dim(tmpOld)[1]){
    next
}

#next steps : only of there is annotation in at leas 1 of the annotations
oldNew<-merge(tmpOld,tmpNew)


