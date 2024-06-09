## download databases for annotation to folder humandb
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar refGene humandb/

annotate_variation.pl -buildver hg19 -downdb cytoBand humandb/

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar exac03 humandb/ 

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp147 humandb/ 

annotate_variation.pl -buildver hg19 -downdb -webfrom annovar dbnsfp30a humandb/

