# visualize interesting annotations
# first run prioritize script
# include function for prioritizing in visualization script

# interestCADD<-filterNumeric(myField = "CADD_phred",myCutoff=20) 
# interestSIFT<-filterCharacter(myField="SIFT_pred",strict=FALSE)

library(RColorBrewer)

##### function to draw graph from gene or VCF of interest
    # per VCF : barchart of differential annotation 
    # giving previously unknown (potentially) damaging variant



plotDiffAnnot<-function(myField=,fieldtype=,perVCF=FALSE,perGene=FALSE,geneOfInt=NULL,myVCF=NULL,outputGraph="annotGraph.pdf"){
    
    if (is.null(myField) || length(myField) != 1L || !myField %in% c("CADD_phred", "VEST3_score","GERP.._RS","SiPhy_29way_logOdds")) {
        stop("myField argument must be one of: 'CADD_phred','VEST3_score','GERP.._RS','SiPhy_29way_logOdds'")
        }
    
    if (is.null(fieldtype) || length(fieldtype) != 1L || !fieldtype %in% c("numeric","character")) {
    stop("myField argument must be one of: 'numeric','character'")
    }


    if(fieldtype=="numeric"){
        newDel<-filterNumeric(myField=field, myCutoff=cutoff)
        origTable<-diffAnnot_num%>%
            filter(field==myField)
    }else if(fieldtype=="character"){
        newDel<-filterCharacter(myField=field, strict=FALSE)
        origTable<-diffAnnot_char%>%
            filter(field==myField)
    }
    
    # add column if differentially annotated variant is interesting
    origTable$newDel <- do.call(paste0, origTable) %in% do.call(paste0, newDel)

    if(perVCF==FALSE & perGene==FALSE){
        stop("must specify either perVCF or perGene")
    }

    # option perVCF : 
        # count total + interesting diff. annotations per variant type
        #start with complete table of differential annotations (either character or numeric)
        # annotation field = specified previously (generation of interesting list)

    if(perVCF==TRUE){
        if(is.null(myVCF)){
            stop("Must specify VCF file")
        }
        pdf(paste("barplot",myVCF,".pdf"))
        origTable%>%
            filter(VCF==myVCF)%>%
            ggplot(aes(x=Func.refGene,fill=newDel))+
                geom_bar(position=position_dodge(preserve = "single"))+
                xlab("")+
                theme(axis.text.x = element_text(angle = 90))+
                #xlab("interesting differential annotation")+
                scale_fill_brewer(palette = "Set1",direction=-1)+
                labs(fill= "Newly deleterious variant")+
                ggtitle(paste(myVCF,"field =",myField))
        dev.off()
    }

    # option perGene:
        # visualize if there are newly deleterious variants
        # for given gene of interest
        # highlight in graph versus new annotations not creating newly deleterious var.  
    if(perGene==TRUE){
        if(is.null(geneOfInt)){
            stop("Must specify gene of interest")
        }
        selection<-origTable%>%
            filter(Gene.refGene==geneOfInt)

        if(dim(selection)[1]>0){
            pdf(paste0("scatterOldNew_",myVCF,".pdf"))
            ggplot(selection,aes(x=old,y=new,col=newDel))+
                geom_point()+
                ggtitle(paste(myVCF, "\nGene = ",geneOfInt, "\nField =", myField))+
                # facet_wrap(~field,scales="free")+
                theme(axis.text.x = element_text(angle = 0))+
                scale_color_brewer(palette = "Set1",direction=-1)+
                labs(col= "Newly\ndeleterious\nvariant")
            dev.off()
        }else{
            message("No differentially annotated variants in gene of interest")
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