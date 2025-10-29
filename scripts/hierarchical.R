file_kandangan <- "processed-data/Analisis Pisang Kandangan_scaled.csv"
file_banjarbaru <- "processed-data/Analisis Pisang Banjarbaru_scaled.csv"
plot_output_dir <- "results/plots"

perform_hclust <- function(file_path, id_column_name, output_prefix) {
  
  print(paste("--- Memproses Klaster untuk:", file_path, "---"))
  
  # Muat data yang sudah diskalakan
  data <- read.csv(file_path, check.names = FALSE)
  
  # Pisahkan kolom numerik (untuk perhitungan) dan kolom ID (untuk label)
  numeric_cols_mask <- sapply(data, is.numeric)
  data_numeric <- data[, numeric_cols_mask]
  
  # Simpan label nama varietas dari kolom ID
  # as.character() memastikan labelnya adalah teks, bukan faktor
  variety_labels <- as.character(data[, id_column_name])
  
  # 3. Tangani nilai yang hilang (NA)
  # Perhitungan jarak tidak bisa menangani NA. Kita buang baris yang datanya tidak lengkap.
  complete_cases_mask <- complete.cases(data_numeric)
  data_numeric_clean <- data_numeric[complete_cases_mask, ]
  labels_clean <- variety_labels[complete_cases_mask]
  
  # Periksa apakah data yang tersisa cukup untuk diklaster (perlu minimal 2)
  if (nrow(data_numeric_clean) < 2) {
    print(paste("Melewatkan", file_path, "- data tidak cukup setelah menghapus NA."))
    return(NULL)
  }
  
  # Hitung matriks jarak ("Euclidean")
  # dist() menghitung jarak antar baris (antar varietas pisang)
  dist_matrix <- dist(data_numeric_clean, method = "euclidean")
  
  # Lakukan hierarchical clustering ("Ward")
  # "ward.D2" adalah metode Ward yang standar dan efektif
  hclust_result <- hclust(dist_matrix, method = "ward.D2")
  
  # Tetapkan label ke hasil klaster untuk plotting
  hclust_result$labels <- labels_clean
  
  # Simpan Dendrogram (plot pohon) ke 'results/plots/'
  plot_path <- file.path(plot_output_dir, paste0(output_prefix, "_dendrogram.png"))
  
  # Menyiapkan file PNG, dibuat lebih lebar agar label tidak tumpang tindih
  png(plot_path, width = 1000, height = 600)
  
  # plot() secara otomatis membuat dendrogram dari output hclust
  plot(hclust_result, 
       main = paste("Dendrogram Klaster -", output_prefix), 
       xlab = "Varietas Pisang", 
       sub = "Metode: Ward, Jarak: Euclidean",
       cex = 0.8) # cex = 0.8 memperkecil ukuran font label
  
  dev.off() # Menutup file PNG
  
  print(paste("Dendrogram disimpan ke:", plot_path))
  return(hclust_result)
}

# Jalankan untuk Kandangan
# Kolom ID di file ini adalah "Variety"
hclust_k <- perform_hclust(file_kandangan, 
                           id_column_name = "Variety", 
                           output_prefix = "kandangan")

# Jalankan untuk Banjarbaru
# Kolom ID di file ini adalah "Nama.Pisang"
hclust_b <- perform_hclust(file_banjarbaru, 
                           id_column_name = "Nama.Pisang", 

                           output_prefix = "banjarbaru")
