# S-multi-SNE
Supervised multi-SNE  (S-multi-SNE): Multi-view visualisation and classification

### Functions
- S_multi_SNE.py
  - Contains all python functions to run S-multi-SNE and obtain the low-dimensional embeddings
- example.py
  - An example (handwritten digits) of implementing S-multi-SNE.
- get_nan_tXp.py
  - Removes the labeling information randomly from X% of the samples. 
  - Handwritten digits is used as an example. NOTE:In this example the number of samples per class is the same. 
- get_label_matrix.R
  - Transform the labelling information into a (0-1) matrix with rows representing the samples, and columns the classes. 
