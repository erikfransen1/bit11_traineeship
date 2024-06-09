#!/usr/bin/env Rscript
# Copyright 2010-2013 Trevor L Davis <trevor.l.davis@gmail.com>
# Copyright 2008 Allen Day
#  
#  This file is free software: you may copy, redistribute and/or modify it  
#  under the terms of the GNU General Public License as published by the  
#  Free Software Foundation, either version 2 of the License, or (at your  
#  option) any later version.  
#  
#  This file is distributed in the hope that it will be useful, but  
#  WITHOUT ANY WARRANTY; without even the implied warranty of  
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU  
#  General Public License for more details.  
#  
#  You should have received a copy of the GNU General Public License  
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.  
suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("stats"))
suppressPackageStartupMessages(library("vcfR"))

# specify our desired options in a list
# by default OptionParser will add an help option equivalent to 
# make_option(c("-h", "--help"), action="store_true", default=FALSE, 
#               help="Show this help message and exit")
option_list <- list( 
  make_option("--input", default=NULL,
              help="Specify input file"),
  make_option("--info",default=FALSE, action="store_true",
              help="Deliver info fields?")
)

# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
opt <- parse_args(OptionParser(option_list=option_list))


# do some operations based on user input
if(is.null(opt$input)) {
  cat("Error: inputfile missing")
} else {
  myVCF<-read.vcfR(opt$input)
  infoDF<-INFO2df(myVCF)
  if(opt$info){
    cat(paste("Info fields : \n"))
    cat(paste(names(infoDF),collapse="\n"))
  }
}
cat("\n")
