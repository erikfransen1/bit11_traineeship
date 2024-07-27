library(Hmisc)
library(tidyverse)
library(ggplot2)

setwd("C:/Users/fransen/OneDrive - Universiteit Antwerpen/Documenten/GitHub/bit11_traineeship")

# read in output from listDiffAnnot.R
load("diffAnnot_char.rda")
load("diffAnnot_num.rda")

# source function for prioritizing and visualization
source("~/GitHub/bit11_traineeship/prioritizeDiffAnnot.r")
source("~/GitHub/bit11_traineeship/visualizeDiffAnnot.r")

# run



# plotDiffAnnot(VCF="subVCF9",field="CADD_phred",graphType="barplot")
# plotDiffAnnot(VCF="subVCF9",field="CADD_phred",graphType="barplot",exonicOnly = TRUE)
# plotDiffAnnot(VCF="subVCF7",field="VEST3_score",graphType="barplot",geneOfInt = "TTN",exonicOnly = TRUE)
# plotDiffAnnot(VCF="subVCF7",field="VEST3_score",graphType="barplot",geneOfInt = "ahf zcreuy")
# plotDiffAnnot(VCF="subVCF7",field="VEST3_score",graphType="barplot",geneOfInt = "KCNQ4")
# plotDiffAnnot(field="CADD_phred",VCF="subVCF9",geneOfInt = "TTN",graphType="scatter")
# plotDiffAnnot(field="SIFT_pred",VCF="subVCF9",geneOfInt = "TTN",graphType="scatter")
# plotDiffAnnot(field="SIFT_pred",VCF="subVCF9",graphType="scatter")
