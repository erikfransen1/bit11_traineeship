setwd("C:/Users/fransen/Dropbox/Howest/11_Traineeship/practiceAnnovar/outputChr4.vcf")
library(vcfR)
library(tidyverse)

# read in original VCF
myVCF<-read.vcfR("annoChr4.hg19_multianno.vcf")

# replace GERP++ by GERP in meta, fix and gt
myVCF@meta<-gsub("GERP++_","GERP",myVCF@meta,fixed=TRUE)
myVCF@fix<-gsub("GERP++_","GERP",myVCF@fix,fixed=TRUE)
myVCF@gt<-gsub("GERP++_","GERP",myVCF@gt,fixed=TRUE)

#### function to:
  ##  detect duplicate IDs
  ##  print list of duplicate IDs
  ##  set duplicate ID to missing

detect_dupl_ID<-function(inputVCF){
  
  # convert fixed part to DF
  allFix<-as.data.frame(getFIX(inputVCF))
  
  # only carry out function if there are duplicate ID
  if(length(names(table(allFix$ID)[table(allFix$ID)>1]))>0){
    
    # what ID are duplicated?
    duplID<-names(table(allFix$ID)[table(allFix$ID)>1])
    
    # allow for >1 ID duplicated
    nDupl<-length(duplID)
    
    # first convert fixed part of VCF to dataframe 
    # and perform grep in DF
    fixDF<-as.data.frame(getFIX(inputVCF))
    
    # run thru all duplicated IDs
    # sending message about setting ID to missing
    
    for(i in 1:nDupl){
      
      print(paste("ID",duplID[i],"is duplicated"))
      print(paste("Setting ID",duplID[i],"to missing"))
      
      duplIDLines<-grep(duplID[i],fixDF$ID)
      
      # put ID from duplicated ID to missing
      # must be NA, not "."
      inputVCF@fix[duplIDLines,"ID"]<-NA
    }
  }
  inputVCF
}


# functions failing due to non-unique ID
tidyVCF<-vcfR2tidy(myVCF)
genotypes_tidy<-extract_gt_tidy(myVCF)
genotypes<-extract.gt(myVCF)


# run function to correct
myVCF<-detect_dupl_ID(inputVCF = myVCF)
# [1] "ID >164>169 is duplicated"
# [1] "Setting ID >164>169 to missing"


# functions working after fixing duplicate IDs
tidyVCF<-vcfR2tidy(myVCF)
genotypes_tidy<-extract_gt_tidy(myVCF)
genotypes<-extract.gt(myVCF)
