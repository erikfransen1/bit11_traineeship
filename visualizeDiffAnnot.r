plotDiffAnnot<-function(VCF,field, outputType=c("barplot","scatterplot","table"),geneOfInt=NULL,exonicOnly=FALSE){

  load("diffAnnot_char.rda")
  load("diffAnnot_num.rda")

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
    
    # add column if differentially annotated variant is creating newly deleterious variant
    origTable$newDel <- do.call(paste0, origTable) %in% do.call(paste0, newDel)


    # selection of variants 
      # inside gene of interest (if specified)
      # only exonic (if exonicOnly=TRUE)
    if(is.null(geneOfInt)){
        selection<-origTable%>%
            filter(VCF==VCF)
        message("No gene of interest specified. All genes are visualized")
        geneShown<-"all genes"
    }else{
        selection<-origTable%>%
            filter(Gene.refGene==geneOfInt)%>%
            filter(VCF==VCF)
        geneShown<-geneOfInt
        }
    if(exonicOnly==TRUE){
      selection<-selection%>%
        filter(Func.refGene=="exonic")
    }
    
    
    #error if no graph type is selected
    if(is.null(outputType)){
        stop("Must supply type of output: scatter, barplot or table")
    }

    if(dim(selection)[1]==0){
      message("No differentially annotated variants in gene of interest")
    }else if(dim(selection)[1]>0){
     
      # option barplot : 
        # count total + interesting diff. annotations per variant type
        # start with complete table of differential annotations (either character or numeric)
        # annotation field = specified previously (generation of interesting list)
        
      if(outputType=="barplot"){
        if(exonicOnly==FALSE){
          ggplot(selection,aes(x=Func.refGene,fill=newDel))+
            geom_bar(position=position_dodge(preserve = "single"))+
            xlab("")+
            theme(axis.text.x = element_text(angle = 90))+
            scale_fill_brewer(palette = "Set1",direction=-1)+
            labs(fill= "Newly deleterious variant")+
            ggtitle(paste("Input file = ",VCF,"\nGene = ",geneShown,"\nField =",field))
        }else if(exonicOnly==TRUE){
          ggplot(selection,aes(x=ExonicFunc.refGene,fill=newDel))+
            geom_bar(position=position_dodge(preserve = "single"))+
            xlab("")+
            theme(axis.text.x = element_text(angle = 90))+
            scale_fill_brewer(palette = "Set1",direction=-1)+
            labs(fill= "Newly deleterious variant")+
            ggtitle(paste("Input file = ",VCF,"\nGene = ",geneShown,"(exonic only)\nField =",field))
        }

      
        # option scatterplot:
          # visualize if there are newly deleterious variants
          # for given field (mandatory arg)
          # for given gene of interest (optional argument)
          # highlight in graph versus new annotations not creating newly deleterious var. 
          
      }else if(outputType=="scatter"){
        if(exonicOnly==FALSE){
          if(fieldtype=="character"){
            ggplot(selection,aes(x=old,y=new,col=newDel))+
              geom_jitter(width=0.2,height=0.2)+
              ggtitle(paste("Input file = ",VCF, "\nGene = ",geneShown, "\nField =", field))+
              theme(axis.text.x = element_text(angle = 0))+
              scale_color_brewer(palette = "Set1",direction=-1)+
              labs(col= "Newly\ndeleterious\nvariant")
          }else{
            ggplot(selection,aes(x=old,y=new,col=newDel))+
              geom_point()+
              ggtitle(paste("Input file = ",VCF, "\nGene = ",geneShown, "(exonic only)\nField =", field))+
              theme(axis.text.x = element_text(angle = 0))+
              scale_color_brewer(palette = "Set1",direction=-1)+
              labs(col= "Newly\ndeleterious\nvariant")
          }  
        }else if(exonicOnly==TRUE){
          if(fieldtype=="character"){
            ggplot(selection,aes(x=old,y=new,col=newDel))+
              geom_jitter(width=0.2,height=0.2)+
              ggtitle(paste("Input file = ",VCF, "\nGene = ",geneShown, "(exonic only)\nField =", field))+
              theme(axis.text.x = element_text(angle = 0))+
              scale_color_brewer(palette = "Set1",direction=-1)+
              labs(col= "Newly\ndeleterious\nvariant")
          }else{
            ggplot(selection,aes(x=old,y=new,col=newDel))+
              geom_point()+
              ggtitle(paste("Input file = ",VCF, "\nGene = ",geneShown, "\nField =", field))+
              theme(axis.text.x = element_text(angle = 0))+
              scale_color_brewer(palette = "Set1",direction=-1)+
              labs(col= "Newly\ndeleterious\nvariant")
          }
        }
      }else if(outputType=="table"){
        write.table(selection,file="diffAnnotVariants.txt",row.names=FALSE,quote=FALSE,sep="\t")
      }else{
        stop(paste("Output type",graphType,"is currently not supported"))
      }
    }
}

