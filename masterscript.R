library(Hmisc)
library(tidyverse)
library(ggplot2)
library(vcfR)

# setwd("C:/Users/fransen/OneDrive - Universiteit Antwerpen/Documenten/GitHub/bit11_traineeship")

# read in output from listDiffAnnot.R
# load("~/diffAnnot_char.rda")
# load("~/diffAnnot_num.rda")

# run function to list differentially annotated variants
# among all VCF.txt files in a given directory
listDiffAnnot(workdir="/home/efransen", subdirOld="oldAnnot3",subdirNew="newAnnot3")



# source function for prioritizing and visualization
source("prioritizeDiffAnnot.r")
source("visualizeDiffAnnot.r")

# run visualization function for given VCF and field



# plotDiffAnnot(VCF="subVCF9",field="CADD_phred",outputType="barplot")
# plotDiffAnnot(VCF="subVCF9",field="CADD_phred",outputType="barplot",exonicOnly = TRUE)
# plotDiffAnnot(VCF="subVCF7",field="VEST3_score",outputType="barplot",geneOfInt = "TTN",exonicOnly = TRUE)
# plotDiffAnnot(VCF="subVCF7",field="VEST3_score",outputType="barplot",geneOfInt = "ahf zcreuy")
# plotDiffAnnot(VCF="subVCF7",field="VEST3_score",outputType="barplot",geneOfInt = "KCNQ4")
# plotDiffAnnot(field="CADD_phred",VCF="subVCF9",geneOfInt = "TTN",outputType="scatter")
# plotDiffAnnot(field="SIFT_pred",VCF="subVCF9",geneOfInt = "TTN",outputType="scatter")
# plotDiffAnnot(field="SIFT_pred",VCF="subVCF9",outputType="scatter")
# plotDiffAnnot(field="CADD_phred",VCF="subVCF9",geneOfInt = "TTN",outputType="table")
# plotDiffAnnot(field="SIFT_pred",VCF="subVCF9",geneOfInt = "TTN",outputType="scatter")
# plotDiffAnnot(field="SIFT_pred",VCF="subVCF9",outputType="scatter")

