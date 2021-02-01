#' Here we present the functions used in evaluating S-multi-SNE
#'
#' In this script we will read the output of multi-SNE with missing data
#' Implement K-NN 
#'

# Directory
#setwd()

# Libraries
library(clue)
library(aricode)
library(fossil)
library(mclust)
library(data.table)
library(MASS)
library(class)
library(Matrix)
library(nnet) # multinom

# Best matching possible -- Since cluster names may differ, but refer to the same cluster
# NOTE: Unnecessary for classification tasks!
fixTablingClustering <- function(tableInput, max = TRUE){
  if (nrow(tableInput) != ncol(tableInput)){
    stop("PLease enter a square matrix")
  }
  lengthTable <- nrow(tableInput)
  orderTemp <- solve_LSAP(tableInput, maximum = max)
  tableTemp <- tableInput
  for (i in 1:lengthTable){
    tableTemp[i,] <- tableInput[which(orderTemp==i),]
  }
  return(tableTemp)
}

# Measure Accuracy
accuracyTable <- function(tableInput){
  sumDiag <- sum(diag(tableInput))
  sumAll <- sum(tableInput)
  acc <- sumDiag/sumAll
  return(acc)
}

# Measure Precision
precisionTable <- function(tableInput){
  tp <- sum(diag(tableInput))
  fp <- sum(tableInput[upper.tri(tableInput)])
  sumAll <- tp+fp
  prec <- tp/sumAll
  return(prec)
}

# Measure Recall
recallTable <- function(tableInput){
  tp <- sum(diag(tableInput))
  fn <- sum(tableInput[lower.tri(tableInput)])
  sumAll <- tp+fn
  rec <- tp/sumAll
  return(rec)
}

evalMeasures_multiSNE_kNN <- function(Y, trueLabels, nanIndex){
  #' Input:
  #'  Y -- output of multi-SNE (list)
  #'  trueLabels -- vector containing the true labels of the data (vector)
  #'  nanIndex -- vector contatining the samples with NaN values, i.e. the test set (vector)

  # Number of runs
  n_runs <- length(Y)
  #### Process
  # Split training/test data
  trainingData <- vector("list")
  testData <- vector("list")
  trainingLabels <- vector("list")
  testLabels <- vector("list")
  for (i in 1:n_runs){
    trainingData[[i]] <- Y[[i]][-nanIndex,]
    testData[[i]] <- Y[[i]][nanIndex,]
    trainingLabels[[i]] <- true_labels[-nanIndex]
    testLabels[[i]] <- true_labels[nanIndex]
  }
  names(trainingLabels) <- names(Y)
  names(trainingData) <- names(Y)
  names(testLabels) <- names(Y)
  names(testData) <- names(Y)
  # Run k-NN
  # Set different k-values
  knn_missing <- vector("list")
  knn_missing$k_5 <- vector("list")
  knn_missing$k_8 <- vector("list")
  knn_missing$k_10 <- vector("list")
  knn_missing$k_15 <- vector("list")
  knn_missing$k_20 <- vector("list")
  k_values <- c(5,8,10,15,20)
  for (k in 1:length(k_values)){
    for (i in 1:n_runs){
      knn_missing[[k]][[i]] <- knn(train = trainingData[[i]],
                                   test = testData[[i]],
                                   cl = as.factor(trainingLabels[[i]]),
                                   k = k_values[k])
    }
    names(knn_missing[[k]]) <- names(Y)
  }
  # Evaluate classification
  evaluation_table <- vector("list", length = length(knn_missing))
  accMeasure <- vector("list", length = length(knn_missing))
  names(accMeasure) <- names(knn_missing)
  precMeasure <- vector("list", length = length(knn_missing))
  recMeasure <- vector("list", length = length(knn_missing))
  evalMeasures <- vector("list", length = length(knn_missing))
  for (k in 1:length(k_values)){
    for (i in 1:n_runs){
#      evaluation_table[[k]][[i]] <- fixTablingClustering(table(knn_missing[[k]][[i]], testLabels[[i]]))
      evaluation_table[[k]][[i]] <- table(knn_missing[[k]][[i]], testLabels[[i]])
      accMeasure[[k]][[i]] <- accuracyTable(evaluation_table[[k]][[i]])
      precMeasure[[k]][[i]] <- precisionTable(evaluation_table[[k]][[i]])
      recMeasure[[k]][[i]] <- recallTable(evaluation_table[[k]][[i]])
      evalMeasures[[k]][[i]] <- c(accMeasure[[k]][[i]], precMeasure[[k]][[i]], recMeasure[[k]][[i]])
    }
  }
  for (k in 1:length(k_values)){
    names(evalMeasures[[k]]) <- names(Y)
    names(recMeasure[[k]]) <- names(Y)
    names(precMeasure[[k]]) <- names(Y)
    names(accMeasure[[k]]) <- names(Y)
    names(evaluation_table[[k]]) <- names(Y)
  }

  acc_measures_perp <- vector("list", length = n_runs)
  prec_measures_perp <- vector("list", length = n_runs)
  rec_measures_perp <- vector("list", length = n_runs)
  eval_measures_perp <- vector("list", length = n_runs)
  for (i in 1:n_runs){
    for (k in 1:length(k_values)){
      acc_measures_perp[[i]] <- c(acc_measures_perp[[i]], accMeasure[[k]][[i]])
      prec_measures_perp[[i]] <- c(prec_measures_perp[[i]], precMeasure[[k]][[i]])
      rec_measures_perp[[i]] <- c(rec_measures_perp[[i]], recMeasure[[k]][[i]])
    }
    case_max <- which.max(acc_measures_perp[[i]])
    eval_measures_perp[[i]] <- c(acc_measures_perp[[i]][case_max], prec_measures_perp[[i]][case_max], rec_measures_perp[[i]][case_max])
  }
  names(acc_measures_perp) <- names(Y)
  names(prec_measures_perp) <- names(Y)
  names(rec_measures_perp) <- names(Y)
  names(eval_measures_perp) <- names(Y)
  return(list("accMeasures" = acc_measures_perp,
              "precMeasures" = prec_measures_perp,
              "recMeasures" = rec_measures_perp,
              "evalMeasures" = eval_measures_perp))
}

Example
S_multiSNE <- vector("list")
SmultiSNE <- as.matrix(fread("S_multiSNE_p50_handwrittenDigits.txt"))

true_labels <- as.vector(as.matrix(fread("~/digitLabels.txt")))
nan_index <- as.vector(as.matrix(fread("~/nan_index.txt")))

evaluation_S_mutliSNE <- evalMeasures_multiSNE_kNN(Y = S_multiSNE, trueLabels = true_labels, nanIndex = nan_index)


