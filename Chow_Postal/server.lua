local postalCoords = {}

-- Load postal data from JSON file
local function loadPostalData()
    local file = LoadResourceFile(GetCurrentResourceName(), 'postals.json')
    if file then
        postalCoords = json.decode(file)
       
    else
        print("Error: Unable to load postals.json")
    end
end

loadPostalData() -- Call the function to load data at resource start

-- Function to find postal data by postal code
function findPostal(postalCode)
    for _, postal in ipairs(postalCoords) do
        if postal.code == postalCode then
            return postal
        end
    end
    return nil
end

RegisterServerEvent('setGpsMarker')
AddEventHandler('setGpsMarker', function(postalCode)
    local postal = findPostal(tostring(postalCode)) -- Convert postalCode to string
    if postal then
        -- Send coordinates to client to set GPS marker
        TriggerClientEvent('showGpsMarker', source, postal.x, postal.y)
        print(string.format("GPS marker set for postal %s", postalCode))
    else
       
        -- Optionally notify the client that the postal code was not found
        -- TriggerClientEvent('notifyPlayer', source, "Postal code not found.")
    end
end)
