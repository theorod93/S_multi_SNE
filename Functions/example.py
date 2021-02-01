from S_multi_SNE import *
import time
import numpy as np

Xa = np.loadtxt("~/data/handwrittenDigits/matrixFou.txt")
Xb = np.loadtxt("~/data/handwrittenDigits/matrixFou.txt")
Xc = np.loadtxt("~/data/handwrittenDigits/matrixFou.txt")
Xd = np.loadtxt("~/data/handwrittenDigits/matrixFou.txt")
Xe = np.loadtxt("~/data/handwrittenDigits/matrixFou.txt")
Xf = np.loadtxt("~/data/handwrittenDigits/matrixFou.txt")
colVector = np.loadtxt("~/data/handwrittenDigits/digitLabels.txt")
Xi = np.array([[(0,0),(0,0), (0,0)],
                      [(0,0),(0,0)],
                      [(0,0),(0,0), (0,0)],
                      [(0,0),(0,0), (0,0)],
                      [(0,0),(0,0)],
                      [(0,0),(0,0), (0,0)],
                      [(0,0)]])
# Prepare colVector
labels = colVector.reshape(colVector.shape[0],1) # True labels
missing_labels_matrix = np.loadtxt("missing_labels_matrix.txt") # Contains elements with "nan" values. ncol = number of classes (10 in this case)

perp = 50
# Missing labels
Xinput = np.copy(Xi)
Xinput[0] = np.copy(Xa)
Xinput[1] = np.copy(Xb)
Xinput[2] = np.copy(Xc)
Xinput[3] = np.copy(Xd)
Xinput[4] = np.copy(Xe)
Xinput[5] = np.copy(Xf)
Xinput[6] = np.copy(missing_labels_matrix)
start_time_multiSNE_missingData = time.time()
Y_multiSNE_missingData = missingData_multiSNE(Xinput, 2, 50, perp, 1000)
end_time_multiSNE_missingData  = time.time()
running_time_multiSNE_missingData  = end_time_multiSNE_missingData  - start_time_multiSNE_missingData

np.savetxt("S_multiSNE_p50_handwrittenDigits.txt", Y_multiSNE_missingData)

