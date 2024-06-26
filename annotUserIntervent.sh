# !/bin/bash
# bash with positional arguments
# ask for old and new annotation dbnsfp30a
# needed dos2unix script !!!


# with user-defined input
read -p "Enter nothing: " nothing
read -p "Give the old annotation database: " oldannot
read -p "Give the new annotation database: " newannot
read -p "Give the name of your VCF file: " file 


echo "Comparing $oldannot to $newannot for $file"

carry out old and new annotation
table_annovar.pl ownVCF/allsubVCF/$file annovar/humandb/ -buildver hg19 -out outputAnnovar/myNewAnno$file -remove -protocol $newannot -operation f -nastring . -polish
table_annovar.pl ownVCF/allsubVCF/$file annovar/humandb/ -buildver hg19 -out outputAnnovar/myOldAnno$file -remove -protocol $oldannot -operation f -nastring . -polish
