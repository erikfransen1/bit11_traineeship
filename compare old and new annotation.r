###compare old and new annotation
# using input from bash script with positional arguments
getwd()
[1] "/home/efransen/outputAnnovar"

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
diffAnnot<-NULL
outList<-vector("list", length(oldAnnot))
filename<-substr(oldAnnot,10,16)
names(outList)<-filename


# outer loop : over VCFs
for(j in 1:length(oldAnnot)){
    #read in annotated files as tab-delimited (NOT csv!!)
    newVCF<-read.table(paste0("newAnnot3/",newAnnot[j]),header=T,sep="\t",fill=T,na.strings = ".")
    oldVCF<-read.table(paste0("oldAnnot3/",oldAnnot[j]),header=T,sep="\t",fill=T,na.strings = ".")
   
    # not all fields are same
    # search for common info fields
    commonCOLS<-intersect(names(newVCF),names(oldVCF))
    # remove columns with otherinfo
    commonCOLS<-commonCOLS[grepl("Otherinfo",commonCOLS)==FALSE]
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
        tmpNew<-newVCF[,c(1:5,grepCol)]
        tmpNew<-tmpNew %>% 
            filter(if_all(c(Chr,Start, Ref, Alt), ~!is.na(.)))
        names(tmpNew)[6]<-"new"
        tmpNew$new<-as.character(tmpNew$new)

        grepCol<-grep(commonINFO[i],names(oldVCF))
        tmpOld<-oldVCF[,c(1:5,grepCol)]
        tmpOld<-tmpOld %>% 
            filter(if_all(c(Chr,Start, Ref, Alt), ~!is.na(.)))
        names(tmpOld)[6]<-"old"
        tmpOld$old<-as.character(tmpOld$old)

        oldNew<-merge(tmpOld,tmpNew,by=c("Chr","Start","Ref","Alt"))
            oldNew<-oldNew %>% 
                filter(!is.na(old)|!is.na(new))%>%
                mutate(old=replace_na(old,""),
                        new=replace_na(new,""))       
        oldNew$field<-commonINFO[i]
        oldNew$VCF<-filename[j]   
        
        # accumulate all rown with differential annotation
        diffAnnot<-as.data.frame(rbind(diffAnnot,oldNew[oldNew$old!=oldNew$new,]))

        # table with differential annotations per VCF
        outList[[j]][[i]]<-oldNew[oldNew$old!=oldNew$new,]
        }
    }


# visualize differential expression
perVCF<-diffAnnot%>%
    filter(VCF=="subVCF1")
ggplot(perVCF,aes(x=Chr,fill=field))+
    geom_bar()+
    xlab("")+
    theme(axis.text.x = element_text(angle = 90))

