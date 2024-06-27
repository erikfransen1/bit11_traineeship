# !/bin/bash
# bash with positional arguments
# ask for old and new annotation dbnsfp30a
# needed dos2unix script !!!

echo "enter old db, new db and filename"

 oldannot=$1
 newannot=$2
 file=$3


echo "Comparing $oldannot to $newannot for $file"

#carry out old and new annotation
table_annovar.pl ownVCF/allsubVCF/$file annovar/humandb/ -buildver hg19 -out outputAnnovar/myNewAnno$file -remove -protocol $newannot -operation f -nastring . -polish
table_annovar.pl ownVCF/allsubVCF/$file annovar/humandb/ -buildver hg19 -out outputAnnovar/myOldAnno$file -remove -protocol $oldannot -operation f -nastring . -polish

# dbnsfp30a 
# ljb26_all 
# subVCF1

# generate folders to store old resp. new annotations
#if these folders don't exit yet
mkdir -p annotHg19_old
mkdir -p annotHg19_new
mv outputAnnovar/myNewAnnosub*hg19* annotHg19_new/
mv outputAnnovar/myOldAnnosub*hg19* annotHg19_old/
