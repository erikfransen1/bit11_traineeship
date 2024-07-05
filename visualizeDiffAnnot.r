
# visualize differential annotation
# load workspace from previous script
load("~/diffAnnot_num.rda")
load("~/diffAnnot_char.rda")
# using diffAnnot df from previous R script,
# with numeric and categorical in different files

allGenes<-unique(diffAnnot$Gene.refGene)
# 3979 different genes with at leas 1 diff annotation
# gene with most differential annotations
tail(sort(table(diffAnnot$Gene.refGene)),10)

# some annotations are continuous, some categorical
unique(diffAnnot_num$field)
# [1] "SIFT_score"             "Polyphen2_HDIV_score"   "Polyphen2_HVAR_score"
# [4] "LRT_score"              "MutationTaster_score"   "MutationAssessor_score"
# [7] "FATHMM_score"           "VEST3_score"            "CADD_raw"
#[10] "CADD_phred"             "GERP.._RS"              "SiPhy_29way_logOdds"

unique(diffAnnot_char$field)
# [1] "SIFT_pred"             "Polyphen2_HDIV_pred"   "Polyphen2_HVAR_pred"
# [4] "LRT_pred"              "MutationTaster_pred"   "MutationAssessor_pred"
# [7] "FATHMM_pred"

# see https://genome.ucsc.edu/cgi-bin/hgVai

# most interesting = change to D(eleterious)
# main diagonal is always empty !!! Has been selected against in previous step
addmargins(table(diffAnnot_char[diffAnnot_char$field=="SIFT_pred",]$new,diffAnnot_char[diffAnnot_char$field=="SIFT_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="Polyphen2_HDIV_pred",]$new,diffAnnot_char[diffAnnot_char$field=="Polyphen2_HDIV_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="Polyphen2_HVAR_pred",]$new,diffAnnot_char[diffAnnot_char$field=="Polyphen2_HVAR_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="LRT_pred",]$new,diffAnnot_char[diffAnnot_char$field=="LRT_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="MutationTaster_pred",]$new,diffAnnot_char[diffAnnot_char$field=="MutationTaster_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="MutationAssessor_pred",]$new,diffAnnot_char[diffAnnot_char$field=="MutationAssessor_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="FATHMM_pred",]$new,diffAnnot_char[diffAnnot_char$field=="FATHMM_pred",]$old,useNA="always"))



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