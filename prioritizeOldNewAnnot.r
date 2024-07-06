
# Prioritize differentially annotated variants

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

# character fields are more biologically relevant
# most interesting = change to D(eleterious)
# see https://genome.ucsc.edu/cgi-bin/hgVai
# main diagonal is always empty !!! Has been selected against in previous step
addmargins(table(diffAnnot_char[diffAnnot_char$field=="SIFT_pred",]$new,diffAnnot_char[diffAnnot_char$field=="SIFT_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="Polyphen2_HDIV_pred",]$new,diffAnnot_char[diffAnnot_char$field=="Polyphen2_HDIV_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="Polyphen2_HVAR_pred",]$new,diffAnnot_char[diffAnnot_char$field=="Polyphen2_HVAR_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="LRT_pred",]$new,diffAnnot_char[diffAnnot_char$field=="LRT_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="MutationTaster_pred",]$new,diffAnnot_char[diffAnnot_char$field=="MutationTaster_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="MutationAssessor_pred",]$new,diffAnnot_char[diffAnnot_char$field=="MutationAssessor_pred",]$old,useNA="always"))
addmargins(table(diffAnnot_char[diffAnnot_char$field=="FATHMM_pred",]$new,diffAnnot_char[diffAnnot_char$field=="FATHMM_pred",]$old,useNA="always"))


subSIFT<-diffAnnot_char[diffAnnot_char$field=="SIFT_pred",]

interestingSIFT<-subSIFT%>%
    filter(new=="D")%>%
    filter(is.na(old)|old!="D")
# SIFT : D(amaging) or T(olerated)
# Polyphen : D(amaging); P(ossibly damaging), B(enign)
# LRT_pred : D(eleterious), N(eutral), U(nknown)
# MutationsTaster : A(utomatic), D(amaging), N(eutral),P(olymorfism)
# MutationAssessor : H(igh), M(edium), L(ow), N(eutral)
# FATHMM : D(eleterious), T(olerated)

filterCharacter<-function(myField,strict=FALSE){

    if (is.null(myField) || length(myField) != 1L || !myField %in% unique(diffAnnot_char$field)) {
    stop("myField argument must be one of: 'SIFT_pred','Polyphen2_HDIV_pred','Polyphen2_HVAR_pred','LRT_pred',
    'MutationTaster_pred','MutationAssessor_pred','FATHMM_pred'")
    }

    tmpSubset<-diffAnnot_char[diffAnnot_char$field==myField,]

    if(myField%in%c("SIFT_pred","LRT_pred","FATHMM_pred")){
        topclass<-"D"
    } else if (myField%in%c("Polyphen_HDIV_pred","Polyphen2_HVAR_pred")&strict==FALSE){
        topclass<-c("D","P")
     } else if (myField%in%c("Polyphen_HDIV_pred","Polyphen2_HVAR_pred")&strict==TRUE){
        topclass<-c("D")
    } else if (myField=="FATHMM_pred"&strict==FALSE){
        topclass<-c("H","M")
    } else if (myField=="FATHMM_pred"&strict==FALSE){
        topclass<-c("H")
    } else {
        topclass<-c("A","D")
    }

    interesting<-tmpSubset%>%
        filter(new%in%topclass)%>%
        filter(is.na(old) | !old%in%topclass)
    return(interesting)
}

# which field have uniquely numeric outcome?
num_fields<-gsub("_score", "",unique(diffAnnot_num$field))
char_fields<-gsub("_pred", "",unique(diffAnnot_char$field))
setdiff(num_fields,char_fields)
# [1] "VEST3"               "CADD_raw"            "CADD_phred"
# [4] "GERP.._RS"           "SiPhy_29way_logOdds"

# VEST3 and CADD_phred are most relevant to probability to be disease causing
# GERP and SiPhy= evolutionalry conservation

# filter out variant with biologically relevant change in annotation

# VEST3 = p-value
subVEST3<-diffAnnot_num[diffAnnot_num$field=="VEST3_score",]
table(subVEST3$old<0.05)
table(subVEST3$new<0.05)

table(subVEST3$old<0.05,subVEST3$new<0.05,useNA="always")

interestingVEST<-subVEST3%>%
    filter(new<0.05)%>%
    filter(is.na(old)|old>0.05)

# CADD_raw = the higher, the more likely to be deleterious
# but cannot be used to compare across CADD versions
# https://cadd.gs.washington.edu/info
# use CADD_phred instead for cutoff of deleteriousness
subCADD_raw<-diffAnnot_num[diffAnnot_num$field=="CADD_raw",]
subCADD_phred<-diffAnnot_num[diffAnnot_num$field=="CADD_phred",]

# if CADD_score >10 : 10% most deleterious in human genome
# if CADD_score >20 : 1% most deleterious in human genome
table(subCADD_phred$old>10)
table(subCADD_phred$new>10)

table(subCADD_phred$old>20,subCADD_phred$new>20,useNA="always")

# GERP : measure for evolutionary constring
# https://genome.ucsc.edu/cgi-bin/hgTrackUi?db=hg19&g=allHg19RS_BW
# RS score threshold of 2 provides high sensitivity while still strongly enriching for truly constrained sites.

subGERP<-diffAnnot_num[diffAnnot_num$field=="GERP.._RS",]
table(subGERP$old>2)
table(subGERP$new>2)
table(subGERP$old>2,subGERP$new>2,useNA="always")
interestingGERP<-subGERP%>%
    filter(new>2)%>%
    filter(is.na(old)|old<2)

subSiPhy<-diffAnnot_num[diffAnnot_num$field=="SiPhy_29way_logOdds",]
quantile(subSiPhy$new,seq(0,1,0.1),na.rm=T)
#     0%    10%    20%    30%    40%    50%    60%    70%    80%    90%   100% 
#  0.182  2.277  4.034  4.584  5.615  7.206  8.217  9.489 11.936 14.232 20.474

interestingSiPhy<-subSiPhy%>%
    filter(new>14)%>%
    filter(is.na(old)|old<14)

# no cutoff found in literature
#take 90th percentile

#function to select variants with relevant change in annotation
filterNumeric<-function(myField,myCutoff){

    if (is.null(myField) || length(myField) != 1L || !myField %in% c("CADD_phred", "VEST3_score","GERP.._RS","SiPhy_29way_logOdds")) {
    stop("myField argument must be one of: 'CADD_phred','VEST3_score','GERP.._RS','SiPhy_29way_logOdds'")
    }

    tmpSubset<-diffAnnot_num[diffAnnot_num$field==myField,]
    interesting<-tmpSubset%>%
        filter(new>myCutoff)%>%
        filter(is.na(old)|old<myCutoff)
    return(interesting)
}

interestCADD<-filterNumeric(myField = "CADD_phred",myCutoff=20)

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