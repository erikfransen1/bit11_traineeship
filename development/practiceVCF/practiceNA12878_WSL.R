######## vcfR #############
#work in conda environment - put all input files in R folder
getwd()
# "/home/efransen/R"
library(vcfR)
library(tidyverse)

# store all VCF into 1 folder
setwd("../ownVCF")
# remove field GERP++
myVCF<-read.vcfR("NA12878.vcf")

# ***** Object of Class vcfR *****
# 3 samples
# 3 CHROMs
# 9 variants
# Object size: 0 Mb
# 3.704 percent missing data


head(myVCF)
#give head of meta-, fixed and GT sections

str(myVCF)
#see meta, fix and gt part of file


#### meta part 
myVCF@meta
# 48 rows

#### fixed part
head(getFIX(myVCF))
length(getFIX(myVCF))

dim(getFIX(myVCF))
# 4167900       7
names(getFIX(myVCF))

#### genotypes 
dim(myVCF@gt)
# 4167900

# extract INFO field from annotated VCF
metaINFO2df(myVCF,field="INFO")

# very slow step, even if un-annotated
# put info fields into dataframe
infoDF<-INFO2df(myVCF)
names(infoDF)
dim(infoDF)
# 4167900

#split original VCF into 10
metapart<-myVCF@meta

nrow<-dim(myVCF@gt)[1]

rows1<-sample(1:nrow,400000,replace=FALSE)

