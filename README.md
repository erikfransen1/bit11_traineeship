# Overview

The purpose of this project was to develop a tool to re-annotate old VCF files using the currently available annotations, and compare the present-day annotations to the annotations based upon older databases.

Since part of the project was about learning additional skills regarding handling of VCF files, annotation software and working on a server, we kept the scripts from this practicing phase in the Github page under the subdirectory 'development'. The actual scripts the tool consists of, including the masterscript, are given in the main directory. The subdirectory 'examplefiles' contains short VCF files and intermediate files that can serve to test and practice the script.


## Development subdirectory
Before actually taking off with the project, several skills were trained to work on the server and to handle and annotate VCF files. These were separately practiced before the actual development of the final code. They include:
-   Slurm,the workflow manager on the server
-	ANNOVAR, software to annotate VCF files
-	vcfR, an R package to handle VCF files
-	biomaRt, and R package serving as API to access ensembl
-   optparse, an R package serving as a command line parser


### Slurm
In the initial phase of this project, the main jobs in this project - annotations of large VCF files - were carried out on a linux server with Ubuntu version **. Jobs on the server have to be submitted by the workload manager Slurm (version **). <br>
Slurm has three key functions to enable working on the server. First, it allocates access to resources (compute nodes) to users for some duration of time so they can perform work. Second, it provides a framework for starting, executing, and monitoring work on the set of allocated nodes. Finally, it arbitrates contention for resources by managing a queue of pending work.
The first task in this project was to practice working with Slurm. In particular, submitting R jobs to the server.<br>
Subdirectory **practice Slurm** contains some exercises on the use of Slurm on the server. The Rscript *readin.R* contains commands to read in the input in the file *inputData.txt*. In the Rscript *graph.R* first reads in the data by sourcing the *readin.R*, then runs a custom-made function to generate a graph using tidyverse. The resulting graph is exported to the plot *meanOutcome(logscale).pdf*.<br>
Due to the outage of the server later in the project, using Slurm was no longer an option.<br>

### ANNOVAR
ANNOVAR is a flexible package to annotate VCF files. This program takes an input variant file (such as a VCF file) and generate a tab-delimited output file with many columns, each representing one set of annotations. Additionally, if the input is a VCF file, the program also generates a new output VCF file with the INFO field filled with annotation information. <br>
Setup and practice of ANNOVAR is shown in the Github repository under the subdirectory **practiceAnnovar**. First step is downloading the appropriate database files using annotate_variation.pl. The code is shown in *installANNOVARdb.r*. Further code from the Quick startup guide is shown in *practiceAnnovarTutorial*.
The function table_annovar.pl annotates the variants in the VCF file and draws the output in the INFO field. In the practicing run, 4 input files (3VCF and one tab-delimited file) were annotated using the default setting of table_annovar. The code is in *practice_tableAnnovar*.<br>
The folder practiceAnnovar in the Git repository contains 3 subfolders:
- outputVCFfromTutorial : practice on ex1.avinput and ex2.vcf (files from ANNOVAR quick startup guise)
- outputSample.vcf : practice on small VCF file supplied by external supervisors
- outputChr4.vcf : practice on VCF with variants on Chr4 (supplied by external supervisors)<br>
Subsequently, the output from ANNOVAR (ie. the annotated files) were read in via vcfR.<br>
Annotation using ANNOVAR became an essential part of the tool that was developed during this project.
<br>

### vcfR
vcfR (version 1.15.0) is an R package to handle vcf files in R. We applied vcfR to the VCF files annotated with ANNOVAR, and the code is shown in the Github repository in subdirectory **practiceVCF**. The document *practiceAnnotVCF_sample.R* shows application of vcfR onto the *sample.vcf* file (supplied by external supervisors).<br>
Some more advanced exploration of a vcf file, involving more use of tidyverse functions, was carried out in the script practiceVCF/practiceAnnotVCF_tidyverseSet6.R.<br>
On two occasions while working with VCF files, we received error messages. These are shown in the code *errorMessages.R*. The first time was due to the presence of the field "GERP++" in one of the INFO fields. The "++" is a regular expression causing an error in the INFO2df() function. This was fixed using the gsub() function, as shown in the code.<br> Subsequently, one of the VCF files showed an error message due to a non-unique ID. The solution to this problem is shown in the subdirectory **nonUniqueID** (see next paragraph).<br>
Using vcfR, we developed a custom-made R function for quality checking a VCF, including: 
- searching for missing values,
- plotting missing values per sample and per variant,
- searching extreme values per sample
- set extreme values to missing
- report the changes with regard to the original input VCF<br>
This code is supplied in *QC.R*. However, this function was not used further down the project.

