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

print(nrow(combined))

#remove "0-rows"
combined_nozero <- combined[rowSums(combined > 0) > 0, ]

print(nrow(combined_nozero))

#load edgeR library for cpm


#run cpm
cpm_input <- DGEList(counts = combined_nozero)
cpm_values <- cpm(cpm_input)

#keep rows with sufficient cpm 
keep_rows <- rowSums(cpm_values > 1) >= 3
filtered_counts <- combined_nozero[keep_rows, ]

print(nrow(filtered_counts))

#assign labels

column_data <- data.frame(row.names = colnames(filtered_counts),
                          sample_type = c("mutated", "mutated", "mutated", "wild", "wild", "wild"))

#column_data$sample_type <- relevel(factor(column_data$sample_type), ref = "wild")

#deseq2
dds <- DESeqDataSetFromMatrix(countData = filtered_counts,
                              colData = column_data,
                              design = ~ sample_type)

dds <- DESeq(dds)
res <- results(dds)

#plot ma plot

DESeq2::plotMA(res)


#create dataframe from results
res_df <- as.data.frame(res)
res_df <- na.omit(res_df)
data_tsv <- read.delim("annotation_ref2.tsv", row.names = 1, header = TRUE, check.names = FALSE)
gene_dict <- data_tsv[, "product", drop = FALSE]
res_df$product <- gene_dict[rownames(res_df), "product"]

#add pfam, cog and description and absolute fold change
add_data <- read_excel("refinement.xlsx")
add_data <- as.data.frame(add_data)
rownames(add_data) <- add_data[[1]]
res_df$description <- add_data[rownames(res_df), "Description"]
res_df$PFAMs <- add_data[rownames(res_df), "PFAMs"]
res_df$COG <- add_data[rownames(res_df), "COG_category"]
write.csv(res_df, "deseq_res.csv", row.names = TRUE)
res_df$abs_log2FoldChange <- abs(res_df$log2FoldChange)
#transform data
vsd <- vst(dds, blind = FALSE)

#plot
plotPCA(vsd, intgroup = "sample_type")

#heatmap


#filter
#significant data
sig_gen <- res_df[res_df$padj < 0.05, ]

print(nrow(sig_gen))

#order genes
top_gen <- sig_gen[order(abs(sig_gen$log2FoldChange), decreasing = TRUE), ]

# top 20 genes
top_20_gen <- head(top_gen, 20)

#extract and assign expression data
top_20_expression <- assay(vsd)[rownames(top_20_gen), ]

# Draw heatmap
# scale = "row" makes it easier to obsorve conditions and replicates
pheatmap(top_20_expression,
         annotation_col = column_data,
         show_rownames = TRUE,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         main = "Top 20 Differentially Expressed Genes")#,
         #scale="row")

#save top 20
output_df <- data.frame(
  gene = rownames(top_20_gen),
  log2FoldChange = top_20_gen$log2FoldChange,
  pvalue = top_20_gen$pvalue,
  product = top_20_gen$product,
  description = top_20_gen$description,
  PFAMs = top_20_gen$PFAMs
  )

# Save to CSV
write.csv(output_df, file = "top_20_2.csv", row.names = FALSE)



#filter to use with relevant cogs

res_filt_df <- res_df[res_df$COG %in% c("C", "G", "E", "H", "Q"),] 

#significant data
sig_gen <- res_filt_df[res_filt_df$padj < 0.05, ]

#order genes
top_gen <- sig_gen[order(abs(sig_gen$log2FoldChange), decreasing = TRUE), ]

# top 20 genes
top_20_gen <- head(top_gen, 20)

#extract and assign expression data
top_20_expression <- assay(vsd)[rownames(top_20_gen), ]

# Draw heatmap
pheatmap(top_20_expression,
         annotation_col = column_data,
         show_rownames = TRUE,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         main = "Top 20 Differentially Expressed Genes")

#save top 20
output_df <- data.frame(
  gene = rownames(top_20_gen),
  log2FoldChange = top_20_gen$log2FoldChange,
  pvalue = top_20_gen$pvalue,
  product = top_20_gen$product,
  description = top_20_gen$description,
  PFAMs = top_20_gen$PFAMs
)

# Save to CSV
write.csv(output_df, file = "top_20_cog_2.csv", row.names = FALSE)



