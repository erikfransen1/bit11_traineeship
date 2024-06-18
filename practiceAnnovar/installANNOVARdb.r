pwd
# /home/efransen/annovar

## download databases for annotation to folder humandb
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar refGene humandb/

annotate_variation.pl -buildver hg19 -downdb cytoBand humandb/

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar exac03 humandb/ 

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp147 humandb/ 

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar dbnsfp30a humandb/

# add old versions of databases
# refgene 2021
annotate_variation.pl -buildver hg18 -downdb -webfrom annovar refGene humandb/

# Sift, polyphen, etc... 2014
annotate_variation.pl -buildver hg18 -downdb -webfrom annovar ljb26_all humandb/
#	whole-exome SIFT, PolyPhen2 HDIV, PolyPhen2 HVAR, LRT, MutationTaster, 
#    MutationAssessor, FATHMM, MetaSVM, MetaLR, VEST, CADD, GERP++, PhyloP and SiPhy scores 
#    from dbNSFP version 2.6