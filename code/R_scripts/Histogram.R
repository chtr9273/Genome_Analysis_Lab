# The following script produces overlapping histograms over the count distributions for the replicates of 
# R7 (wild) and HP126 (mutated) samples.

# Load count data
mutated_1 <- read.table('SRR24516459_counts.txt', header = FALSE, row.names = 1)
colnames(mutated_1) <- "mut_1"

mutated_2 <- read.table('SRR24516460_counts.txt', header = FALSE, row.names = 1)
colnames(mutated_2) <- "mut_2"

mutated_3 <- read.table('SRR24516461_counts.txt', header = FALSE, row.names = 1)
colnames(mutated_3) <- "mut_3"

wild_1 <- read.table('SRR24516462_counts.txt', header = FALSE, row.names = 1)
colnames(wild_1) <- "wild_1"

wild_2 <- read.table('SRR24516463_counts.txt', header = FALSE, row.names = 1)
colnames(wild_2) <- "wild_2"

wild_3 <- read.table('SRR24516464_counts.txt', header = FALSE, row.names = 1)
colnames(wild_3) <- "wild_3"

# Combine replicates for mutated and wild samples
mut <- cbind(mutated_1, mutated_2, mutated_3)
wild <- cbind(wild_1, wild_2, wild_3)

# Filter rows: keep only those with at least one replicate > 10 counts
mut <- mut[rowSums(mut > 10) > 0, ]
wild <- wild[rowSums(wild > 10) > 0, ]

bins <- 200  # Number of histogram bins

# Plot overlapping histograms for mutated samples with distinct colors
hist(mut$mut_1, 
     col = rgb(1, 0, 0, 0.5),   
     xlim = range(mut), 
     breaks = bins, 
     main = "Overlapping Histograms - HP126 Samples", 
     xlab = "Read Counts")

hist(mut$mut_2, 
     col = rgb(1, 0.5, 0, 0.5), 
     breaks = bins, 
     add = TRUE)

hist(mut$mut_3, 
     col = rgb(1, 0.8, 0, 0.5), 
     breaks = bins, 
     add = TRUE)

legend("topright", 
       legend = c("HP126_1", "HP126_2", "HP126_3"), 
       fill = c(rgb(1, 0, 0, 0.5), rgb(1, 0.5, 0, 0.5), rgb(1, 0.8, 0, 0.5)))

# Plot overlapping histograms for WILD samples with distinct shades of blue
hist(wild$wild_1, 
     col = rgb(0, 0, 1, 0.5), 
     xlim = range(wild), 
     breaks = bins, 
     main = "Overlapping Histograms - Wild Samples", 
     xlab = "Read Counts")

hist(wild$wild_2, 
     col = rgb(0.3, 0.3, 1, 0.5), 
     breaks = bins, 
     add = TRUE)

hist(wild$wild_3, 
     col = rgb(0.6, 0.6, 1, 0.5), 
     breaks = bins, 
     add = TRUE)

legend("topright", 
       legend = c("R7_1", "R7_2", "R7_3"), 
       fill = c(rgb(0, 0, 1, 0.5), rgb(0.3, 0.3, 1, 0.5), rgb(0.6, 0.6, 1, 0.5)))
