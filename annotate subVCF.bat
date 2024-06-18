## annotate subVCF with various annotations

# add folder with perl scripts from annovar to $PATH
export PATH="/home/efransen/annovar:$PATH"

pwd
# /home/efransen
# subVCF are in folder ownVCF
# databases are in folder annovar/humandb

# annotate using old and new refGene
table_annovar.pl ownVCF/subVCF1 annovar/humandb -buildver hg19 -out outputAnnovar/myNewAnno -remove -protocol refGene -operation g -nastring . -csvout -polish 
table_annovar.pl ownVCF/subVCF1 annovar/humandb -buildver hg18 -out outputAnnovar/myOldAnno -remove -protocol refGene -operation g -nastring . -csvout -polish 


