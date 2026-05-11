# =============================================================================
# Differential Expression Analysis — E. faecium E745
# Serum vs BHI (rich medium)
# Paper: Zhang et al. 2017 (DOI: 10.1186/s12864-017-4299-9)
# =============================================================================

library(DESeq2)
library(ggplot2)
library(ggrepel)
library(pheatmap)

# =============================================================================
# 1. LOAD DATA
# =============================================================================

samples <- c("ERR1797969", "ERR1797970", "ERR1797971",   # serum replicates
             "ERR1797972", "ERR1797973", "ERR1797974")   # BHI replicates

conditions <- c("serum", "serum", "serum", "BHI", "BHI", "BHI")

# HTSeq output has 4 columns: gene_id, gene_name, product, count
load_htseq <- function(sample) {
  read.table(paste0(sample, "_counts.txt"),
             header = FALSE,
             sep = "\t",
             quote = "",
             fill = TRUE,
             col.names = c("gene_id", "gene_name", "product", "count"))
}

data_list <- lapply(samples, load_htseq)

# Build count matrix (genes x samples)
count_matrix <- sapply(data_list, function(df) df$count)
rownames(count_matrix) <- data_list[[1]]$gene_id
colnames(count_matrix) <- samples

# Save gene annotations for later
gene_info <- data.frame(
  gene_id   = data_list[[1]]$gene_id,
  gene_name = data_list[[1]]$gene_name,
  product   = data_list[[1]]$product
)

# =============================================================================
# 2. CLEAN AND FILTER
# =============================================================================

# Print HTSeq summary statistics then remove them from count matrix
summary_lines <- grepl("^__", rownames(count_matrix))
cat("HTSeq summary statistics:\n")
print(count_matrix[summary_lines, ])
count_matrix <- count_matrix[!summary_lines, ]
cat("\nGenes before filtering:", nrow(count_matrix), "\n")

# =============================================================================
# 3. DESEQ2 SETUP
# =============================================================================

# Sample metadata — BHI is the reference/control condition
coldata <- data.frame(
  condition = factor(conditions, levels = c("BHI", "serum")),
  row.names = samples
)

# Create DESeq2 object
dds <- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData   = coldata,
  design    = ~ condition
)

# Remove genes with fewer than 10 total reads across all samples
dds <- dds[rowSums(counts(dds)) >= 10, ]
cat("Genes after filtering:", nrow(dds), "\n")

# =============================================================================
# 4. RUN DESEQ2
# =============================================================================

dds <- DESeq(dds)

# Get results — serum vs BHI
# Thresholds from paper: q < 0.001, fold-change > 2 (log2FC > 1)
res <- results(dds,
               contrast = c("condition", "serum", "BHI"),
               alpha    = 0.001)

cat("\nDESeq2 results summary:\n")
summary(res)

# Add gene names and products to results table
res_df <- as.data.frame(res)
res_df$gene_id <- rownames(res_df)
res_df <- merge(res_df, gene_info, by = "gene_id", all.x = TRUE)
res_df <- res_df[order(res_df$padj), ]

# Classify genes by significance
res_df$significance <- ifelse(
  res_df$padj < 0.001 & res_df$log2FoldChange >  1, "Up in serum",
  ifelse(
    res_df$padj < 0.001 & res_df$log2FoldChange < -1, "Down in serum",
    "Not significant"))

# =============================================================================
# 5. SAVE RESULTS
# =============================================================================

write.csv(res_df,
          file = "DE_results_full.csv",
          row.names = FALSE)

res_sig <- subset(res_df, padj < 0.001 & abs(log2FoldChange) > 1)
write.csv(res_sig,
          file = "DE_results_significant.csv",
          row.names = FALSE)

cat("\nTotal significant DE genes:", nrow(res_sig), "\n")
cat("Upregulated in serum: ", sum(res_sig$log2FoldChange > 0), "\n")
cat("Downregulated in serum: ", sum(res_sig$log2FoldChange < 0), "\n")
cat("Paper reports: 860 significant DE genes\n")

# Check key genes from paper
cat("\nKey genes from paper:\n")
key_genes <- c("purD", "purH", "purN", "purM", "purF", "purL", "pyrK_2", "sorA_1")
res_df[res_df$gene_name %in% key_genes & !is.na(res_df$gene_name),
       c("gene_name", "log2FoldChange", "padj")]

# =============================================================================
# 6. PLOTS
# =============================================================================

# --- PCA plot ---
vsd <- vst(dds, blind = FALSE)
pca_data    <- plotPCA(vsd, intgroup = "condition", returnData = TRUE)
percent_var <- round(100 * attr(pca_data, "percentVar"))

ggplot(pca_data, aes(x = PC1, y = PC2, colour = condition, label = name)) +
  geom_point(size = 4) +
  geom_text(vjust = -0.8, size = 3) +
  scale_colour_manual(values = c("BHI" = "steelblue", "serum" = "coral")) +
  xlab(paste0("PC1: ", percent_var[1], "% variance")) +
  ylab(paste0("PC2: ", percent_var[2], "% variance")) +
  ggtitle("PCA — serum vs BHI") +
  theme_bw()
ggsave("PCA_plot.png", width = 7, height = 5)

# --- MA plot ---
png("MA_plot.png", width = 800, height = 600)
plotMA(res, main = "MA plot — serum vs BHI", ylim = c(-10, 10), alpha = 0.001)
dev.off()

# --- Volcano plot with key gene labels ---
# Only label genes identified as key findings in the paper
genes_to_label <- c("purD", "purH", "purN", "purM", "purF", "purL", "pyrK_2", "sorA_1")
res_df$label <- ifelse(res_df$gene_name %in% genes_to_label,
                       res_df$gene_name, NA)

ggplot(res_df[!is.na(res_df$padj), ],
       aes(x = log2FoldChange, y = -log10(padj), colour = significance)) +
  geom_point(alpha = 0.5, size = 1) +
  scale_colour_manual(values = c(
    "Up in serum"     = "red",
    "Down in serum"   = "blue",
    "Not significant" = "grey")) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed") +
  geom_hline(yintercept = -log10(0.001), linetype = "dashed") +
  geom_label_repel(aes(label = label),
                   na.rm        = TRUE,
                   size         = 3,
                   max.overlaps = 20,
                   box.padding  = 0.5) +
  labs(title = "Volcano plot — serum vs BHI",
       x     = "Log2 fold change",
       y     = "-Log10 adjusted p-value") +
  theme_bw()
ggsave("volcano_plot.png", width = 9, height = 7)

# --- Heatmap of top 50 DE genes ---

library(pheatmap)
top50 <- head(res_df[order(res_df$padj), ], 50)
mat   <- assay(vsd)[top50$gene_id, ]

# Use gene name as row label where available, otherwise use locus tag
rownames(mat) <- ifelse(top50$gene_name != "" & !is.na(top50$gene_name),
                        top50$gene_name,
                        top50$gene_id)

annotation_col <- data.frame(
  condition = conditions,
  row.names = samples
)

pheatmap(mat,
         annotation_col = annotation_col,
         scale          = "row",
         show_rownames  = TRUE,
         show_colnames  = TRUE,
         main           = "Top 50 DE genes — serum vs BHI",
         color          = colorRampPalette(c("blue", "white", "red"))(100),
         filename       = "heatmap_top50.png",
         width          = 8,
         height         = 12
         )
