# -*- coding: utf-8 -*-
"""
@author: Anonymous
"""

'''
Here we produce an example of unlabelling X% of samples. In this case X=10
'''

import numpy as np
import pandas as pd


colVector = np.loadtxt("~data/handwrittenDigits/digitLabels.txt")

# Prepare colVector
labels = colVector.reshape(2000,1)
## Sample missing labels
nan_index = np.random.choice(range(0, colVector.shape[0]), int(np.floor(0.9*colVector.shape[0])), replace = False)
labels_missing = np.copy(colVector)
labels_plot_missing = np.copy(colVector)
labels_missing[nan_index,] = np.nan
labels_plot_missing[nan_index,] = np.full(nan_index.shape[0], 11)
missing_labels_temp = labels_missing.reshape(2000,1)
# Store
np.savetxt("labels_plot_missing.txt", labels_plot_missing)
np.savetxt("nan_index.txt",nan_index)
np.savetxt("missing_labels_temp.txt", missing_labels_temp)
