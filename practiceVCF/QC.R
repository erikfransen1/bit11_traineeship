setwd("C:/Users/fransen/Dropbox/Howest/11_Traineeship/vcfQC/")
library(vcfR)
library(tidyverse)
library(RColorBrewer)

palette(brewer.pal(n=12, name = 'Set3'))
par(mar = c(12,4,4,2))

############################################################
# Quality check on VCF files
# function to
  # search for missing values
  # plot missing values per sample and per variant
  # search extreme values within sample
  # set extreme values to missing
  # report changes wrt original input VCF
############################################################


QC_my_VCF<-function(input,parameter){
  # read in VCF
  myVCF<-read.vcfR(input)
  origVCF<-myVCF
  plotMissPerSample<-NULL
  plotMissPerVar<-NULL
  
  # evaluate missing data in parameter
  #if parameter is mentioned in file
  if(is_empty(queryMETA(myVCF, parameter))){
    print(paste("Parameter",parameter,"missing from input file"))
  }else{
    tmp<-extract.gt(myVCF, element = parameter, as.numeric=TRUE)
    
    # percentage of missings for parameter over the columns
    missPerSample <- apply(tmp, MARGIN = 2, function(x){ sum(is.na(x)) })
    missPerSample <- missPerSample/nrow(myVCF)
    
    if(min(missPerSample)>0){
      plotMissPerSample<-barplot(missPerSample, las = 2, col = 1:12,
                                 main= paste0("Missingness (%) over samples\n (",parameter,")"))
    }else{
      print(paste("No missings for parameter",parameter))
    }
        
    #count missings over variants
    # may be 1000s of samples --> histogram
    missPerVar <- apply(tmp, MARGIN = 1, function(x){ sum(is.na(x)) })
    missPerVar <- missPerVar/ncol(myVCF@gt[,-1])
    
    if(min(missPerVar)>0){
      plotMissPerVar<-barplot(missPerVar, las = 2, col = 1:12,
                  main= paste0("Missingness (%) over variables\n (",parameter,")"))
    }else{
      print(paste("No missings for parameter",parameter))
    }
    
    
    # quantiles per sample
    # flags poorly sequenced variants per sample
    quants <- apply(tmp, MARGIN=2, quantile, probs=c(0.1, 0.8), na.rm=TRUE)
    
    # put counts to missing if below q10 and above q80
    tmp2 <- sweep(tmp, MARGIN=2, FUN = "-", quants[1,])
    toZero1<-length(tmp[tmp2 < 0])
    tmp[tmp2 < 0] <- NA
    
    tmp2 <- sweep(tmp, MARGIN=2, FUN = "-", quants[2,])
    toZero2<-length(tmp[tmp2>0])
    tmp[tmp2 > 0] <- NA
    
    # put GTs with outlying value to missing in VCF
    myVCF@gt[,-1][ is.na(tmp) == TRUE ] <- NA
    
    toZeroTot<-toZero1+toZero2
    msg<-print(paste("A total of",toZeroTot,"observations put to missing"))
    
    outList=list("plotPerSample"=plotMissPerSample,
                 "plotPerVar"=plotMissPerVar,
                 "original VCF"=origVCF,
                 "QC'd VCF"=myVCF,
                 toZero=msg)
    
    return(outList)
  }
}


QC_my_VCF(input="grch38_chr4_10083863-10181258.vcf",parameter="DP")
QC_my_VCF(input="grch38_chr4_10083863-10181258.vcf",parameter="GQ")
QC_my_VCF(input="ex2.vcf",parameter="DP")
QC_my_VCF(input="ex2.vcf",parameter="GQ")
