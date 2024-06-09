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
Folder **practice Slurm** contains some exercises on the use of Slurm on the server. The Rscript *readin.R* contains commands to read in the input in the file *inputData.txt*. In the Rscript *graph.R* first reads in the data by sourcing the *readin.R*, then runs a custom-made function to generate a graph using tidyverse. The resulting graph is exported to the plot *meanOutcome(logscale).pdf*.

### ANNOVAR
ANNOVAR is a flexible package to annotate VCF files. This program takes an input variant file (such as a VCF file) and generate a tab-delimited output file with many columns, each representing one set of annotations. Additionally, if the input is a VCF file, the program also generates a new output VCF file with the INFO field filled with annotation information. <br>


### vcfR
vcfR (version 1.15.0) is an R package to handle vcf files in R. The tutorial 
