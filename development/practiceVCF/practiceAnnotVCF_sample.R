######## vcfR #############
setwd("C:/Users/fransen/OneDrive - Universiteit Antwerpen/Documenten/GitHub/bit11_traineeship/practiceVCF")
library(vcfR)
library(tidyverse)

# remove field GERP++
myVCF<-read.vcfR("annoSample.hg19_multianno.vcf")

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
# Formal class 'vcfR' [package "vcfR"] with 3 slots
# ..@ meta: chr [1:21] "##fileformat=VCFv4.0" "##fileDate=20090805" "##source=myImputationProgramV3.1" "##reference=1000GenomesPilot-NCBI36" ...
# ..@ fix : chr [1:9, 1:8] "19" "19" "20" "20" ...
# .. ..- attr(*, "dimnames")=List of 2
# .. .. ..$ : NULL
# .. .. ..$ : chr [1:8] "CHROM" "POS" "ID" "REF" ...
# ..@ gt  : chr [1:9, 1:4] "GT:HQ" "GT:HQ" "GT:GQ:DP:HQ" "GT:GQ:DP:HQ" ...
# .. ..- attr(*, "dimnames")=List of 2
# .. .. ..$ : NULL
# .. .. ..$ : chr [1:4] "FORMAT" "NA00001" "NA00002" "NA00003"


#### meta part 
myVCF@meta[1:20]
queryMETA(myVCF)
queryMETA(myVCF,element="HQ")

#### fixed part
head(getFIX(myVCF))

#### genotypes 
myVCF@gt

# extract INFO field from annotated VCF
metaINFO2df(myVCF,field="INFO")
infoDF<-INFO2df(myVCF)
names(infoDF)
#infoDF = DF with different annotations 

#### work with tidyverse
#################################
tidyVCF<-vcfR2tidy(myVCF)

# extract INFO fields (added using annotation)
infoFields<-extract_info_tidy(myVCF)
infoDF<-as.data.frame(infoFields)

# dataframe with genotypes = long format compared to myVCF@gt
# 9 rows per sample, with fields (incl. GT) in separate column
genotypes<-extract_gt_tidy(myVCF)
# long format, nr lines / ID = nr of variants

# print full DF with genotypes 
print(n=30,genotypes)

# extract all field names to tidy DF
allFields<-vcf_field_names(myVCF,tag = "INFO")

### parse VCF using tidyverse
# info field

# fixed fields (genomic coordinates)
fix_tidy = myVCF@fix %>%
  as_tibble %>%
  rename(
    chr = CHROM,
    from = POS,
    ref = REF,
    alt = ALT
  ) %>%
  mutate(from = as.numeric(from), to = from + nchar(alt))

# split VCF by individual
geno_tidy = extract_gt_tidy(myVCF) %>%
  group_split(Indiv)

