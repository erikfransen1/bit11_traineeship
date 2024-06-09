# transfer annotated VCF to windows for analysis with vcfR package
# read in annotated VCF with vcfR

# see R code practiceVCF in Windows 

# had trouble running INFO2df function to extract INFO column from annotated VCF
# removed GERP++ field as it made grep crash

#read in original file in R
# then replace GERP++ by GERPusing gsub
myVCF@meta<-gsub("GERP++_","GERP",myVCF@meta,fixed=TRUE)
myVCF@fix<-gsub("GERP++_","GERP",myVCF@fix,fixed=TRUE)
myVCF@gt<-gsub("GERP++_","GERP",myVCF@gt,fixed=TRUE)

#  one of the further vcfR analyses required troubleshooting nonUnique ID