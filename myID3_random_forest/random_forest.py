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

test_proportion = 0.9

data_set = pd.read_csv('data_set.csv')
print(data_set.shape)
le = preprocessing.LabelEncoder()
for column_name in data_set.columns:
    if (data_set[column_name].dtype == type(object)):
        data_set[column_name] = le.fit_transform(data_set[column_name])

X = data_set.values[:,1:19]
Y = data_set.values[:,20]

X_trainf1,X_test,Y_trainf1,Y_test = train_test_split(X,Y,test_size = test_proportion)
X_trainf2,X_test,Y_trainf2,Y_test = train_test_split(X,Y,test_size = test_proportion)
X_trainf3,X_test,Y_trainf3,Y_test = train_test_split(X,Y,test_size = test_proportion)
X_trainf4,X_test,Y_trainf4,Y_test = train_test_split(X,Y,test_size = test_proportion)
X_trainf5,X_test,Y_trainf5,Y_test = train_test_split(X,Y,test_size = test_proportion)
#
X_trainf6,X_test,Y_trainf6,Y_test = train_test_split(X,Y,test_size = test_proportion)
X_trainf7,X_test,Y_trainf7,Y_test = train_test_split(X,Y,test_size = test_proportion)
X_trainf8,X_test,Y_trainf8,Y_test = train_test_split(X,Y,test_size = test_proportion)
X_trainf9,X_test,Y_trainf9,Y_test = train_test_split(X,Y,test_size = test_proportion)
X_trainf10,X_test,Y_trainf10,Y_test = train_test_split(X,Y,test_size = test_proportion)


estimator1 = Id3Estimator()
estimator2 = Id3Estimator()
estimator3 = Id3Estimator()
estimator4 = Id3Estimator()
estimator5 = Id3Estimator()
#
estimator6 = Id3Estimator()
estimator7 = Id3Estimator()
estimator8 = Id3Estimator()
estimator9 = Id3Estimator()
estimator10 = Id3Estimator()

estimator1.fit (X_trainf1,Y_trainf1)
estimator2.fit (X_trainf2,Y_trainf2)
estimator3.fit (X_trainf3,Y_trainf3)
estimator4.fit (X_trainf4,Y_trainf4)
estimator5.fit (X_trainf5,Y_trainf5)
#
estimator6.fit (X_trainf6,Y_trainf6)
estimator7.fit (X_trainf7,Y_trainf7)
estimator8.fit (X_trainf8,Y_trainf8)
estimator9.fit (X_trainf9,Y_trainf9)
estimator10.fit (X_trainf10,Y_trainf10)

dot_data = export_graphviz(estimator1.tree_,'random_forest_tree1.dot')

estimator1.predict(X_test)