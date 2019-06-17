
from sklearn.datasets import load_breast_cancer
from sklearn.metrics import precision_recall_fscore_support
from id3 import Id3Estimator, export_graphviz
import numpy as np
import graphviz

data = load_breast_cancer()

size = int(data.data.shape[0]*0.2)

data_t = np.c_[data.data, data.target]


x_test = data.data[:size, :]
x_train = data.data[size:, :]
y_test = data.target[:size]
y_train = data.target[size:]

id3 = Id3Estimator()
id3.fit(x_train, y_train)

# Evaluacion
y_predict = id3.predict(x_test)

# Precision, Recall, F-Measure and support (the number of occurrences of each class in y_true).
# For each class.  precision, recall, fbeta_score, support
print(precision_recall_fscore_support(y_test, y_predict))


export_graphviz(id3.tree_, 'tree_p2.dot', data.feature_names)
with open("tree_p2.dot") as f:
    dot_graph = f.read()
g = graphviz.Source(dot_graph)
g.render()
g.view()
