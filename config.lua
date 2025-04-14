Config = {}


-- jobs that are allowed to issue citations
Config.Jobs = {
    ['police'] = true,
    ['sheriff'] = true,
    ['state'] = true
}


-- if the player issuing the fine is not in this radius from the target player they will be kicked for exploiting
Config.FINE_RADIUS = 10.0 

-- self explanatory, whatever you want the command to be called. "citation" would be /citation in game.
Config.FineCommand = "fine"


-- Configure this to change what the script does after the money is removed from the player.
Config.SocietyLogic = function(src, targetname, sourcename, amount, job)

    local society = job
    local description =  (targetname .. " was fined by player %s"):format(sourcename)


    exports['av_laptop']:addSociety(src, society, amount, sourcename, description)
end


