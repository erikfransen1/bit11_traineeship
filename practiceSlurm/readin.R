setwd("~/Slurm/practice")

myData<-read.table("inputData.txt",header=T,sep="\t",dec=",",
                   stringsAsFactors = T)

myData$Time_cat<-factor(myData$Time_cat,levels=c("T0","G","SI",
                "C2","C4","C6","C12","C18","C24","C30","C36",
                "C42","C48","C54","C60","C66","C72"))

myData$Group<-as.factor(myData$Group)
levels(myData$Group)<-c("Young","Old")
