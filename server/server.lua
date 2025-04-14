local QBCore = exports['qb-core']:GetCoreObject()
local FINE_RADIUS = Config.FINE_RADIUS 

RegisterServerEvent('rilex-citation:sendFine', function(targetId, amount)
    local src = source
    local target = tonumber(targetId)
    local amount = tonumber(amount)

    if not target or not amount then return end

    local srcPlayer = QBCore.Functions.GetPlayer(src)
    local targetPlayer = QBCore.Functions.GetPlayer(target)

    if not srcPlayer or not targetPlayer then return end
    local sourcefirstname = srcPlayer.PlayerData.charinfo.firstname
    local sourcelastname = srcPlayer.PlayerData.charinfo.lastname
    local sourcename = string.format("%s %s", sourcefirstname, sourcelastname)
    
    local targetfirstname = targetPlayer.PlayerData.charinfo.firstname
    local targetlastname = targetPlayer.PlayerData.charinfo.lastname
    local targetname = string.format("%s %s", targetfirstname, targetlastname)
    

    
    local job = srcPlayer.PlayerData.job.name

    if not Config.Jobs[job] then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Unauthorized',
            description = 'You do not have permission to issue fines.',
            type = 'error'
        })
        return
    end
    

    local srcPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(target)
    
    if not srcPed or not targetPed then
        DropPlayer(src, 'Exploit detected: Missing player ped.')
        return
    end
    
    local srcCoords = GetEntityCoords(srcPed)
    local targetCoords = GetEntityCoords(targetPed)
    

    if #(srcCoords - targetCoords) > Config.FINE_RADIUS then
        DropPlayer(src, 'Exploit detected: Tried to fine a distant player.')
        return
    end


    local removed = targetPlayer.Functions.RemoveMoney('bank', amount, 'fined-by-' .. GetPlayerName(src))

    if not removed then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Fine Failed',
            description = ('%s did not have enough money in their bank.'):format(targetname),
            type = 'error'
        })
        return
    end


    TriggerClientEvent('ox_lib:notify', target, {
        title = 'Fine Received',
        description = ('You were fined $%s by %s'):format(amount, sourcename),
        type = 'inform'
    })


    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Fine Sent',
        description = ('You fined %s $%s'):format(targetname, amount),

        type = 'success'
    })
    Config.SocietyLogic(src, targetname, sourcename, amount, job)

end)


local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('rilex-citation:getNearbyCharacterNames', function(players)
    local src = source
    local updated = {}

    for _, playerData in ipairs(players) do
        local targetId = playerData.value
        local Player = QBCore.Functions.GetPlayer(tonumber(targetId))
        if Player then
            local charInfo = Player.PlayerData.charinfo
            table.insert(updated, {
                value = targetId,
                label = ("%s %s (ID: %d)"):format(charInfo.firstname, charInfo.lastname, targetId)
            })
        end
    end

    TriggerClientEvent('rilex-citation:receivePlayerNames', src, updated)
end)




