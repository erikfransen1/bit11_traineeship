###compare old and new annotation

#refgene hg18 vs hg19

getwd()
[1] "/home/efransen/outputAnnovar"

setwd("/home/efransen")

library(vcfR)
library(tidyverse)

#old and new annotations are in 2 separate folders
oldAnnot<-list.files(paste0(getwd(),"/annotHg19_old"))
newAnnot<-list.files(paste0(getwd(),"/annotHg19_new"))

# list of lists to store different annotations
outList<-vector("list",length(oldAnnot))
names(outList)<-oldAnnot

# outer loop : over VCFs
for(j in 1:length(oldAnnot)){
    j<-1
    #read in annotated files as tab-delimited (NOT csv!!)
    newVCF<-read.table(paste0("annotHg19_new/",newAnnot[j]),header=T,sep="\t",fill=T,na.strings = ".")
    oldVCF<-read.table(paste0("annotHg19_old/",oldAnnot[j]),header=T,sep="\t",fill=T,na.strings = ".")
    

    # not all fields are same
    # search for common info fields
    commonCOLS<-intersect(names(newVCF),names(oldVCF))
    commonINFO<-commonCOLS[6:length(commonCOLS)]
    nFields<-length(commonINFO)
    hasAnnot<-rep(NA,nFields)

    #within outList (per VCF) generate inner list by common INFO field
    outList[[j]]<-vector("list",nFields)
    names(outList[[j]])<-commonINFO

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
            outList[[j]][[i]]<-oldNew[oldNew$old!=oldNew$new,]

        }

    }

}


#next steps : only of there is annotation in at leas 1 of the annotations

outList_nonzero<-unlist(outList)