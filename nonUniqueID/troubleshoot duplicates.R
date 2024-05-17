setwd("C:/Users/fransen/Dropbox/Howest/11_Traineeship/practiceAnnovar/outputChr4.vcf")
library(vcfR)
library(tidyverse)

myVCF<-read.vcfR("annoChr4.hg19_multianno.vcf")

# replace GERP++ by GERP in meta, fix and gt
myVCF@meta<-gsub("GERP++_","GERP",myVCF@meta,fixed=TRUE)
myVCF@fix<-gsub("GERP++_","GERP",myVCF@fix,fixed=TRUE)
myVCF@gt<-gsub("GERP++_","GERP",myVCF@gt,fixed=TRUE)


# functions failing due to non-unique ID
tidyVCF<-vcfR2tidy(myVCF)
genotypes<-extract_gt_tidy(myVCF)
genotypes<-extract.gt(myVCF)


#search for ID present more than once
fixDF<-as.data.frame(getFIX(myVCF))
head(fixDF)
# CHROM      POS     ID REF ALT QUAL FILTER
#   1  chr4 10084279   >1>4   C   G   60   <NA>
#   2  chr4 10084326   >4>7   G   A   60   <NA>
#   3  chr4 10084347  >7>10   G   C   60   <NA>
#   4  chr4 10084392 >10>13   T   C   60   <NA>
#   5  chr4 10084565 >13>16   T   G   60   <NA>
#   6  chr4 10084609 >16>19   G   A   60   <NA>

allFix<-as.data.frame(getFIX(myVCF))
table(allFix$ID)[table(allFix$ID)>1]
# 164>169 
# 7

duplID<-names(table(allFix$ID)[table(allFix$ID)>1])
# [1] ">164>169"

allDuplIDLines<-grep(duplID,getFIX(myVCF))
# [1] 3175 3176 3177 3178 3179 3180 3181

# ????? grepped lines are outside range ??
dim(getFIX(myVCF))
# [1] 1560    7

#first convert fixed part of VCF to dataframe and perform grep in DF
fixDF<-as.data.frame(getFIX(myVCF))
dim(fixDF)
# [1] 1560    7

allDuplIDLines<-grep(duplID,fixDF$ID)
# allDuplIDLines
# [1] 55 56 57 58 59 60 61


fixDF[allDuplIDLines,]
# CHROM      POS       ID   REF         ALT QUAL FILTER
#   55  chr4 10089307 >164>169    CC       AC,AT   60   <NA>
#   56  chr4 10089337 >164>169    CC     ACA,ATA   60   <NA>
#   57  chr4 10089347 >164>169    CC   ACAA,ATAA   60   <NA>
#   58  chr4 10089357 >164>169    CC ACAAA,ATAAA   60   <NA>
#   59  chr4 10089367 >164>169   CCT     ACA,ATA   60   <NA>
#   60  chr4 10089377 >164>169  CCTT   ACAA,ATAA   60   <NA>
#   61  chr4 10089387 >164>169 CCTTT ACAAA,ATAAA   60   <NA>

# same row numbers as in myVCF@fix (=NOT dataframe!)
myVCF@fix[allDuplIDLines,1:7]
# CHROM  POS        ID         REF     ALT           QUAL FILTER
# [1,] "chr4" "10089307" ">164>169" "CC"    "AC,AT"       "60" NA    
# [2,] "chr4" "10089337" ">164>169" "CC"    "ACA,ATA"     "60" NA    
# [3,] "chr4" "10089347" ">164>169" "CC"    "ACAA,ATAA"   "60" NA    
# [4,] "chr4" "10089357" ">164>169" "CC"    "ACAAA,ATAAA" "60" NA    
# [5,] "chr4" "10089367" ">164>169" "CCT"   "ACA,ATA"     "60" NA    
# [6,] "chr4" "10089377" ">164>169" "CCTT"  "ACAA,ATAA"   "60" NA    
# [7,] "chr4" "10089387" ">164>169" "CCTTT" "ACAAA,ATAAA" "60" NA

# put ID from duplicated ID to missing
# must be NA, not "."
myVCF@fix[allDuplIDLines,"ID"]<-NA

myVCF@fix[allDuplIDLines,1:7]
# CHROM  POS        ID  REF     ALT           QUAL FILTER
# [1,] "chr4" "10089307" "." "CC"    "AC,AT"       "60" NA    
# [2,] "chr4" "10089337" "." "CC"    "ACA,ATA"     "60" NA    
# [3,] "chr4" "10089347" "." "CC"    "ACAA,ATAA"   "60" NA    
# [4,] "chr4" "10089357" "." "CC"    "ACAAA,ATAAA" "60" NA    
# [5,] "chr4" "10089367" "." "CCT"   "ACA,ATA"     "60" NA    
# [6,] "chr4" "10089377" "." "CCTT"  "ACAA,ATAA"   "60" NA    
# [7,] "chr4" "10089387" "." "CCTTT" "ACAAA,ATAAA" "60" NA   

# functions failing due to non-unique ID
tidyVCF<-vcfR2tidy(myVCF)
genotypes_tidy<-extract_gt_tidy(myVCF)
genotypes<-extract.gt(myVCF)