### nonuniqueID
Upon practicing with the VCF files using vcfR, we encountered an error message about the presence of duplicate IDs. The files related to this are given in teh folder **nonUniqueID**. This is shown in code *errorMessages_vcfR.R*. The search where these duplicate IDs arise, and what functions are not working, is shown in *troubleshoot duplicates.R*. Although these duplicate IDs shouldn't be present in a VCF file, we developed a custom made R function to detect these duplicate IDs, print a list of duplicate IDs and set the duplicate IDs to missing. The code is given in *troubleshoot duplicates_function.R*, and is applied to the problematic VCF file in *applyDuplicateFunction_vcfChr4.R*.

### biomaRt
biomaRt is an R package serving as an API to access ensembl. The script *practiceBiomaRt.R* in the subdirectory **practiceBiomaRt** contains code from a biomaRt tutorial. Further down the project, however, biomaRt was not used any more.<br> 

### optparse
The automation of the planned script will require running R scripts at the command line. This can be achieved with the command Rscript in bash. Passing on positional arguments at the commandline to the R functions inside the script is enabled by the optparse R package. Examples and code are in the folder **practiceOptparse**<br>
The *sayHello.R* is a toy example from an R function to be ran at the command line. The scripts *display_file.R* and *example.R* were retrieved from optparse tutorials. The *printScatter.R* is a script that generates a simple scatterplot, but with the arguments from the plot() function (including adding a title, X and Y axis labels, adding a regression line, specifying th color,...) in R supplied via the optparse arguments. The script *parseVCF.R* is a script to parse a VCF file using optparse.<br>
<br>

### vcfstats
To obtain a quick overview of the INFO fields in an annotated VCF files, we explored efficient ways for visualization. Apart from the aforementioned vcfR package, several packages for visualizing VCF files are available, including the Bioconductor package plotVCF or vcfstats (subdirectory **practiceVCFstats**). This latter package plots specific metics of the VCF, with the possibility to customize the plots and focus on variants with certain filters. At the time of the project when the server was down, this was the program of choice to visualize the VCF files, as it does not need to load the full VCF into the memory and allows working with large VCF files in the virtual box.<br>
The code for some initial exercises is in *vcfstats_commands*. Due to trouble with the installation with pip, the program had to be ran via docker. In later stages of the project, we stopped using this package due to the rathre user-unfriendly coding language and problems with installing it. We visualized the data using a combination of vcfR with ggplot2. <br>



## Development of a tool to detect and visualize differential annotations

### split one large VCF into subVCF (splitVCF_wsl.R)
Due to the outage of the server and the scarcity of online VCF files, we needed a number of different VCF files to be able to develop our code for automation. In addition, working with smaller files reduced the computing time during the test runs. Therefore, we developed the splitVCF_wsl.R one large initial VCF was split into 10 VCF files (hereafter referred to as 'subVCF') of 100,000 lines each using the splitVCF_wsl.R script. The meta-part of the original VCF was preserved and used in all subVCF files.<br>
The **examplefiles** directory contains 4 of the 10 subVCFs that were used to develop the code.<br>

### Annotate multiple VCFs with database of choice (annotPositArg.sh)
These 10 resulting VCF files were used to create an annotation script that compares annotation between different databases, automatically running through all input subVCFs. This included several levels of automation:
- automatically running through all 10 files using a for-loop in bash
- using positional arguments to :
    - specify what databases (or versions thereof) were to be compared 
    - specify the output directory to store the VCF with the old resp. new annotations 
    - specify the directory where the input VCFs are located<br>
Resulting annotated VCF files are stored in 2 separate folders for the old resp. new annotations. These serve as input for an R script listing the differences between the old and the new annotation.

