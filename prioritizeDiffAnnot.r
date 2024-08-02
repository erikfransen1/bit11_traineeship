# Prioritize differentially annotated variants
#################################################

# only available for 2 databases !

# unique(diffAnnot_num$field)
# [1] "SIFT_score"             "Polyphen2_HDIV_score"   "Polyphen2_HVAR_score"
# [4] "LRT_score"              "MutationTaster_score"   "MutationAssessor_score"
# [7] "FATHMM_score"           "VEST3_score"            "CADD_raw"
#[10] "CADD_phred"             "GERP.._RS"              "SiPhy_29way_logOdds"

# unique(diffAnnot_char$field)
# [1] "SIFT_pred"             "Polyphen2_HDIV_pred"   "Polyphen2_HVAR_pred"
# [4] "LRT_pred"              "MutationTaster_pred"   "MutationAssessor_pred"
# [7] "FATHMM_pred"


##############################
#### Character fields ####
##############################

# character fields are more biologically relevant
# most interesting = change to D(eleterious)
# see https://genome.ucsc.edu/cgi-bin/hgVai
# main diagonal is always empty !!! Has been selected against in previous step

## Explore levels of predicted damage to functioning of the protein

# SIFT : D(amaging) or T(olerated)
# Polyphen : D(amaging); P(ossibly damaging), B(enign)
# LRT_pred : D(eleterious), N(eutral), U(nknown)
# MutationsTaster : A(utomatic), D(amaging), N(eutral),P(olymorfism)
# MutationAssessor : H(igh), M(edium), L(ow), N(eutral)
# FATHMM : D(eleterious), T(olerated)

# function to select diff. annotated variants likely to damage protein functioning
# that were not recognized in previous version of database

filterCharacter<-function(field,strict=FALSE){

  load("diffAnnot_char.rda")
  load("diffAnnot_num.rda")

    if (is.null(field) || length(field) != 1L || !field %in% unique(diffAnnot_char$field)) {
    stop("field argument must be one of: 'SIFT_pred','Polyphen2_HDIV_pred','Polyphen2_HVAR_pred','LRT_pred',
    'MutationTaster_pred','MutationAssessor_pred','FATHMM_pred'")
    }

    tmpSubset<-diffAnnot_char[diffAnnot_char$field==field,]

    if(field%in%c("SIFT_pred","LRT_pred","FATHMM_pred")){
        topclass<-"D"
    } else if (field%in%c("Polyphen_HDIV_pred","Polyphen2_HVAR_pred")&strict==FALSE){
        topclass<-c("D","P")
     } else if (field%in%c("Polyphen_HDIV_pred","Polyphen2_HVAR_pred")&strict==TRUE){
        topclass<-c("D")
    } else if (field=="FATHMM_pred"&strict==FALSE){
        topclass<-c("H","M")
    } else if (field=="FATHMM_pred"&strict==FALSE){
        topclass<-c("H")
    } else {
        topclass<-c("A","D")
    }

    newDel<-tmpSubset%>%
        filter(new%in%topclass)%>%
        filter(is.na(old) | !old%in%topclass)
    return(newDel)

    rm(tmpSubset,topclass)
    gc()
}


#############################
##### Numeric fields ########
#############################

#function to select variants with relevant change in annotation
filterNumeric<-function(field){

load("diffAnnot_char.rda")
load("diffAnnot_num.rda")

    if (is.null(field) || length(field) != 1L || !field %in% c("CADD_phred", "VEST3_score","GERP.._RS","SiPhy_29way_logOdds")) {
    stop("field argument must be one of: 'CADD_phred','VEST3_score','GERP.._RS','SiPhy_29way_logOdds'")
    }

    # use recommended cutoffs for numeric annotation fields
    if(field=="CADD_phred"){
        myCutoff<-20
        print("Used recommended cutoff for CADD_phred (20  = 1% most deleterious in human genome)")
    }else if(field=="VEST3_score"){
        myCutoff<-0.05
        print("Used recommended cutoff for VEST3_score (0.05 = threshold for significance)")
    }else if(field=="GERP.._RS"){
        myCutoff<-2
        print("Used recommended cutoff for GERP (2)")
    }else{
        myCutoff<-14.2
        print("Used recommended cutoff for SiPhy_29way_logOdds (14.2 = 90th percentile)")
    }

    newDel<-diffAnnot_num%>%
        filter(field==field)%>%
        filter(new>myCutoff)%>%
        filter(is.na(old)|old<myCutoff)
    return(newDel)
}
