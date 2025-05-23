# Install packages if needed
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(c("DESeq2", "edgeR"))
install.packages("readxl")
install.packages("pheatmap")

# Load libraries
library(DESeq2)
library(edgeR)
library(readxl)
library(pheatmap)
library(ggplot2)