### List differential annotation (listDiffAnnot.R)
This R script reads in the output from the previous (annotPositArg.sh) script, for each VCF reading in the old and new annotations respectively. Then the script seaches for INFO fields that are common to the old and new annotations, and subsequently loops over all common INFO fields, saving the differentially annotated fields in an output table. The table also includes variants with some annotation in the new database that had no annotation in the old one.<br>
The list of differentially annotated variants serves as input for the next script, where the biologically relevant variants are detected.

### Prioritize biologically relevant differential annotations (prioritizeDiffAnnot.R)
The previously generated table with differential annotations contains all variants having a different annotation in the oldversus the new database, but not all changes may be biologically relevant. In particular, researchers are primarily interested in variants that potentially affect protein function. The *prioritizeDiffAnnot.R* contains two functions (one for numeric and one for character annotations) to search for variants that are predicted to be functional in the new annotations, while they were un-annotated or predicted to be nonfunctional in the old annotation. <br>
The annotation field of interest must be specified by the user. For numeric annotations, the script uses the recommended cutoff for biological relevance for the given annotation field to pick out the variants that were below this cutoff in the previous annotation, but above cutoff in the new annotation. For character annotations, where variants are typically classified a damaging or possibly damaging, the user can specify a level of stringency: are only variants considered for which the new annotation predicts the strongest effect on protein function (eg probably damaging), or are also variants included with a less certain effect on protein function (eg. possibly damaging). <br>
The script in its current state only works for functional annotation fields common to two db for the prediction of nonsynonymous variants : ljb26_all (old) and dbnsfp30a (new). The cutoffs for the different fields are hard-coded, so there is not (yet) flexibility to use this script for other annotations databases. 

### Visualize biologically relevant differential annotation (visualizeDiffAnnot.R)
This is a script that lists or visualizes the differential annotations and the subset that becomes biologically relevant in the new annotation. Mandatory arguments include the VCF and the annotation field of interest (only one VCF and one annotation field can be visualized at a time). Selecting a gene of interest is optional (default FALSE). Starting for all differential annotations in a given input VCF for a given annotation field, the prioritizing functions discussed above are applied to flag the newly deleterious variants that were un-annotated or not likely to be deleterious in the previous database. An optional argument exonicOnly (default=FALSE) specifies if only exonic variants are shown.
In case no gene of interest is specified, all variants across all genes are shown/listed. In case a gene of interest is specified, only variants within this gene are given, with error messages if the gene is not recognized or if no differentially annotated variants are present in the gene of interest. <br>
The output type argument offers 3 possibilities: option "table" returns a dataframe with the newly deleterious variants, which is saved as a .txt file in the current working directory. With the option "scatter", the user can choose for a scatterplot showing the old annotation versus the new one, with a different color for the newly deleterious variants. For the character annotations, a jitterplot is generated to avoid overplotting. The third option "barplot" generates a bar chart, counting the number of differential and newly deleterious variants either per type of variant (if exonicOnly=FALSE) or per type of exonic function type (if exonicOnly=TRUE). The graphs are exported to a .pdf file in the current working directory.

### Masterscript
The masterscript automates the above steps, allowing to carry out the entire workflow in 1 command, using positional arguments passed throug the optparse package.<br>
The first program to split up the large VCF into small subVCF files (*splitVCF_wsl.R*), is not part of this masterscript. The step to annotate one or more raw VCF files (*annotPositArg.sh*), is optional, allowing to carry out the comparison of annotations on previously anotated files. Starting from either the newly annotated VCF files, or the pre-existing annotated VCF files, the differentially annotated variants are listed (*listDiffAnnot.R*), the variants that are predicted to be deleterious in the new database are flagged (*prioritizeDiffAnnot.R*) and all differentially annotated variants in one VCF of choice and one annotation field of choice are visualized in a graph or listed in a table.. 

## examplefiles directory
The **examplefiles** directory contains input files that can be used to test the program. SubVCF1-4 are raw, unannotated VCF files that are part of the larger *NA12848vcf.gz* file. The R objects *diffAnnot_char.rda* and *diffAnnot_num.rda* are two dataframes that are the output of the listDiffAnnot.R script, listing the differentially annotated variants for the character resp. numeric annotation fields that are common between databases ljb26_all (old) and dbnsfp30a (new). These files can serve as input for the *prioritizeDiffAnnot.R* and *visualizeDifAnnot.R* scripts.