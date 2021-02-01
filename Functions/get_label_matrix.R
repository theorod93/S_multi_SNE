#' In this script, we aim to convert label vector into a label matrix with 0-1 values
#'

# Libraries
library(data.table)

# Data
nan_index <- as.vector(as.matrix(fread("~/nan_index.txt")))
nan_index <- nan_index + 1
true_labels <- as.vector(as.matrix(fread("~/digitLabels.txt")))

label_matrix <- matrix(0, nrow = length(true_labels), ncol = length(unique(true_labels)))
for (i in 1:length(true_labels)){
  label_matrix[i,true_labels[i]] <- 1
}

# NaN label matrix
nan_label_matrix <- label_matrix
nan_label_matrix[nan_index,] <- NA
zero_label_matrix <- label_matrix
zero_label_matrix[nan_index,] <- 0

write.table(label_matrix, "label_matrix.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(nan_label_matrix, "nan_label_matrix.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(zero_label_matrix, "zero_label_matrix.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
