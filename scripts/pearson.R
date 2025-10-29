install.packages(c("corrplot", "MASS"))
library(corrplot)
library(MASS)

data_dir <- "data"
processed_dir <- "processed-data"
plot_dir <- "results/plots"
table_dir <- "results"

# Kandangan corr.
try({
  print("Processing correlation for Kandangan...")
  file_k_orig <- file.path(data_dir, "Analisis Pisang Kandangan.csv")
  data_k_orig <- read.csv(file_k_orig, check.names = FALSE)
  
  # Select only the quantitative (KN) columns for correlation (cols 2-8)
  data_k_quant <- data_k_orig[, 2:8]
  
  # Calculate correlation matrix
  # use = "pairwise.complete.obs" handles any missing values
  corr_matrix_k <- cor(data_k_quant, use = "pairwise.complete.obs")
  
  # Save the correlation matrix table
  write.csv(corr_matrix_k, file.path(table_dir, "kandangan_correlation_matrix.csv"))
  
  # Save the correlation heatmap plot
  png(file.path(plot_dir, "kandangan_correlogram.png"), width = 800, height = 800)
  corrplot(corr_matrix_k,
           method = "color",       # Use colored squares
           type = "upper",         # Show upper triangle only
           order = "hclust",       # Reorder variables by clustering
           addCoef.col = "black",  # Add correlation coefficients
           tl.col = "black",       # Label color
           tl.srt = 45,          # Rotate labels 45 degrees
           diag = FALSE,           # Hide self-correlation
           main = "Kandangan Correlation (Quantitative Traits)")
  dev.off()
  print("Kandangan correlation complete.")
})

# Banjarbaru corr.
try({
  print("Processing correlation for Banjarbaru...")
  file_b_orig <- file.path(data_dir, "Analisis Pisang Banjarbaru.csv")
  data_b_orig <- read.csv(file_b_orig, check.names = FALSE)
  
  # Select only quantitative (V22-V28, K1-K7) columns (cols 23-36)
  data_b_quant <- data_b_orig[, 23:36]
  
  # Calculate correlation matrix
  corr_matrix_b <- cor(data_b_quant, use = "pairwise.complete.obs")
  
  # Save the correlation matrix table
  write.csv(corr_matrix_b, file.path(table_dir, "banjarbaru_correlation_matrix.csv"))
  
  # Save the correlation heatmap plot
  png(file.path(plot_dir, "banjarbaru_correlogram.png"), width = 1000, height = 1000)
  corrplot(corr_matrix_b,
           method = "color",
           type = "upper",
           order = "hclust",
           addCoef.col = "black",
           tl.col = "black",
           tl.srt = 45,
           tl.cex = 0.8, # Make text labels slightly smaller
           diag = FALSE,
           main = "Banjarbaru Correlation (Quantitative Traits)")
  dev.off()
  print("Banjarbaru correlation complete.")
})