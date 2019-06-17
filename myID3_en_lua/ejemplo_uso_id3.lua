local json      = require("json")
local inspect   = require ("inspect")
local math      = require("math")
local arbol = require("arbol")

--[[
    -el programa supone que todos los datos se encontraran en un archivo de extension .json
    -los elementos del json ya deben estar debidamente etiquetados, ya sea con cadenas o numeros pero se
        recomienda ampliamente que se haga con numeros
    ejemplo de valor

    {
    "hora_partido":0,    <---- valores posibles = 0,1,2 => mañana,tarde,noche
    "tipo":2,            <---- valores posibles = 0,1,2 => amistoso,olimpico,mundial
    "condiciones":3,     <---- valores posibles = 0,1,2,3 => pesimas, malas, buenas, excelentes
    "local":1,           <---- valores posibles = 0,1
    "ganador":0          <---- valores posibles = 0,1 => mexico,alemania
    }

    -las librerias necesarias para que el programa funcione estan contenidas en el mismo archivo
        excepto math que ya es una libreria estandar de lua
    -lua debera ser instalado y puesto la ruta del directorio donde fue instalado en el path
    -para ser instalado basta con descargar los binarios en la siguiente pagina:

        http://luabinaries.sourceforge.net/download.html

        deberan ser descargados los archivos : 
            lua-[num].[num].[num]_win32_bin.zip y 
            lua-[num].[num].[num]_ddlw4_lib.zip 
        los archivos que contiene la carpeta de binarios son todo lo que se necesita para poder ejecutar 
        un archivo de lua,es decir no requiere un programa "setup" ni nada por el estilo

        - una vez este el directorio de instalacion de lua
            en el path la forma en la que se ejecutara el archivo es:

            EJEMPLO: 
                    lua ejemplo_uso_id3.lua [enter]

                ó en el caso de tener el interprete de lua con nombre similar a lua[num] la sintaxis sera

                    lua[num] ejemplo_uso_id3.lua [enter]

    -la funcion ID3 tiene como parametros:
        - al set de datos cargado ya en memoria
        - una cadena o identificaddor con el nombre de la columna en donde se aloja el dato a evaluar(en este caso, "ganador")
        - los valores que puede tener dicha columna empezando por el que se considera positivo(en este caso 0,1; mexico, alemania)
        - la estructura de datos que almacene con la sintaxis mostrada todos los valores que puede tener el arbol
            en el caso de la columna condiciones esta tiene como valores en el archivo JSON a 
            {0,1,2,3} y su interpretacion es {"pesimas","malas","buenas","excelentes"}
            para esto es bueno aclarar que en lua la unica estructura de datos que existe es la tabla-hash y con esta
            se puede implementar todos los tipos de datos conocidos.

    - para obtener la cadena de salida del arbol por caminos positivos y negativos se usa la funcion get_tree_representation
        que recibe como valores :
            - el valor positivo evaluado en la columna "ganador"
            - el valor negativo ecaluado en la columna "ganador"
            - el conjunto de valores posibles en todo el conjunto de datos

    - para ejecutar la instruccion leave_one_out que hace justo lo que su nombre indica solo es necesario
        el conjunto de datos sin procesar

    - si requiere una representaicon en orden de evaluacion del arbol puede usar la instruccion:
        inspect_tree()
        la cual imprimira en orden decendente cada una de las hojas asi como las condiciones que se requeren para
        poder llegar a ellas
]]
data = jsonM.load("./tarea1_1.json")
local valores_originales = {}
valores_originales["condiciones"]={"pesimas","malas","buenas","excelentes"}
valores_originales["hora_partido"]={"mañana","tarde","noche"}
valores_originales["tipo"]={"amistoso","olimpico","mundial"}
valores_originales["local"]={"0","1"}
valores_originales["ganador"]={"Alemania","Mexico"}
local eval_element=leave_one_out(data)
ID3(data,"ganador",0,1,valores_originales)
print("----------------------------------------------------")
get_tree_representation(0,1,valores_originales)
eval_tree(eval_element,valores_originales)