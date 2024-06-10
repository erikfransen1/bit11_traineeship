######## vcfR #############
setwd("C:/Users/fransen/Dropbox/Howest/11_Traineeship/practiceAnnovar/outputChr4.vcf")
library(vcfR)
library(tidyverse)

myVCF<-read.vcfR("annoChr4.hg19_multianno.vcf")

# ***** Object of Class vcfR *****
#   45 samples
# 1 CHROMs
# 1,560 variants
# Object size: 2.6 Mb
# 1.886 percent missing data

#########################################################
# Error message : GERP++_ fails regular expression
#########################################################
# INFO field GERP++_RS gives error for functions that use grep
# --> rename info field so that ++ are removed

# replace GERP++ by GERP in meta, fix and gt
myVCF@meta<-gsub("GERP++_","GERP",myVCF@meta,fixed=TRUE)
myVCF@fix<-gsub("GERP++_","GERP",myVCF@fix,fixed=TRUE)
myVCF@gt<-gsub("GERP++_","GERP",myVCF@gt,fixed=TRUE)


# meta information
queryMETA(myVCF)
# gives all meta lines

# where is GERP?
gerpLine<-grep("GERP",queryMETA(myVCF))
queryMETA(myVCF)[gerpLine]

queryMETA(myVCF,element="GERP")
# [[1]]
# [1] "INFO=ID=GERPRS"                                   
# [2] "Number=."                                         
# [3] "Type=String"                                      
# [4] "Description=GERPRS annotation provided by ANNOVAR"


#### fixed part
head(myVCF@fix,2)
#includes INFO fields !

#function getFIX only includes first 7 fields
allFix<-as.data.frame(getFIX(myVCF))


####genotypes 
myVCF@gt[1:10, ]


#### work with DF and tidyverse
####################################
# extract INFO field from annotated VCF
# GERP++ --> GERP
metaINFO2df(myVCF,field="INFO")

infoDF<-INFO2df(myVCF)
#infoDF = DF with different annotations 

# extract all field names to tidy DF
allFields<-vcf_field_names(myVCF,tag = "INFO")

### parse VCF using tidyverse
# info field (added by annovar)
infofields <- extract_info_tidy(myVCF)


head(fix_tidy)
head(infoFields)

##########################################
###ERROR messages due to non-unique ID
##########################################

tidyVCF<-vcfR2tidy(myVCF)
# ERROR : not all ID are unique


# dataframe with genotypes = long format compared to myVCF@gt
# 9 rows per sample, with fields (incl. GT) in separate column
genotypes<-extract_gt_tidy(myVCF)
## ERROR : not all ID are unique

# with non-tidyverse function
genotypes<-extract.gt(myVCF)
## ERROR : not all ID are unique

# split VCF by individual
geno_tidy = extract_gt_tidy(myVCF) %>%
  group_split(Indiv)

## ERROR : not all ID are unique


