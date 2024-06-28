## annotate subVCF with various annotations

# add folder with perl scripts from annovar to $PATH
# export PATH="/home/efransen/annovar:$PATH"

# /home/efransen
# subVCF are in folder ownVCF
# databases are in folder annovar/humandb


# run over all subVCFs in folder allsubVCF using find function
    # --> full path to file
# extract filename using basename function
# annotate using old and new SIFT/Polyphen
# write annotated VCF to subfolder myNewAnno resp. myOldAnno 

# user specifies which db to compare using positional arguments
# new = dbnsfp30a
# old = ljb26_all

# !/bin/bash

 oldannot=$1
 newannot=$2
 oldannotFolder=$3
 newannotFolder=$4

myDir=$(find /home/efransen/ownVCF/allsubVCF/ -type f -iname "*")

cd /home/efransen
 
for file in $myDir; do
        echo "$file"
        filename=$(basename $file)
        table_annovar.pl $file annovar/humandb/ -buildver hg19 -out outputAnnovar/myNewAnno$filename -remove -protocol $newannot -operation f -nastring . -polish
        table_annovar.pl $file annovar/humandb/ -buildver hg19 -out outputAnnovar/myOldAnno$filename -remove -protocol $oldannot -operation f -nastring . -polish
    done


# generate folders to store old resp. new annotations
# if directory does not exist yet (-p option)
# move old and new annotation to separate folders, 
# serving as input for R script to find differences
# outputfolder = part of positional argument

mkdir -p $oldannotFolder
mkdir -p $newannotFolder
mv outputAnnovar/myOldAnnosub* $oldannotFolder/
mv outputAnnovar/myNewAnnosub* $newannotFolder/


