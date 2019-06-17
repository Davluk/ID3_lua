import random
import numpy as np
import pandas as pd 
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
from id3 import Id3Estimator
from id3 import export_graphviz
from sklearn import tree
from sklearn import preprocessing

data_set = pd.read_csv('data_set.csv')
print(data_set.shape)
le = preprocessing.LabelEncoder()
for column_name in data_set.columns:
    if (data_set[column_name].dtype == type(object)):
        data_set[column_name] = le.fit_transform(data_set[column_name])

X = data_set.values[:,1:19]
Y = data_set.values[:,20]
X_train,X_test,Y_train,Y_test = train_test_split(X,Y,test_size = 0.3)

clf_ent = Id3Estimator()
clf_ent.fit (X_train,Y_train)
element_test = X_test[0:2][0:18]
#print(element_test)
clf_ent.predict(element_test)
##dot_data = export_graphviz(clf_ent.tree_,'arbol_salida.dot')