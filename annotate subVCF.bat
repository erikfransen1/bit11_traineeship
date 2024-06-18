## annotate subVCF with various annotations

# add folder with perl scripts from annovar to $PATH
export PATH="/home/efransen/annovar:$PATH"

pwd
# /home/efransen
# subVCF are in folder ownVCF
# databases are in folder annovar/humandb

perl table_annovar.pl ownVCF/subVCF1 annovar/humandb -buildver hg19 -out myanno -remove -protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a -operation gx,r,f,f,f -nastring . -csvout -polish -xref example/gene_xref.txt
