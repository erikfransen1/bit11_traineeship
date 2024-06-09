# Overview
## Preparation and practicing
Before actually taking off with the project, I had to learn several skills to work on the server and to handle and annotate VCF files. These were separately practiced before the actual development of the final code. They include:
- Slurm,the workflow manager on the server
-	vcfR, an R package to handle VCF files
-	biomaRt, and R package serving as API to access ensembl
-	ANNOVAR, software to annotate VCF files



### Slurm
The main jobs in this project - annotations of large VCF files - were carried out on a linux server with Ubuntu version **. Jobs on the server have to be submitted by the workload manager Slurm (version **). <br>
Slurm has three key functions to enable working on the server. First, it allocates access to resources (compute nodes) to users for some duration of time so they can perform work. Second, it provides a framework for starting, executing, and monitoring work on the set of allocated nodes. Finally, it arbitrates contention for resources by managing a queue of pending work.
The first task in this project was to practice working with Slurm. In particular, submitting R jobs to the server.<br>
Folder **practice Slurm** contains some exercises on the use of Slurm on the server. The Rscript *readin.R* contains commands to read in the input in the file *inputData.txt*. In the Rscript *graph.R* first reads in the data by sourcing the *readin.R*, then runs a custom-made function to generate a graph using tidyverse. The resulting graph is exported to the plot *meanOutcome(logscale).pdf*.<br>

### ANNOVAR
ANNOVAR is a flexible package to annotate VCF files. This program takes an input variant file (such as a VCF file) and generate a tab-delimited output file with many columns, each representing one set of annotations. Additionally, if the input is a VCF file, the program also generates a new output VCF file with the INFO field filled with annotation information. <br>
First step is downloading the appropriate database files using annotate_variation.pl. The code is shown in  practiceAnnovar/installANNOVARdb.r<br>
Next, the function table_annovar.pl annotates the variants in the VCF file and draws the output in the INFO field. In the practicing run, 4 input files (3VCF and one tab-delimited file) were annotated using the default setting of table_annovar. The code is in practiceAnnovar/practice_tableAnnovar.
The folder practiceAnnovar in the Git repository contains 3 subfolders:
- outputVCFfromTutorial : practice on ex1.avinput and ex2.vcf (files from ANNOVAR quick startup guise)
- outputSample.vcf : practice on small VCF file supplied by external supervisors
- outputChr4.vcf : practice on VCF with variants on Chr4 (supplied by external supervisors)<br>
Subsequently, the output from ANNOVAR (ie. the annotated files) were read in via vcfR.<br>
<br>


### vcfR
vcfR (version 1.15.0) is an R package to handle vcf files in R. We applied vcfR to the VCF files annotated with ANNOVAR, and the code is shown in the githyub repository in folder practiceVCF The document practiceVCF/practiceAnnotVCF_sample.R shows application of vcfR onto the sample.vcf file (supplied by external supervisors).<br>
On two occasions, we received error messages. The first time was due to the presence of the field "GERP++" in one of the INFO fields. The "++" is a regular expression causing an error in the INFO2df() function. This was fixed using the code in document practiceVCF/troubleshootingRegex.r.<br>
Some more advanced exploration of a vcf file, involving more use of tidyverse functions, was carried out in the script practiceVCF/practiceAnnotVCF_tidyverseSet6.R.
