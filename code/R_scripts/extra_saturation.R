# Load count data
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

# Combine into one dataframe
combined <- cbind(mutated_1, mutated_2, mutated_3, wild_1, wild_2, wild_3)

# Remove genes with zero counts across all samples
combined_nozero <- combined[rowSums(combined > 0) > 0, ]

# Create DGEList and filter
dge <- DGEList(counts = combined_nozero)
cpm_values <- cpm(dge)
keep_rows <- rowSums(cpm_values > 1) >= 3
filtered_counts <- combined_nozero[keep_rows, ]

# Estimate dispersion
dge_filtered <- DGEList(counts = filtered_counts)
dge_filtered <- estimateDisp(dge_filtered)
common_dispersion <- dge_filtered$common.dispersion

# Negative binomial subsampling function
subsampling_nb <- function(counts, prop, dispersion) {
  subsampled <- counts
  for (sample in colnames(counts)) {
    mu <- counts[, sample] * prop
    subsampled[, sample] <- rnbinom(n = nrow(counts), mu = mu, size = 1 / dispersion)
  }
  return(subsampled)
}

# Define proportions
proportions <- seq(0.1, 1.0, by = 0.1)

# Empty dataframe to store output
out <- data.frame()

# Simulate subsampling and collect results
for (i in proportions) {
  subsampled <- subsampling_nb(filtered_counts, i, common_dispersion)
  detected <- colSums(subsampled > 0)
  depth <- colSums(subsampled)
  temp <- data.frame(Sample = names(detected),
                     Depth = depth,
                     Genes = detected,
                     Proportion = i)
  out <- rbind(out, temp)
}

# Plot results
ggplot(out, aes(x = Depth, y = Genes, color = Sample)) +
  geom_line() +
  geom_point() +
  labs(title = "Saturation Analysis (NB-based Subsampling)",
       x = "Simulated Sequencing Depth (Total Counts)",
       y = "Number of Detected Genes") +
  theme_minimal()
