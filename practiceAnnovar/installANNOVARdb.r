pwd
# /home/efransen/annovar

## download databases for annotation to folder humandb
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar refGene humandb/

annotate_variation.pl -buildver hg19 -downdb cytoBand humandb/

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar exac03 humandb/ 

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp147 humandb/ 

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar dbnsfp30a humandb/

## add old versions of databases
# refgene 2021 (versus hg19 refgene)
annotate_variation.pl -buildver hg18 -downdb -webfrom annovar refGene humandb/

# Sift, polyphen, etc... 2014 (versus dbnsfp30a)
annotate_variation.pl -buildver hg18 -downdb -webfrom annovar ljb26_all humandb/
#	whole-exome SIFT, PolyPhen2 HDIV, PolyPhen2 HVAR, LRT, MutationTaster, 
#    MutationAssessor, FATHMM, MetaSVM, MetaLR, VEST, CADD, GERP++, PhyloP and SiPhy scores 
#    from dbNSFP version 2.6

# found in GWAS
annotate_variation.pl -build hg19 -downdb gwasCatalog humandb/

# old dbSNP (versus avsnp147)
annotate_variation.pl -buildver hg18 -downdb -webfrom annovar snp128 humandb/

# old clinvar
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar clinvar_20131105 humandb/

# new clinvar
annotate_variation.pl -buildver hg38 -downdb -webfrom annovar clinvar_20240611 humandb/



