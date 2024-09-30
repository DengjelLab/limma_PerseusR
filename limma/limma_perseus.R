#rm(list=ls())
library(PerseusR)
library(limma)
library(qvalue)
library(stringr)

#TO DOs
#add significant column
#allows several annotation rows
#remove lines with 0 valid values

args = commandArgs(trailingOnly=TRUE)


if (length(args) < 3) {
  stop("Additional arguments are needed!", call.=FALSE)
}
if (length(args) > 3) {
    stop("only one additional argument is supported - remove white spaces", call.=FALSE)
}


inFile <- args[length(args)-1]

outFile <- args[length(args)]

limmaForm <- args[1]

limmaForms<-stringr::str_split(limmaForm, ",", simplify = TRUE)

mdata <- read.perseus(inFile) # read data in Perseus text format 

mainMatrix <- main(mdata) # extract main columns
anotCol<-annotCols(mdata) # extract rest of the columns
anotRow<-annotRows(mdata) # extract annotation rows/groups


design<-model.matrix(~0+anotRow[[1]])
colnames(design)=levels(anotRow[[1]]) #TO DO check order
fit<-lmFit(mainMatrix,design)

for(i in 1:length(limmaForms)){
  name<-limmaForms[i]
  contrast.matrix<-makeContrasts(con1=name, levels=design)
  fitcon<-contrasts.fit(fit,contrast.matrix)
  bayes<-eBayes(fitcon)
  anotCol[paste0("logFold.",name)]<-NaN
  anotCol[paste0("logFold.",name)]<-bayes$coefficients[,1]
  anotCol[paste0("p.value.",name)]<-NaN
  anotCol[paste0("p.value.",name)]<-bayes$p.value[,1]
  anotCol[paste0("adjP.",name)]<-NaN
  anotCol[paste0("adjP.",name)]<-p.adjust(bayes$p.value[,1],method ="BH" )
  anotCol[paste0("q.value.",name)]<-NaN
  anotCol[paste0("q.value.",name)]<-qvalue(bayes$p.value[,1])$qvalues
  #ordinary.t <- bayes$coef[,2] / bayes$stdev.unscaled[,2] / bayes$sigma #calculation of ordinary t test p-value, not yet tested
}

annotCols(mdata)<-anotCol #add new columns to the Perseus data class

write.perseus(mdata, outFile) #write Perseus data



