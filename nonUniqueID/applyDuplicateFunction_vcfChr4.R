# initialize function to remove duplicates
source("C:/Users/fransen/Dropbox/Howest/11_Traineeship/practiceAnnovar/outputChr4.vcf/troubleshoot_duplicates_function.R")


library(vcfR)
library(tidyverse)

# read in original Chr4 VCF
myVCF<-read.vcfR("annoChr4.hg19_multianno.vcf")

# replace GERP++ by GERP in meta, fix and gt
myVCF@meta<-gsub("GERP++_","GERP",myVCF@meta,fixed=TRUE)
myVCF@fix<-gsub("GERP++_","GERP",myVCF@fix,fixed=TRUE)
myVCF@gt<-gsub("GERP++_","GERP",myVCF@gt,fixed=TRUE)



# # functions failing due to non-unique ID
# tidyVCF<-vcfR2tidy(myVCF)
# genotypes_tidy<-extract_gt_tidy(myVCF)
# genotypes<-extract.gt(myVCF)
# 

# run function to correct
myVCF<-detect_dupl_ID(inputVCF = myVCF)
# [1] "ID >164>169 is duplicated"
# [1] "Setting ID >164>169 to missing"


# functions working after fixing duplicate IDs
tidyVCF<-vcfR2tidy(myVCF)
genotypes_tidy<-extract_gt_tidy(myVCF)
genotypes<-extract.gt(myVCF)
