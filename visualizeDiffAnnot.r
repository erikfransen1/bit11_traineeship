# visualize interesting annotations
# first run prioritize script
# include function for prioritizing in visualization script

# interestCADD<-filterNumeric(field = "CADD_phred",myCutoff=20) 
# interestSIFT<-filterCharacter(field="SIFT_pred",strict=FALSE)

library(RColorBrewer)

##### function to draw graph from gene or VCF of interest
    # per VCF : barchart of differential annotation 
    # giving previously unknown (potentially) damaging variant


# [1] "SIFT_pred"             "Polyphen2_HDIV_pred"   "Polyphen2_HVAR_pred"
# [4] "LRT_pred"              "MutationTaster_pred"   "MutationAssessor_pred"
# [7] "FATHMM_pred"

# function to plot diffferential annotations, highlighting newly deleterious varaints
    # mandatory args : input VCF and field
    # choose between barplot for VCF (counts types of variants) and 
    # variants within one gene of interest
    # type of field (numeric/character) is determined based upon field
    # (but still hard-coded)
    # cutoff for numeric annotations : using default in script prioritize

plotDiffAnnot<-function(VCF,field, perVCF=FALSE,perGene=FALSE,geneOfInt=NULL){

    if(field%in%c("CADD_phred", "VEST3_score","GERP.._RS","SiPhy_29way_logOdds")){
        fieldtype<-"numeric"
    }else if(field%in%c("SIFT_pred", "Polyphen2_HDIV_pred","Polyphen2_HVAR_pred","LRT_pred",
    "MutationTaster_pred","MutationAssessor_pred","FATHMM_pred")){
        fieldtype<-"character"
    }else{
        stop("field argument must be one of: 'CADD_phred','VEST3_score','GERP.._RS','SiPhy_29way_logOdds',
        'SIFT_pred','Polyphen2_HDIV_pred','Polyphen2_HVAR_pred','LRT_pred','MutationTaster_pred',
        'MutationAssessor_pred','FATHMM_pred'")
    }


    # create tables for given field, with all diff annot and 
    # annot creating a newly deleterious variant
    #need separate function for numeric and character annotations
    if(fieldtype=="numeric"){
        newDel<-filterNumeric(field=field)
        origTable<-diffAnnot_num%>%
            filter(field==field)
    }else if(fieldtype=="character"){
        newDel<-filterCharacter(field=field, strict=FALSE)
        origTable<-diffAnnot_char%>%
            filter(field==field)
    }
    
    # add column if differentially annotated variant is creating new deleterious variant
    origTable$newDel <- do.call(paste0, origTable) %in% do.call(paste0, newDel)

    if(perVCF==FALSE & perGene==FALSE){
        stop("must specify either perVCF or perGene")
    }

    # option perVCF : 
        # count total + interesting diff. annotations per variant type
        #start with complete table of differential annotations (either character or numeric)
        # annotation field = specified previously (generation of interesting list)

    if(perVCF==TRUE){
        if(is.null(VCF)){
            stop("Must specify VCF file")
        }
        #pdf(paste("barplot",myVCF,".pdf"))
        origTable%>%
            filter(VCF==VCF)%>%
            ggplot(aes(x=Func.refGene,fill=newDel))+
                geom_bar(position=position_dodge(preserve = "single"))+
                xlab("")+
                theme(axis.text.x = element_text(angle = 90))+
                #xlab("interesting differential annotation")+
                scale_fill_brewer(palette = "Set1",direction=-1)+
                labs(fill= "Newly deleterious variant")+
                ggtitle(paste(VCF,"field =",field))
        #dev.off()
    }

    # option perGene:
        # visualize if there are newly deleterious variants
        # for given gene of interest
        # for given field
        # highlight in graph versus new annotations not creating newly deleterious var.  
    if(perGene==TRUE){
        if(is.null(geneOfInt)){
            stop("Must specify gene of interest")
        }
        selection<-origTable%>%
            filter(Gene.refGene==geneOfInt)

        if(dim(selection)[1]>0){
            if(fieldtype=="character"){
                ggplot(selection,aes(x=old,y=new,col=newDel))+
                geom_jitter(width=0.2,height=0.2)+
                ggtitle(paste(VCF, "\nGene = ",geneOfInt, "\nField =", field))+
                # facet_wrap(~field,scales="free")+
                theme(axis.text.x = element_text(angle = 0))+
                scale_color_brewer(palette = "Set1",direction=-1)+
                labs(col= "Newly\ndeleterious\nvariant")
            }else{
                ggplot(selection,aes(x=old,y=new,col=newDel))+
                geom_point()+
                ggtitle(paste(VCF, "\nGene = ",geneOfInt, "\nField =", field))+
                # facet_wrap(~field,scales="free")+
                theme(axis.text.x = element_text(angle = 0))+
                scale_color_brewer(palette = "Set1",direction=-1)+
                labs(col= "Newly\ndeleterious\nvariant")
            }
            
            
        }else{
            message("No differentially annotated variants in gene of interest")
        }
    }    
}

plotDiffAnnot(field="VEST3_score",perVCF=TRUE,VCF="subVCF9",perGene = TRUE,geneOfInt = "TTN")
plotDiffAnnot(field="SIFT_pred",perVCF=TRUE,VCF="subVCF9",perGene = TRUE,geneOfInt = "TTN")
