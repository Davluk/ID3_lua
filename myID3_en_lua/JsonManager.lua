local json = require("json")
local Jsonstorage = {}

Jsonstorage.save = function(jsonObject,filename)
    local path = system.pathForFile(filename,system.DocumentsDirectory)
    local file = io.open(path,"w")

    if file then 
        local contents = json.encode(JsonObject)
        file:write(contents)
        io.close(file)
        return true 
    else 
        return false 
    end 
end 


Jsonstorage.load = function (filename)
    local path = system.pathForFile(filename,system.DocumentsDirectory)
    local contents = {}
    local mytable = {}
    local file = io.open (path,"r")

    if file then 
        local contents = file:read("*a")
        mytable = json.decode(contents);
        io.close(file)
        return mytable 
    end 
    return nil 
end 

return Jsonstorage
