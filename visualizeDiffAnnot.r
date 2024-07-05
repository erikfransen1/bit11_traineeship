
# visualize differential annotation
# load workspace from previous script
load("~/diffAnnot.rda")
# using diffAnnot df from previous R script

allGenes<-unique(diffAnnot$Gene.refGene)
# 3979 different genes with at leas 1 diff annotation
# gene with most differential annotations
tail(sort(table(diffAnnot$Gene.refGene)),10)

# some annotations are continuous, some categorical
# most interesting = change to D(eleterious)
table(diffAnnot[diffAnnot$field=="SIFT_pred",]$new,diffAnnot[diffAnnot$field=="SIFT_pred",]$old)


myVCF<-"subVCF1"

# function to draw graph from gene or VCF of interest
plotDiffAnnot<-function(perVCF=FALSE,perGene=FALSE,geneOfInt="myGene",myVCF="myVCF",outputGraph="annotGraph.pdf"){
    
    if(perVCF==TRUE){
        diffAnnot%>%
        filter(VCF==myVCF)%>%
        ggplot(aes(x=field,fill=Func.refGene))+
            geom_bar()+
            xlab("")+
            theme(axis.text.x = element_text(angle = 90))
    }

    if(perGene==TRUE){
        selection<-diffAnnot%>%
            filter(Gene.refGene==geneOfInt)

        if(dim(selection)[1]>0){
            ggplot(selection,aes(x=old,y=new,col=Func.refGene))+
                geom_point()+
                ggtitle("Gene = ",geneOfInt)+
                facet_wrap(~field,scales="free")
        }
    }
}

plotDiffAnnot(perVCF=TRUE,myVCF="subVCF1",outputGraph="annotTTN.pdf")

pdf("annotTTN_2.pdf")
plotDiffAnnot(perGene=TRUE,geneOfInt="TTN",outputGraph="annotTTN.pdf")
dev.off()

maxAnnot<-max(table(diffAnnot$Gene.refGene))
table(diffAnnot$Gene.refGene)[table(diffAnnot$Gene.refGene)==maxAnnot]
# TTN