#!/usr/bin/env Rscript
suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("stats"))

# specify our desired options in a list
# by default OptionParser will add an help option equivalent to 
# make_option(c("-h", "--help"), action="store_true", default=FALSE, 
#               help="Show this help message and exit")
option_list <- list( 
  make_option(c("-v", "--verbose"), action="store_true", default=TRUE,
              help="Print extra output [default]"),
  make_option(c("-c", "--count"), type="integer", default=10, 
              help="Number of random normals to generate [default %default]",
              metavar="number"),
  make_option("--generator", default="rnorm", 
              help = "Function to generate random deviates [default \"%default\"]"),
  make_option("--mean", default=0, 
              help="Mean if generator == \"rnorm\" [default %default]"),
  make_option("--sd", default=1, metavar="standard deviation",
              help="Standard deviation if generator == \"rnorm\" [default %default]"),
  make_option("--col", default="black", metavar = "color",
              help="What color to print"),
  make_option("--title", default="", metavar = "title",type="character",
              help="Title of the graph"),
  make_option("--reg", action = "store_true", default=FALSE,metavar = "regression",
              help="Add regression line"),
  make_option("--xlab", default="xVar",metavar = "X-label",type="character",
              help="Add X-axis label"),
  make_option("--ylab", default="yVar",metavar = "Y-label",type="character",
              help="Add Y-axis label")  
  
)

# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
opt <- parse_args(OptionParser(option_list=option_list))

# print some progress messages to stderr if "quietly" wasn't requested
if ( opt$verbose ) { 
  write("writing some verbose output to standard error...\n", stderr()) 
}

# do some operations based on user input
if( opt$generator == "rnorm") {
  myNumbers<-rnorm(opt$count, mean=opt$mean, sd=opt$sd)
} else {
 myNumbers<-do.call(opt$generator, list(opt$count))
}

xVar<-seq(from=1,to=opt$count)

pdf("myGraph.pdf")
plot(myNumbers~xVar,col=opt$col,main=opt$title,xlab=opt$xlab,ylab=opt$ylab)
if(opt$reg){
  abline(lm(myNumbers~xVar),col=opt$col)
}
dev.off()
cat("\n")
