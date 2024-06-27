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


myDir=$(find /home/efransen/ownVCF/allsubVCF/ -type f -iname "*")
 
for file in $myDir; do
        echo "$file"
        filename=basename $file
        table_annovar.pl $file annovar/humandb/ -buildver hg19 -out outputAnnovar/myNewAnno$filename -remove -protocol dbnsfp30a -operation f -nastring . -polish
        table_annovar.pl $file annovar/humandb/ -buildver hg19 -out outputAnnovar/myOldAnno$filename -remove -protocol ljb26_all -operation f -nastring . -polish
    done


# generate folders to store old resp. new annotations
# if directory does not exist yet (-p option)
# move old and new annotation to separate folders, 
# serving as input for R script to find differences

mkdir -p annotHg19_old
mkdir -p annotHg19_new
mv outputAnnovar/myNewAnnosub*hg19* annotHg19_new/
mv outputAnnovar/myOldAnnosub*hg19* annotHg19_old/




