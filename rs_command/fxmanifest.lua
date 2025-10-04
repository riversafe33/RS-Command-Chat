version '1.0.0'
author 'riversafe'

fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

shared_scripts {
    'Configmain.lua',
    'log.lua',
}

client_scripts { 
    'Configmain.lua',
    'client.lua',
}

server_scripts {
    'Configmain.lua',
    'log.lua',
    'server.lua',
}

