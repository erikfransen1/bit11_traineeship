# visualize interesting annotations
# first run prioritize script
# include function for prioritizing in visualization script

# interestCADD<-filterNumeric(field = "CADD_phred",myCutoff=20) 
# interestSIFT<-filterCharacter(field="SIFT_pred",strict=FALSE)

library(RColorBrewer)
library(Hmisc)

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

plotDiffAnnot<-function(VCF,field, graphType=c("barplot","scatterplot"),geneOfInt=NULL){

    if(is.null(VCF)){
        stop("Must specify VCF file")
    }
    if(VCF%nin%unique(diffAnnot_char$VCF)){
        stop("Given VCF is not present in list with differential annotations")
    }

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
    # need separate function for numeric and character annotations
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

    
    # option barplot : 
        # count total + interesting diff. annotations per variant type
        # start with complete table of differential annotations (either character or numeric)
        # annotation field = specified previously (generation of interesting list)
    if(is.null(graphType)){
        stop("Must supply graph type")
    }else if(graphType=="barplot"){
        origTable%>%
            filter(VCF==VCF)%>%
            ggplot(aes(x=Func.refGene,fill=newDel))+
                geom_bar(position=position_dodge(preserve = "single"))+
                xlab("")+
                theme(axis.text.x = element_text(angle = 90))+
                scale_fill_brewer(palette = "Set1",direction=-1)+
                labs(fill= "Newly deleterious variant")+
                ggtitle(paste(VCF,"\nfield =",field))
    }else if(graphType=="scatter"){
    # option scatterplot:
        # visualize if there are newly deleterious variants
        # for given field (mandatory arg)
        # for given gene of interest (optional argument)
        # highlight in graph versus new annotations not creating newly deleterious var.  
    
        if(is.null(geneOfInt)){
            selection<-origTable%>%
                filter(VCF==VCF)
            message("No gene of interest specified. All genes are visualized")
        }else{
            selection<-origTable%>%
                filter(Gene.refGene==geneOfInt)%>%
                filter(VCF==VCF)
        }

        if(dim(selection)[1]>0){
            if(fieldtype=="character"){
                ggplot(selection,aes(x=old,y=new,col=newDel))+
                geom_jitter(width=0.2,height=0.2)+
                ggtitle(paste(VCF, "\nGene = ",geneOfInt, "\nField =", field))+
                theme(axis.text.x = element_text(angle = 0))+
                scale_color_brewer(palette = "Set1",direction=-1)+
                labs(col= "Newly\ndeleterious\nvariant")
            }else{
                ggplot(selection,aes(x=old,y=new,col=newDel))+
                geom_point()+
                ggtitle(paste(VCF, "\nGene = ",geneOfInt, "\nField =", field))+
                theme(axis.text.x = element_text(angle = 0))+
                scale_color_brewer(palette = "Set1",direction=-1)+
                labs(col= "Newly\ndeleterious\nvariant")
            }
        }else{
            message("No differentially annotated variants in gene of interest")
        }
    }else{
        stop(paste("Graph type",graphType,"is currently not supported"))
    }
}

#plotDiffAnnot(VCF="subVCF7",field="VEST3_score",graphType="barplot",geneOfInt = "KCNQ4")
#plotDiffAnnot(field="CADD_phred",VCF="subVCF9",geneOfInt = "TTN",graphType="scatter")
#plotDiffAnnot(field="SIFT_pred",VCF="subVCF9",geneOfInt = "TTN",graphType="scatter")
