local M = {}
 
local json = require( "json" )
local defaultLocation = system.DocumentsDirectory
 
 
function M.saveTable( t, filename, location )
 
    local loc = location
    if not location then
        loc = defaultLocation
    end
 
    -- percorso per salvare il file
    local path = system.pathForFile( filename, loc )
 
    -- apertura file
    local file, errorString = io.open( path, "w" )
 
    if not file then
        -- printare l'errore/ causa
        print( "File error: " .. errorString )
        return false
    else
        -- codificare il file JSON 
        file:write( json.encode( t ) )
        -- chiusura file
        io.close( file )
        return true
    end
end

function M.loadTable( filename, location )
 
    local loc = location
    if not location then
        loc = defaultLocation
    end
 
    -- percorso per la lettura del file
    local path = system.pathForFile( filename, loc )
 
    -- apertura file
    local file, errorString = io.open( path, "r" )
 
    if not file then
        -- printare l'errore/ causa
        print( "File error: " .. errorString )
    else
        -- Read data from file
        local contents = file:read( "*a" )
        -- decodifica JSON in formato lua
        local t = json.decode( contents )
        -- chiusura file
        io.close( file )
        -- ritorno
        return t
    end
end
 
return M