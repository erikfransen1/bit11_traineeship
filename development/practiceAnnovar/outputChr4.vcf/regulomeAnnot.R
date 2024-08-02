########################################################
# Annotate regulome DB
# to express likelihood of being regulatory variant
# using haploR as API
########################################################


# download VCF of choice 
# make sure duplicate IDs are gone
source("C:/Users/fransen/Dropbox/Howest/11_Traineeship/practiceAnnovar/outputChr4.vcf/troubleshoot_duplicates_function.R")



# read in original Chr4 VCF
myVCF<-read.vcfR("annoChr4.hg19_multianno.vcf")

# replace GERP++ by GERP in meta, fix and gt
myVCF@meta<-gsub("GERP++_","GERP",myVCF@meta,fixed=TRUE)
myVCF@fix<-gsub("GERP++_","GERP",myVCF@fix,fixed=TRUE)
myVCF@gt<-gsub("GERP++_","GERP",myVCF@gt,fixed=TRUE)

myVCF<-detect_dupl_ID(inputVCF = myVCF)



#######################
# Regulome db
#######################
library(haploR)

fixDF<- as.data.frame(myVCF@fix) 
fixDF$FROM<-as.numeric(fixDF$POS)
fixDF$TO<-fixDF$FROM + nchar(fixDF$ALT)
fixDF$QUERY<-paste0(fixDF$CHROM,":",fixDF$FROM,"-",fixDF$TO)

allQuery<-fixDF$QUERY
nQuery<-length(allQuery)
resultMatrix<-matrix(NA,nrow=nQuery,ncol=2)

for(i in 1:10){
  myQuery<-allQuery[i]
  
  #result<-NULL
  
  suppressMessages({
    result<-queryRegulome(query = myQuery,
                          genomeAssembly = "GRCh37")[[1]]
    if(is_empty(result)==FALSE){
      resultScoreDF<-as.data.frame(result$regulome_score)
      resultMatrix[i,1]<-mean(as.numeric(resultScoreDF$probability),na.rm=T)  
      resultMatrix[i,2]<-resultScoreDF$ranking[1]
    }
  })
}
resultMatrix<-as.data.frame(resultMatrix)
resultMatrix$query<-allQuery
names(resultMatrix)<-c("probability","ranking","query")
o<-order(resultMatrix$probability,decreasing = T)
resultMatrixOrdered<-resultMatrix[o,]


