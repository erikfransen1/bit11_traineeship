#!/usr/bin/env Rscript
suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("stats"))
suppressPackageStartupMessages(library("tidyverse"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("Hmisc"))
suppressPackageStartupMessages(library("vcfR"))


# specify our desired options in a list
# by default OptionParser will add an help option equivalent to 
# make_option(c("-h", "--help"), action="store_true", default=FALSE, 
#               help="Show this help message and exit")
option_list <- list( 
  make_option(c("-v", "--verbose"), action="store_true", default=TRUE,
        help="Print extra output [default]"),
  make_option("--oldDb", default="ljb26_all", metavar="Old annotation database",,type="character",
              help = "Old database for annotation of functional variants. Currently only ljb26_all is supported"),
  make_option("--newDb", default=,"dbnsfp30a", metavar="New annotation database", ,type="character",
              help = "New database for annotation of functional variants. Currently only ljb26_all is supported"),
  make_option("--oldDir", default="oldAnnot", ,type="character",
              help="Directory to store VCF with old annotation"),
  make_option("--newDir", default="newAnnot", type="character",
              help="Directory to store VCF with new annotation"),
  make_option("--VCFdir", default=".", metavar = "VCF directory",type="character",
              help="Subdirectory where the raw VCF files are located"),
  make_option("--workdir", default=".", metavar = "Home directory",type="character",
                help="Home directory (oldDir and newDir must be subdirectory of this directory)"),
  make_option("--VCF", metavar = "VCF file",
              help="VCF from which differential annotation have to be visualized"),
  make_option("--field", metavar = "Annotation field",
              help="Annotation field from which differential annotation have to be visualized"),
  make_option("--gene", metavar = "Gene of interest",
              help="Gene from which differential annotation have to be visualized. 
              If no gene is selected, all differentially annotated variants are shown"),
  make_option("--output", default="barplot",metavar = "Output type",type="character",
              help="Which output should be generated to visualize differential annotation? 
              Current options include barplot (default), scatterplot, table"),
  make_option("--exonic", action="store_true", default=FALSE,
              help="Include only exonic variants in visualization. 
              In case a scatterplot is selected, the exonic functions (stopgain, synonymous...) 
              are plotted instead of the default functional annotation (exonic, intronic, 3'UTR...)"),
  make_option("--need2annot", action="store_true", default=FALSE,
              help="Is annotation using ANNOVAR needed (default no)? 
              If not selected, the program searches for existing annotated VCFs in the oldDb and newDb directories") 
)

# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
opt <- parse_args(OptionParser(option_list=option_list))

# print some progress messages 
if ( opt$verbose ) { 
  write(paste("Comparing annotations between ",opt$oldDb,"and",opt$newDb)) 
}

# run ANNOVAR if requested
if(opt$need2annot==TRUE){
    write(paste("Running ANNOVAR using on all VCF files in directory",opt$VCFdir))
    system(paste("~/annotPositArg.sh",opt$oldDb,opt$newDb,opt$oldDir,opt$newDir,opt$VCFdir))
}else{
    write(paste("Retrieving previously annotated VCFs form directories",opt$oldDir,"and",opt$newDir))
}



source("listDiffAnnot.r")
# function to :
    # retrieve annotated files from old resp. new folders 
    # list alls differentially annotated variants
    # among all VCF.txt files in a given directory
listDiffAnnot(workdir=opt$workdir, subdirOld=opt$oldDir,subdirNew=opt$newDir)

# output from listDiffAnnot = 2 dataframes with all differentially annotated variants
# source function for prioritizing and visualization

source("prioritizeDiffAnnot.r")
source("visualizeDiffAnnot.r")

plotDiffAnnot(VCF=opt$VCF,field=opt$field,outputType=opt$output,exonicOnly=opt$exonic,geneOfInt=opt$gene)