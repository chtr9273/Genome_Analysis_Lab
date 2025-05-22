#install packages

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("edgeR")

#load libraries



#load counts for each sample

mutated_1 <-  read.table('SRR24516459_counts.txt', header = FALSE, row.names = 1)

colnames(mutated_1) <- "mut_1"

mutated_2 <-  read.table('SRR24516460_counts.txt', header = FALSE, row.names = 1)

colnames(mutated_2) <- "mut_2"

mutated_3 <-  read.table('SRR24516461_counts.txt', header = FALSE, row.names = 1)

colnames(mutated_3) <- "mut_3"

wild_1 <-  read.table('SRR24516462_counts.txt', header = FALSE, row.names = 1)

colnames(wild_1) <- "wild_1"

wild_2 <-  read.table('SRR24516463_counts.txt', header = FALSE, row.names = 1)

colnames(wild_2) <- "wild_2"

wild_3 <-  read.table('SRR24516464_counts.txt', header = FALSE, row.names = 1)

colnames(wild_3) <- "wild_3"

#combine to one dataframe

combined <- cbind(mutated_1, mutated_2, mutated_3, wild_1, wild_2, wild_3)

#remove "0-rows"
combined_nozero <- combined[rowSums(combined > 0) > 0, ]

#load edgeR library for cpm
library(edgeR)

#run cpm
cpm_input <- DGEList(counts = combined_nozero)
cpm_values <- cpm(cpm_input)

#keep rows with sufficient cpm 
keep_rows <- rowSums(cpm_values > 1) >= 3
filtered_counts <- combined_nozero[keep_rows, ]

subsampling <- function(counts, prop) {
  subsampled <- counts  # prepare matrix for output
  for (sample in colnames(counts)) {
    subsampled[, sample] <- rbinom(n = nrow(counts), size = counts[, sample], prob = prop)
  }
  return(subsampled)
}

#define prportions
proportions <- c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)

#empty data frame to store output
out <- data.frame()

#gather data
for (i in proportions) {
  subsampled <- subsampling(filtered_counts, i)
  detected <- colSums(subsampled > 0)        # Count genes with at least one read
  depth <- colSums(subsampled)               # Total reads per sample
  temp <- data.frame(Sample = names(detected),
                     Depth = depth,
                     Genes = detected,
                     Proportion = i)
  out <- rbind(out, temp)
}

library(ggplot2)

ggplot(out, aes(x = Depth, y = Genes, color = Sample)) +
  geom_line() +
  geom_point() +
  labs(title = "Saturation Analysis",
       x = "Simulated Sequencing Depth (Total Counts)",
       y = "Number of Detected Genes") +
  theme_minimal()

