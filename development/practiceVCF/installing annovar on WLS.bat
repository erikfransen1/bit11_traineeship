# installing annovar on WLS
gunzip annovar.latest\ \(1\).tar.gz
tar -xvf annovar.latest\ \(1\).tar 

# put all files in folder annovar

# download databases

perl annotate_variation.pl -buildver hg19 -downdb -webfrom annovar refGene humandb/

perl annotate_variation.pl -buildver hg19 -downdb cytoBand humandb/

perl annotate_variation.pl -buildver hg19 -downdb -webfrom annovar exac03 humandb/ 

perl annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp147 humandb/ 

perl annotate_variation.pl -buildver hg19 -downdb -webfrom annovar dbnsfp30a humandb/

perl table_annovar.pl example/ex1.avinput humandb/ -buildver hg19 -out myanno -remove -protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a -operation gx,r,f,f,f -nastring . -csvout -polish -xref example/gene_xref.txt

