local json = require 'json'

local postalCoords = {}

-- Function to load JSON file
local function loadPostalData()
    local file = LoadResourceFile(GetCurrentResourceName(), 'postals.json')
    if file then
        postalCoords = json.decode(file)
    else
        print("Error: Unable to load postals.json")
    end
end

local function getClosestPostal()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local closestPostal = nil
    local minDistance = nil

    for _, postal in ipairs(postalCoords) do
        local distance = #(playerPos - vector3(postal.x, postal.y, 0.0))
        if minDistance == nil or distance < minDistance then
            closestPostal = postal
            minDistance = distance
        end
    end

    return closestPostal
end

Citizen.CreateThread(function()
    loadPostalData()
    while true do
        Citizen.Wait(500) -- Update every 500ms
        
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local closestPostal = getClosestPostal()
        local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z))

        if closestPostal then
            
            SendNUIMessage({
                type = 'updateHud',
                postal = closestPostal.code,
                street = streetName
            })
        else
            print("Closest postal not found")
        end
    end
end)

RegisterNetEvent('showGpsMarker')
AddEventHandler('showGpsMarker', function(x, y)
    SetNewWaypoint(x, y)
end)

RegisterCommand('gps', function(source, args)
    local postalCode = tonumber(args[1])
    if postalCode then
        TriggerServerEvent('setGpsMarker', postalCode)
    else
        print("Invalid postal code. Usage: /gps [postalCode]")
    end
end, false)



