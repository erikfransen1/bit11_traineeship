

#### function to:
  ##  detect duplicate IDs
  ##  print list of duplicate IDs
  ##  set duplicate ID to missing

detect_dupl_ID<-function(inputVCF){
  
  # convert fixed part to DF
  allFix<-as.data.frame(getFIX(inputVCF))
  
  # only carry out function if there are duplicate ID
  if(length(names(table(allFix$ID)[table(allFix$ID)>1]))>0){
    
    # what ID are duplicated?
    duplID<-names(table(allFix$ID)[table(allFix$ID)>1])
    
    # allow for >1 ID duplicated
    nDupl<-length(duplID)
    
    # first convert fixed part of VCF to dataframe 
    # and perform grep in DF
    fixDF<-as.data.frame(getFIX(inputVCF))
    
    # run thru all duplicated IDs
    # sending message about setting ID to missing
    
    for(i in 1:nDupl){
      
      print(paste("ID",duplID[i],"is duplicated"))
      print(paste("Setting ID",duplID[i],"to missing"))
      
      duplIDLines<-grep(duplID[i],fixDF$ID)
      
      # put ID from duplicated ID to missing
      # must be NA, not "."
      inputVCF@fix[duplIDLines,"ID"]<-NA
    }
  }
  inputVCF
}



