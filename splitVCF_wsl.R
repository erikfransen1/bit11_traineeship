#work in conda environment - put all input files in R folder
getwd()
# "/home/efransen/R"

library(vcfR)
library(tidyverse)
library(readr)

# store all VCF into 1 folder
setwd("../ownVCF")

# read in VCF using vcfR
myVCF<-read.vcfR("NA12878.vcf")

# how large is metapart?
metapart<-myVCF@meta
nMetaRows<-length(metapart)
# 48 rows

# read in meta part, headerline and body using read.table from entire VCF
#to later do selection of rows in body VCF

#### in bash ### 
# split metapart + headerrow from body of the VCF
head -n 49 NA12878.vcf > metaHeader
tail -n +50 NA12878.vcf > bodyVCF
$wc -l bodyVCF 
#4167900 bodyVCF
$ wc -l metaHeader 
49 metaHeader

### in R ###
setwd("../ownVCF")

# read in the body of the (entire) VCF as dataframe (skipping meta lines and header line)

bodyVCF<-read.table("bodyVCF",sep="\t")
nrow<-dim(bodyVCF)[1]

# compose first VCF
# generate random 10,000 index numbers to pick rows from bodyVCF
# 
commands<-rep(NA,10)
for(i in 1:10){
    randomRows<-sample(1:nrow,10000,replace=FALSE)
    bodySub<-bodyVCF[randomRows,]
    write.table(bodySub,paste0("body",i),row.names = FALSE, col.names = FALSE, quote=FALSE,sep="\t")
    commands[i]<-paste0("cat metaHeader body",i," > subVCF",i,"\n")
}
write.table(commands,"makeSubVCF",row.names=FALSE,col.names = FALSE,quote=FALSE)

#### bash ####
chmod u+x makeSubVCF
./makeSubVCF

# folder now contains 10 subVCF files

#check if subVCF can be read in
mySubVCF<-read.vcfR("subVCF1")
metapart<-mySubVCF@meta
nMetaRows<-length(metapart)
str(mySubVCF)