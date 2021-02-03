# S-multi-SNE
Supervised multi-SNE  (S-multi-SNE): Multi-view visualisation and classification

A repository containing the code to reproduce the findings of S-multi-SNE: Multi-view visualisation and classification, submitted for the ICML '21 conference.

Please find the necessary code to reproduce the findings as described in the relevant submission, but please bear in mind that the randomness in selecting appropriate training and test data may result in slightly different resuts.

Please follow the links found in the submitted manuscript to download the data.

Hope you find the information here to be sufficient in reproducing the findings as presented in the relevant submission.


### Functions
- S_multi_SNE.py
  - Contains all python functions to run S-multi-SNE and obtain the low-dimensional embeddings
- example.py
  - An example (handwritten digits) of implementing S-multi-SNE.
- get_nan_tXp.py
  - Removes the labeling information randomly from X% of the samples. 
  - Handwritten digits is used as an example. NOTE:In this example the number of samples per class is the same. 
- get_label_matrix.R
  - Transforms the labelling information into a (0-1) matrix with rows representing the samples, and columns the classes. 

