fx_version 'cerulean'
game 'gta5'

author 'bd_farmermilk'
description 'Script pour dérober de l\'argent sur les ATM'
version '1.0'

client_scripts {
    'client.lua'
}

-- config 

shared_script 'config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}
