# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("biomaRt")

library(biomaRt)

#list which marts are available in ensembl.org
listEnsembl()

#specify build
listEnsembl(GRCh=37)

listEnsembl(version=78)
# not aailable. CHeck which versions are available
listEnsemblArchives()
listEnsembl(version=77)

# list datasets inside mart object
ensembl <- useEnsembl(biomart="ensembl")
head(listDatasets(ensembl))

#specify subset of mart objects in ensembl
#onnect to database human 
grch37 <- useEnsembl(biomart="ensembl",GRCh=37)
listDatasets(grch37)

myEnsembl <- useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl", GRCh=37)
listDatasets(myEnsembl)
myEnsembl2 <- useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl", version=77)
listDatasets(myEnsembl)

#list available filters
listFilters(myEnsembl)

listAttributes(myEnsembl)

# Fetch all the Ensembl gene, 
# transcript IDs, HGNC symbols and 
# chromosome locations located on the human chromosome 1
chr1_genes <- getBM(attributes=c('ensembl_gene_id',
                                 'ensembl_transcript_id','hgnc_symbol','chromosome_name',
                                 'start_position','end_position'), 
                    filters = 'chromosome_name', 
                    values ="1", 
                    mart = myEnsembl)

#Example query: 
# Fetch Ensembl Gene, Transcript IDs,HGNC symbols and 
# Uniprot Swissprot accessions mapped to the human Ensembl Gene ID "ENSG00000139618"

hgnc_swissprot <- getBM(attributes=c('ensembl_gene_id',
                                     'ensembl_transcript_id','hgnc_symbol',
                                     'uniprot_swissprot'),
                        filters = 'ensembl_gene_id', 
                        values = 'ENSG00000139618', 
                        mart = ensembl)

# mirror site
listMarts(host="https://uswest.ensembl.org")
