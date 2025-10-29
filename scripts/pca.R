# Define file paths
file_kandangan <- "processed-data/Analisis Pisang Kandangan_scaled.csv"
file_banjarbaru <- "processed-data/Analisis Pisang Banjarbaru_scaled.csv"
plot_output_dir <- "results/plots"
table_output_dir <- "results"

perform_pca <- function(file_path, output_prefix) {
  
  print(paste("--- Processing PCA for:", file_path, "---"))
  
  # Load the scaled data
  data <- read.csv(file_path, check.names = FALSE) # check.names=FALSE keeps original names
  
  # Isolate numeric columns for PCA
  numeric_cols_mask <- sapply(data, is.numeric)
  data_numeric <- data[, numeric_cols_mask]
  
  # Handle missing values (NA)
  # prcomp() cannot run with NA values. We'll remove rows with any NAs.
  data_clean <- na.omit(data_numeric)
  
  if (nrow(data_clean) == 0) {
    print(paste("Skipping", file_path, "- No complete rows without NA values."))
    return(NULL)
  }
  
  # Perform PCA
  # We use prcomp().
  pca_result <- prcomp(data_clean, center = FALSE, scale. = FALSE)
  
  print("Importance of components (Summary):")
  print(summary(pca_result))
  
  # Scree Plot
  scree_path <- file.path(plot_output_dir, paste0(output_prefix, "_scree_plot.png"))
  png(scree_path)
  screeplot(pca_result, type = "l", main = paste("Scree Plot -", output_prefix))
  dev.off() # Closes the PNG file device
  
  # Biplot
  biplot_path <- file.path(plot_output_dir, paste0(output_prefix, "_biplot.png"))
  png(biplot_path)
  biplot(pca_result, main = paste("Biplot -", output_prefix))
  dev.off() # Closes the PNG file device
  
  # Table 1: Importance of Components (Proportion of Variance, etc.)
  importance_table <- summary(pca_result)$importance
  importance_path <- file.path(table_output_dir, paste0(output_prefix, "_pca_importance.csv"))
  # row.names = TRUE is important here to keep PC1, PC2, etc. labels
  write.csv(importance_table, importance_path, row.names = TRUE)
  
  # Table 2: Loadings (Variable contributions to PCs)
  loadings_table <- pca_result$rotation
  loadings_path <- file.path(table_output_dir, paste0(output_prefix, "_pca_loadings.csv"))
  # row.names = TRUE is important here to keep the variable names
  write.csv(loadings_table, loadings_path, row.names = TRUE)
  
  print(paste("PCA plots saved to", plot_output_dir))
  print(paste("PCA tables saved to", table_output_dir))
  
  return(pca_result)
}

if (!dir.exists(plot_output_dir)) {
  dir.create(plot_output_dir, recursive = TRUE)
}
if (!dir.exists(table_output_dir)) {
  dir.create(table_output_dir, recursive = TRUE)
}

# Run for Kandangan
pca_k <- perform_pca(file_kandangan, "kandangan")

# Run for Banjarbaru
pca_b <- perform_pca(file_banjarbaru, "banjarbaru")
