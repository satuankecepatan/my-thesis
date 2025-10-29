input_file_path <- "data/Analisis Pisang Kandangan.csv"
output_dir <- "processed-data"
output_file_path <- file.path(output_dir, "Analisis Pisang Kandangan_scaled.csv")

data <- read.csv(input_file_path)

numeric_cols_mask <- sapply(data, is.numeric) # To include only numeric columns

data_scaled_numeric <- scale(data[, numeric_cols_mask])
data_scaled_numeric_df <- as.data.frame(data_scaled_numeric)

data_final_scaled <- cbind(data[, !numeric_cols_mask, drop = FALSE], data_scaled_numeric_df)

write.csv(data_final_scaled, output_file_path, row.names = FALSE)

# Verify mean (~0) and sd (1) of the first scaled column
first_numeric_col_name <- names(data_scaled_numeric_df)[1]
if (!is.null(first_numeric_col_name)) {
  scaled_mean <- mean(data_final_scaled[[first_numeric_col_name]], na.rm = TRUE)
  scaled_sd <- sd(data_final_scaled[[first_numeric_col_name]], na.rm = TRUE)
  
  print(paste("Verification for", first_numeric_col_name, "Mean:", scaled_mean, "SD:", scaled_sd))
}
