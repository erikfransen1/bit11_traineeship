#### compare old and new annotation ###########

# using input from bash script with positional arguments
# detect variants with different annotation between old and new database

setwd("/home/efransen")

library(vcfR)
library(tidyverse)

#old and new annotations are in 2 separate folders
oldAnnot<-list.files(paste0(getwd(),"/oldAnnot3"))
newAnnot<-list.files(paste0(getwd(),"/newAnnot3"))

# need the txt files, not .vcf or .avinput
whatfiles<-grep("\\.txt",oldAnnot)
oldAnnot<-oldAnnot[whatfiles]
whatfiles<-grep("\\.txt",newAnnot)
newAnnot<-newAnnot[whatfiles]

# vector of sites with diff annotations in old vs new
diffAnnot_char<-NULL
diffAnnot_num<-NULL
filename<-substr(oldAnnot,10,16)


# outer loop : over VCFs
for(j in 1:length(oldAnnot)){
    #read in annotated files as tab-delimited (NOT csv!!)
    newVCF<-read.table(paste0("newAnnot3/",newAnnot[j]),header=T,sep="\t",fill=T,na.strings = ".")
    oldVCF<-read.table(paste0("oldAnnot3/",oldAnnot[j]),header=T,sep="\t",fill=T,na.strings = ".")
   
    # not all fields are same
    # search for common info fields
    commonCOLS<-intersect(names(newVCF),names(oldVCF))
    # remove columns with otherinfo
    #only keep refGene annot on funct.refGene and Gene.refGene
    commonCOLS<-commonCOLS[grepl("Otherinfo",commonCOLS)==FALSE]
    commonINFO<-commonCOLS[11:length(commonCOLS)]
    nFields<-length(commonINFO)
    

    #loop over info common fields (within one subVCF)
    for(i in 1:nFields){

        # grep common info fields in old and new annotation files
        grepCol<-grep(commonINFO[i],names(newVCF))
        tmpNew<-newVCF[,c(1:7,grepCol)]
        tmpNew<-tmpNew %>% 
            filter(if_all(c(Chr,Start, Ref, Alt), ~!is.na(.)))
        names(tmpNew)[8]<-"new"

        grepCol<-grep(commonINFO[i],names(oldVCF))
        tmpOld<-oldVCF[,c(1:7,grepCol)]
        tmpOld<-tmpOld %>% 
            filter(if_all(c(Chr,Start, Ref, Alt), ~!is.na(.)))
        names(tmpOld)[8]<-"old"

        oldNew<-merge(tmpOld,tmpNew,by=c("Chr","Start","Ref","Alt","Func.refGene","Gene.refGene"))
            oldNew<-oldNew %>% 
                filter(!is.na(old)|!is.na(new))%>%
                filter(if_all(c(Chr,Start, Ref, Alt), ~!is.na(.)))
   
        oldNew$field<-commonINFO[i]
        oldNew$VCF<-filename[j]   
        
        # accumulate all rown with differential annotation
        # split for numeric and character annotation
        if(is.numeric(oldNew$new)){
            diffAnnot_num<-as.data.frame(rbind(diffAnnot_num,oldNew[oldNew$old!=oldNew$new,]))
            diffAnnot_num<-as.data.frame(rbind(diffAnnot_num,oldNew[is.na(oldNew$old)&is.na(oldNew$new)==FALSE,]))
            diffAnnot_num<-as.data.frame(rbind(diffAnnot_num,oldNew[is.na(oldNew$new)&is.na(oldNew$old)==FALSE,]))
        }else{
            diffAnnot_char<-as.data.frame(rbind(diffAnnot_char,oldNew[oldNew$old!=oldNew$new,]))
            diffAnnot_char<-as.data.frame(rbind(diffAnnot_char,oldNew[is.na(oldNew$old)&is.na(oldNew$new)==FALSE,]))
            diffAnnot_char<-as.data.frame(rbind(diffAnnot_char,oldNew[is.na(oldNew$new)&is.na(oldNew$old)==FALSE,]))
        }
        
        }
    }

diffAnnot_num<-diffAnnot_num%>%
    filter(if_all(c(Chr,Start, Ref, Alt), ~!is.na(.)))

diffAnnot_char<-diffAnnot_char%>%
    filter(if_all(c(Chr,Start, Ref, Alt), ~!is.na(.)))


save(diffAnnot_char,file="~/diffAnnot_char.rda")
save(diffAnnot_num,file="~/diffAnnot_num.rda")