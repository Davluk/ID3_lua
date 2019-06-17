from id3 import Id3Estimator, export_graphviz
import numpy as np
import graphviz

features = ["Hora", "TipoDeJuego", "SuperficieDeLaCancha", "BestEffort"]
##datatable
x = np.array([["Manana", "Master", "Pasto", "1"],
    ["Tarde", "GrandSlam", "Arcilla", "1"],
    ["Noche", "Amistoso", "Concreto", "0"],
    ["Tarde", "Amistoso", "Madera", "0"],
    ["Tarde", "Master", "Arcilla", "1"],
    ["Tarde", "GrandSlam", "Pasto", "1"],
    ["Tarde", "GrandSlam", "Concreto", "1"],
    ["Tarde", "GrandSlam", "Concreto", "1"],
    ["Manana", "Master", "Pasto", "1"],
    ["Tarde", "GrandSlam", "Arcilla", "0"],
    ["Noche", "Amistoso", "Concreto", "0"],
    ["Noche", "Master", "Madera", "1"],
    ["Tarde", "Master", "Arcilla", "1"],
    ["Tarde", "Master", "Pasto", "1"],
    ["Tarde", "GrandSlam", "Concreto", "1"],
    ["Tarde", "GrandSlam", "Arcilla", "1"]
])

##data results table
y = np.array([
    "Federer", "Federer", "Federer", "Djokovic", "Djokovic",
    "Federer", "Federer", "Federer", "Federer", "Djokovic", "Federer",
    "Djokovic", "Djokovic", "Federer","Federer","Federer"
])

# Leave-one-out#########################################################
n = np.random.randint(0, x.shape[0])## select randomly a data test
x_test = np.array([x[n]])
x_train = np.delete(x, n, 0)
y_test = np.array([y[n]])
y_train = np.delete(y, n, 0)
########################################################################

id3 = Id3Estimator()####################################################
id3.fit(x_train, y_train)###############################################

# Testing

y_predict = id3.predict(x_test)#########################################
# Precision
print("Precision")
print("Input: ", x_test, "| Expected: ", y_test, "| Result: ", y_predict)
if np.array_equal(y_test, y_predict):
    print("100%")
else:
    print("0%")


export_graphviz(id3.tree_, 'tree_p1.dot', features)
#with open("tree_p1.dot") as f:
#    dot_graph = f.read()
#g = graphviz.Source(dot_graph)
#g.render()
#g.view()
