# !/bin/bash

## annotate subVCF with various annotations

# subVCF are in folder ownVCF/allsubVCF
# databases are in folder annovar/humandb
#all of which aer subfolders of the home directory

# run over all subVCFs in folder allsubVCF using find function
    # --> full path to file
# extract filename using basename function
# annotate using old and new SIFT/Polyphen
# write annotated VCF to subfolder myNewAnno resp. myOldAnno 

# user specifies which db to compare using positional arguments
# new = dbnsfp30a
# old = ljb26_all

# system("\\./annotPositArg.sh ljb26_all dbnsfp30a oldAnnot4 newAnnot4 /home/efransen/ownVCF/allsubVCF/")

 oldannot=$1
 newannot=$2
 oldannotFolder=$3
 newannotFolder=$4
 workdir=$5

myDir=$(find $workdir -type f -iname "*")

cd /home/efransen
 
for file in $myDir; do
        echo "$file"
        filename=$(basename $file)
        perl ~/annovar/table_annovar.pl $file ~/annovar/humandb/ -buildver hg19 -out ~/outputAnnovar/myNewAnno$filename -remove -protocol refGene,$newannot -operation g,f -nastring . -polish -vcfinput
        perl ~/annovar/table_annovar.pl $file ~/annovar/humandb/ -buildver hg19 -out ~/outputAnnovar/myOldAnno$filename -remove -protocol refGene,$oldannot -operation g,f -nastring . -polish -vcfinput
    done


# generate folders to store old resp. new annotations
# if directory does not exist yet (-p option)
# move old and new annotation to separate folders, 
# serving as input for R script to find differences
# outputfolder = part of positional argument

mkdir -p $oldannotFolder
mkdir -p $newannotFolder
mv ~/outputAnnovar/myOldAnnosub* $oldannotFolder/
mv ~/outputAnnovar/myNewAnnosub* $newannotFolder/

