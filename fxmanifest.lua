shared_script "@ReaperV4/bypass.lua"
lua54 "yes" -- needed for Reaper

fx_version 'cerulean'
game 'gta5'

description 'https://www.buymeacoffee.com/rilexbtw'
author 'RilexBTW'

client_scripts {
    '@ox_lib/init.lua',
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

shared_script 'config.lua'

