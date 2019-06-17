from id3 import Id3Estimator, export_graphviz
import numpy as np
import graphviz

feature_names = ["color",
                 "forma",
                 "tamanio"]

x = np.array([["rojo", "cuadrado", "grande"],
              ["azul", "cuadrado", "grande"],
              ["rojo", "redondo", "pequenio"],
              ["verde", "cuadrado", "pequenio"],
              ["rojo", "redondo", "grande"],
              ["verde", "cuadrado", "grande"]])

y = np.array(["+",
              "+",
              "-",
              "-",
              "+",
              "-"])

id3 = Id3Estimator()
id3.fit(x, y)

export_graphviz(id3.tree_, 'objetos.dot', feature_names)
with open("objetos.dot") as f:
    dot_graph = f.read()
g = graphviz.Source(dot_graph)
g.render()
g.view()



