# visualize annotations

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