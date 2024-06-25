## annotate subVCF with various annotations

# add folder with perl scripts from annovar to $PATH
export PATH="/home/efransen/annovar:$PATH"

pwd
# /home/efransen
# subVCF are in folder ownVCF
# databases are in folder annovar/humandb


# annotate using old and new SIFT/Polyphen
table_annovar.pl ownVCF/subVCF1 annovar/humandb/ -buildver hg19 -out outputAnnovar/myNewanno -remove -protocol dbnsfp30a -operation f -nastring . -polish
table_annovar.pl ownVCF/subVCF1 annovar/humandb/ -buildver hg19 -out outputAnnovar/myOldanno -remove -protocol ljb26_all -operation f -nastring . -polish

# run over all subVCFs
myDir="/ownVCF/allsubVCF"

for file in subVCF1 subVCF2 subVCF3  subVCF4  subVCF5  subVCF6  subVCF7  subVCF8  subVCF9
    do
        # echo "$file"

        table_annovar.pl ownVCF/allsubVCF/$file annovar/humandb/ -buildver hg19 -out outputAnnovar/myNewAnno$file -remove -protocol dbnsfp30a -operation f -nastring . -polish
        table_annovar.pl ownVCF/allsubVCF/$file annovar/humandb/ -buildver hg19 -out outputAnnovar/myOldAnno$file -remove -protocol ljb26_all -operation f -nastring . -polish
    done    

# trying to automate
for file in "$myDir"/*
    do 
        echo "$file" 
    done

# generate folders to store old resp. new annotations
mkdir annotHg19_old
mkdir annotHg19_new
mv outputAnnovar/myNewAnnosub*hg19* annotHg19_new/
mv outputAnnovar/myOldAnnosub*hg19* annotHg19_old/

