fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'stakev_core'
author 'StakeV'
description 'Lõi StakeV: cầu nối ESX, log, phân quyền, tiện ích dùng chung'
version '0.1.0'

dependencies {
    'es_extended',
    'oxmysql',
}

shared_scripts {
    '@es_extended/imports.lua',
    'shared/config.lua',
    'shared/utils.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/logs.lua',
    'server/admin.lua',
}

client_scripts {
    'client/main.lua',
}
