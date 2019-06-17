local json      = require("json")
local inspect   = require ("inspect")
local math      = require("math")
jsonM     = {}
leafs = {}
arbol = {}
math.randomseed(os.time())

jsonM.save = function(jsonObject,filename)
    local file = io.open(filename,"w")

    if file then 
        local contents = json.encode(JsonObject)
        file:write(contents)
        io.close(file)
        return true 
    else 
        return false 
    end 
end 

jsonM.load = function (filename)
    local contents = {}
    local mytable = {}
    local file = io.open (filename,"r")

    if file then 
        local contents = file:read("*a")
        mytable = json.decode(contents);
        io.close(file)
        return mytable 
    end 
    return nil 
end 

function logn(number,base)
    return (math.log(number))/(math.log(base))
end

function entrophy_element(value,total)
    return (value/total)*logn(value/total,2)
end

function entrophy(x,y)
    if(x==0 or y ==0)then return 0 end 
    if(x==y)then return 1 end
    return -entrophy_element(x,x+y) - entrophy_element(y,x+y)
end

function ganancia_element(x,y,total)
    return (x+y)/total*entrophy(x,y)
end

function ganancia_element_condition(ldata,lfit_column,lpos_value,lneg_value,total,lconditions)
    local pos_conditions={}
    local neg_conditions={}
    for k,v in pairs(lconditions)do
        pos_conditions[k]=v
        neg_conditions[k]=v
    end
    pos_conditions[#pos_conditions+1]={key=lfit_column,value=lpos_value}
    neg_conditions[#neg_conditions+1]={key=lfit_column,value=lneg_value}
    local positive_count = count_value_condition(ldata,pos_conditions)
    local negative_count = count_value_condition(ldata,neg_conditions)
    local gan_element = ganancia_element(positive_count,negative_count,total)
    return {ganancia = gan_element,positivos = positive_count,negativos = negative_count,condiciones = lconditions}
end

function ganancia_condition(ldata,lfit_column,lpos_value,lneg_value,column,table_values,lconditions)
    local each_conditions = {}
    local temporal_total = count_value_condition(ldata,lconditions)
    local temp_pos = {}
    local temp_neg = {}
    local temp_each_conditions={{}}
    local temp_leafs = {}
    temp_leafs.columna = column
    temp_leafs.conditions = lconditions
    temp_leafs.leaf_results = {}
    if(column == lfit_column)then
    temp_leafs.ganancia         = 0
    temp_leafs.entropia_inicial = 0
    return temp_leafs
    end

    for k,v in pairs(lconditions) do 
        temp_pos[k]=v
        temp_neg[k]=v
    end

    temp_pos[#temp_pos+1]={key=lfit_column,value=lpos_value}
    temp_neg[#temp_neg+1]={key=lfit_column,value=lneg_value}
    local total_pos = count_value_condition(ldata,temp_pos)
    local total_neg = count_value_condition(ldata,temp_neg)
    local initial_entropy = entrophy(total_pos,total_neg)
    local final_entropy = initial_entropy

   for index =1 , #table_values[column] , 1 do 
        temp_each_conditions[index]={{key=column,value=table_values[column][index]}}
        for k,v in pairs(lconditions)do
            temp_each_conditions[index][k+1]=v
        end
    end

    for k,v in pairs(temp_each_conditions)do
        local gan_info = ganancia_element_condition(ldata,lfit_column,lpos_value,lneg_value,temporal_total,v)
        temp_leafs.leaf_results[k]=gan_info
        if(gan_info.ganancia~=0)then
            final_entropy=final_entropy - gan_info.ganancia
        end
    end
    temp_leafs.ganancia = final_entropy
    temp_leafs.entropia_inicial = initial_entropy
    return temp_leafs
end

function count_value_condition (ldata,lconditions)--pass a cuple of condition tables
    local counter=0
    local condition=false
    for ikey,ivalue in pairs(data) do 
        condition=true
        for jkey,jvalue in pairs(lconditions) do
            condition = condition and (ivalue[jvalue.key]==jvalue.value)
        end
       if(condition)then 
        counter = counter + 1 
       end
    end
    return counter
end

function count_posible_table_values(table_data)
    local table_values = {}
    for key,value in pairs(table_data)do -- sirve para contabilizar las columnas y posibles valores que hay en ella
        
        if(key==1)then
            for k,v in pairs(value)do
                table_values[k]={v}
            end
        end

        if(key ~=  1)then 
            for keyj,valuej in pairs(value)do
                for keyi,valuei in pairs(table_values)do
                    local lcounter = 0
                    local lvalue = nil
                    local verificador = true
                    if(keyi == keyj)then --
                        for k,v in pairs(valuei) do
                            if(valuej == v)then verificador = false 
                            else lvalue = valuej
                            end
                        end
                    end
                    if(verificador)then valuei[#valuei+1]=lvalue end
                end
            end
        end

    end

    return table_values
end


function table.clone(arg)
    return {table.unpack(arg)}
end

function subID3(ldata,column_fit,positive_value,negative_value,valores_tabla,conditions,valores_verificados)
    local verificador = true
    if(#valores_verificados == (#valores_tabla-1))then 
        leafs[#leafs+1]={condiciones_pre=table.clone(conditions),condiciones_pos={},resultado="indeterminado"}    
        return
    end

    local positivos = 0
    local negativos = 0
    local temp_conditions = table.clone(conditions)
    local column_info={}
    temp_conditions[#temp_conditions+1]={key=column_fit,value=positive_value}
    positivos = count_value_condition(data,temp_conditions)
    negativos = count_value_condition(data,temp_conditions)

    local maximo = {}
    maximo.ganancia = 0
    for current_columna,valores in pairs(valores_tabla) do
        column_info[current_columna] = ganancia_condition(data,"ganador",1,0,current_columna,valores_tabla,conditions)
        if(column_info[current_columna].ganancia > maximo.ganancia)then maximo=column_info[current_columna] 
        end    
    end


    for k,v in pairs(maximo.leaf_results)do
        if(v.ganancia ==0)then
            if(v.positivos ==0)then 
                leafs[#leafs + 1]={condiciones_pre = table.clone(maximo.conditions),condiciones_pos=table.clone(v.condiciones),res_column=column_fit,resultado=positive_value}
            else 
                leafs[#leafs + 1]={condiciones_pre = table.clone(maximo.conditions),condiciones_pos=table.clone(v.condiciones),res_column=column_fit,resultado=negative_value}
            end
        else
            local lcondition = table.clone(conditions)
            lcondition[#lcondition+1]={key=v.condiciones[1].key,value=v.condiciones[1].value}
            local valores_visitados=valores_verificados
            valores_visitados[#valores_visitados+1]=maximo.columna
            subID3(data,column_fit,positive_value,negative_value,valores_tabla,lcondition,valores_visitados)
        end
    end
end

function get_tree_representation(positive_value,negative_value,original_values)
    local counter = 0

    hojas = table.clone(arbol)
    for key, value in pairs (hojas) do
        local cadena = ""
        if(value.resultado == positive_value)then
            counter = counter + 1
            if(counter == 1)then print("positive path (+)["..value.res_column.." = "..original_values[value.res_column][value.resultado+1].."] if:")end
            if(counter ~= 1)then print("or") end
            for pre_key,pre_value in pairs(value.condiciones_pos)do
                if(pre_key == 1) then 
                    cadena = pre_value.key.." = "..original_values[pre_value.key][pre_value.value+1]
                else
                    cadena = cadena.." and "..pre_value.key.." = "..original_values[pre_value.key][pre_value.value+1]
                end
            end
            print("{"..cadena.."}")
        end
    end

    counter = 0
    print("------------------------------------------------")
    for key, value in pairs (hojas) do
        local cadena = ""
        if(value.resultado == negative_value)then
            counter = counter + 1
            if(counter == 1)then print("negative path (-)["..value.res_column.." = "..original_values[value.res_column][value.resultado+1].."] if:")end
            if(counter ~= 1)then print("or") end
            for pre_key,pre_value in pairs(value.condiciones_pos)do
                if(pre_key == 1) then 
                    cadena = pre_value.key.." = "..original_values[pre_value.key][pre_value.value+1]
                else
                    cadena = cadena.." and "..pre_value.key.." = "..original_values[pre_value.key][pre_value.value+1]
                end
            end
            print("{"..cadena.."}")
        end
    end

end

function inspect_tree(original_values)
    inspect_leafs(arbol,original_values)
end

function inspect_leafs(hojas,original_values)
    if(original_values~=nil)then
        for key,value in pairs(hojas)do
            local cadena2 = ""
            for pre_key,pre_value in pairs(value.condiciones_pos)do
                if(pre_key == 1)then 
                    cadena2 =value.res_column.." = "..original_values[value.res_column][value.resultado+1].."\t if: "..pre_value.key.." = "..original_values[pre_value.key][pre_value.value+1]
                else
                    cadena2=cadena2.."\t and "..pre_value.key.." = "..original_values[pre_value.key][pre_value.value+1]
                end
            end  
            --print("resultado = "..value.resultado.." | "..cadena)
            --print(value.resultado)
            print("| "..cadena2.." |")
        end
    else
        for key,value in pairs(hojas)do
            local cadena1 = ""
            local cadena2 = ""
            for pre_key,pre_value in pairs(value.condiciones_pos)do
                if(pre_key == 1)then 
                    cadena2 = value.resultado.." if: "..pre_value.key.."="..pre_value.value
                else
                    cadena2=cadena2.." and "..pre_value.key.."="..pre_value.value
                end
            end  
            --print("resultado = "..value.resultado.." | "..cadena)
            --print(value.resultado)
            print("| "..cadena2.." |")
        end
    end
end

function ID3(ldata,column_fit,positive_value,negative_value,original_values)
    print("| column fit selected: "..column_fit.."| positive value: "..positive_value.."| negative value: "..negative_value.."|")
    
    local positivos = 0
    local negativos = 0
    local valores_de_tabla = count_posible_table_values(data)
    local column_info = {}
    
    if(#valores_de_tabla[column_fit]~=2)then print("the selected column have more than 2 posible values") return 
    end
    if(valores_de_tabla[column_fit][1]~=positive_value and valores_de_tabla[column_fit][2]~=positive_value)then print("the selected column doesn't contains the selected positive value: ".. positive_value) return 
    end
    if(valores_de_tabla[column_fit][1]~=negative_value and valores_de_tabla[column_fit][2]~=negative_value)then print("the selected column doesn't contains the selected negative value: ".. negative_value) return 
    end
    
    print("valores encontrados por columna:\n----------------\n"..inspect(valores_de_tabla).."\n--------------------------\n")

    positivos = count_value_condition(data,{{key=column_fit,value=positive_value}})
    negativos = count_value_condition(data,{{key=column_fit,value=negative_value}})

    print("| totales positivos: "..positivos.." | totales negativos: "..negativos.." |")
    local maximo = {}
    maximo.ganancia = 0
    for current_columna,valores in pairs(valores_de_tabla) do
        column_info[current_columna] = ganancia_condition(data,"ganador",1,0,current_columna,valores_de_tabla,{})
        if(column_info[current_columna].ganancia > maximo.ganancia)then maximo=column_info[current_columna] 
        end    
    end


    for k,v in pairs(maximo.leaf_results)do
        if(v.ganancia ==0)then
            if(v.positivos ==0)then 
                leafs[#leafs + 1]={condiciones_pre = table.clone(maximo.conditions),condiciones_pos=v.condiciones,res_column=column_fit,resultado=positive_value}
            else 
                leafs[#leafs + 1]={condiciones_pre = table.clone(maximo.conditions),condiciones_pos=v.condiciones,res_column=column_fit,resultado=negative_value}
            end
        else
            local lcondition = {{key=v.condiciones[1].key,value=v.condiciones[1].value}}
            local valores_visitados={}
            valores_visitados[#valores_visitados+1]=maximo.columna
            subID3(data,column_fit,positive_value,negative_value,valores_de_tabla,lcondition,valores_visitados)
        end
    end
    --[[if(original_values~=nil)then
        inspect_leafs(leafs,original_values)
    else
        inspect_leafs(leafs)
    end]]
    build_tree()
end

function leave_one_out (dataset)
    local selection_index = math.random(1,#dataset)
    local item_table = dataset[selection_index]
    table.remove(dataset,selection_index)
    return item_table
end

function build_tree()
    local level_count=0
    --print(leafs[1]["condiciones_pos"][1].key)
    for key,value in pairs(leafs)do
        if(#value.condiciones_pos > level_count)then level_count = #value.condiciones_pos end
    end
    
    
    for index=1,level_count,1 do
        for key,value in pairs(leafs)do
            if(#value.condiciones_pos==index)then arbol[#arbol+1]=value
            end
        end
    end

end

function eval_tree(element,original_values)
    print("----------------------------------------------------")
    print(" resultado de evaluar el arbol:")
    local tree = table.clone (arbol)
    for keyi,valuei in pairs(tree) do
        local condition=true
        for keyj,valuej in pairs(valuei.condiciones_pos)do
            for keyk,valuek in pairs(element)do
                if (keyk == valuej.key)then condition = condition and (valuek==valuej.value) end
            end
        end
        if(condition)then 
            print("el valor deseado es: "..original_values[valuei.res_column][element[valuei.res_column]+1].." y el valor obtenido es: "..original_values[valuei.res_column][valuei.resultado+1]) 
            --print("elemento: "..inspect(element).."\n--------------\n".."condicion: "..inspect(valuei))
            return end
    end
end

--[[data = jsonM.load("./tarea1_1.json")
local valores_originales = {}
valores_originales["condiciones"]={"pesimas","malas","buenas","excelentes"}
valores_originales["hora_partido"]={"mañana","tarde","noche"}
valores_originales["tipo"]={"amistoso","olimpico","mundial"}
valores_originales["local"]={"0","1"}
valores_originales["ganador"]={"Alemania","Mexico"}
local eval_element=leave_one_out(data)
ID3(data,"ganador",0,1,valores_originales)
print("----------------------------------------------------")
get_tree_representation(arbol,0,1,valores_originales)
--eval_tree(eval_element,valores_originales)]]

