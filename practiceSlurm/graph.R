source("~Slurm/practice/readin.R")

library(tidyverse)
library(ggplot2)

# function to calculate mean over 3 biol. replicates
# at each timepoint
# plot on logscale

plotData<-function(data,outcome){
  outcome<-ensym(outcome)
  
  summaryStats<-myData%>%
    group_by(Time,Group)%>%
    summarise(meanOutcome=mean({{outcome}},na.rm=T),
              logmeanOutcome=log(meanOutcome+1))

  ggplot(summaryStats,aes(x=Time,y=logmeanOutcome,group=Group,color=Group))+
    geom_point()+
    geom_line()+
    ylab(paste("log mean",{{outcome}}))+
    ggtitle({{outcome}})
  
}

pdf("output/meanOutcome(logscale).pdf")
plotData(data=myData,outcome="Oleuropein")
plotData(data=myData,outcome="Hydroxytyrosol")
plotData(data=myData,outcome="Oleoside.methyl.ester")
dev.off()
