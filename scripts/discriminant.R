library(MASS)

processed_dir <- "processed-data"
table_dir <- "results"

perform_lda <- function(file_path, id_column_name, output_prefix) {
  print(paste("Processing LDA for:", output_prefix))
  
  # Load scaled data
  # stringsAsFactors = FALSE is important for handling group names
  data_scaled <- read.csv(file_path, stringsAsFactors = FALSE)
  
  # Clean data (remove rows with any NAs)
  data_clean <- na.omit(data_scaled)
  
  if (nrow(data_clean) == 0) {
    print("Skipping LDA: No complete rows after NA removal.")
    return(NULL)
  }
  
  print("--- Group counts after NA removal ---")
  group_counts <- table(data_clean[[id_column_name]])
  print(group_counts)
  
  
  # CRITICAL: Check for groups with only 1 sample
  # LDA needs to calculate within-group variance, which requires n > 1
  group_counts <- table(data_clean[[id_column_name]])
  groups_to_keep <- names(group_counts[group_counts > 1])
  
  if (length(groups_to_keep) < 2) {
    print("Skipping LDA: Need at least 2 groups with n > 1 samples.")
    return(NULL)
  }
  
  # Filter data to only include valid groups
  data_filtered <- data_clean[data_clean[[id_column_name]] %in% groups_to_keep, ]
  
  # Separate predictors (numeric) and groups (factor)
  grouping_factor <- as.factor(data_filtered[[id_column_name]])
  predictors <- data_filtered[, sapply(data_filtered, is.numeric)]
  
  # Perform LDA
  # This formula means "grouping_factor is predicted by all other variables"
  # We use . to represent all columns in 'predictors'
  lda_model <- lda(grouping_factor ~ ., data = predictors)
  
  # Get the "loadings" or coefficients
  # These show how much each variable contributes to the discriminant functions
  lda_loadings <- lda_model$scaling
  
  # Save the loadings table
  table_path <- file.path(table_dir, paste0(output_prefix, "_lda_loadings.csv"))
  write.csv(lda_loadings, table_path)
}

# LDA (Kandangan)
perform_lda(file_path = file.path(processed_dir, "Analisis Pisang Kandangan_scaled.csv"),
            id_column_name = "Variety",
            output_prefix = "kandangan")

# LDA (Banjarbaru)
perform_lda(file_path = file.path(processed_dir, "Analisis Pisang Banjarbaru_scaled.csv"),
            id_column_name = "Nama.Pisang",
            output_prefix = "banjarbaru")
