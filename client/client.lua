local QBCore = exports['qb-core']:GetCoreObject()

local function GetNearbyPlayers(radius)
    local players = {}
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    for _, player in pairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= ped and #(coords - GetEntityCoords(targetPed)) < radius then
            local serverId = GetPlayerServerId(player)


            TriggerServerEvent('rilex-citation:requestPlayerName', serverId)


            table.insert(players, {
                value = serverId,
                label = "Player ID: " .. serverId .. " (Loading...)"
            })
        end
    end

    return players
end

RegisterNetEvent('rilex-citation:receivePlayerNames', function(updatedPlayers)
    local selection = lib.inputDialog('Fine a Player', {
        {
            type = 'select',
            label = 'Select Player',
            options = updatedPlayers,
            icon = 'user',
            required = true
        },
        {
            type = 'number',
            label = 'Fine Amount',
            icon = 'dollar-sign',
            required = true,
            min = 1
        }
    })

    if not selection then return end

    local targetId = selection[1]
    local fineAmount = selection[2]

    TriggerServerEvent('rilex-citation:sendFine', targetId, fineAmount)
end)

RegisterCommand(Config.FineCommand, function()
    local nearbyPlayers = GetNearbyPlayers(10.0)

    if #nearbyPlayers == 0 then
        lib.notify({
            title = 'Fine System',
            description = 'No nearby players found.',
            type = 'error'
        })
        return
    end
    TriggerServerEvent('rilex-citation:getNearbyCharacterNames', nearbyPlayers)
end, false)
