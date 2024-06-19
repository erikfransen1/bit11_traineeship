###compare old and new annotation

#refgene hg18 vs hg19

getwd()
[1] "/home/efransen/outputAnnovar"

setwd("/home/efransen/outputAnnovar")
list.files(getwd())
library(vcfR)
library(tidyverse)

#read in annotated files as tab-delimited (NOT csv!!)
newVCF<-read.table("myNewanno.hg19_multianno.txt",header=T,sep="\t",fill=T,na.strings = ".")
oldVCF<-read.table("myOldanno.hg19_multianno.txt",header=T,sep="\t",fill=T,na.strings = ".") 
# nolint

# not all fields are same
# search for common info fields
commonCOLS<-intersect(names(newVCF),names(oldVCF))
commonINFO<-commonCOLS[6:length(commonCOLS)]
nFields<-length(commonINFO)
hasAnnot<-rep(NA,nFields)
outList<-vector("list",nFields)
names(outList)<-commonINFO

#loop over info common fields (within one subVCF)
for(i in 1:nFields){

    # grep common info fields in old and new annotation files
    grepCol<-grep(commonINFO[i],names(newVCF))
    tmpNew<-newVCF[is.na(newVCF$Chr)==FALSE,c(1:5,grepCol)]
    names(tmpNew)[6]<-"new"

    grepCol<-grep(commonINFO[i],names(oldVCF))
    tmpOld<-oldVCF[is.na(oldVCF$Chr),c(1:5,grepCol)]
    names(tmpOld)[6]<-"old"

    # detect if there is any annotation in the VCF
    if(sum(is.na(tmpOld$old), is.na(tmpNew$new))==(dim(tmpNew)[1]+dim(tmpOld)[1])){
        hasAnnot[i]<-FALSE
    }
    else{
        hasAnnot[i]<-TRUE
        oldNew<-merge(tmpOld,tmpNew)
        outList[[i]]<-oldNew[oldNew$old!=oldNew$new,]

    }

}

#next steps : only of there is annotation in at leas 1 of the annotations



