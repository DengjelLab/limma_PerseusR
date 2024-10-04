# limma_PerseusR
R script to use with Perseus software

Before using, install following R packages:  
- PerseusR  
- limma  
- qvalue  
- stringr

Script uses all main columns and fit a linear model using the first categorical annotation row.  

Enter as additional arguments in Perseus the contrasts you are interested in, separated with "," and without any white space  
beside simple contrast like "mutCtrl-wtCtrl" more sophisticated one are possible "(mutCtrl-wtCtrl)-(mutTreat-wtTreat)".  

<p align="center">
  <img src="/assets/contrasts.png" />
</p>

<p align="center">
  <img src="/assets/limma1.png" />
</p>

To avoid unwanted effects, please follow R rules for naming of columns and categories:  
variables should start by a letter, followed either by a letter or a digit, while the words should be separated with dots or underscores. 

optional recommendation: filter data table for at least one valid value in each group before using script

for each contrast following columns are generated:  
logFold - value of the calculated contrast formula using mean values of categories  
p.value - p-value of the moderate t-test  
adjP - adjusted p-value using Benjamini Hochberg correction  
q.value - q-value/FDR calculated using qvalue package  
