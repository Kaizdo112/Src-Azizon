fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'stakev_spawn'
author 'StakeV'
description 'Màn hình chọn điểm xuất hiện StakeV'
version '0.1.0'

dependencies { 'es_extended', 'oxmysql' }

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}
client_script 'client/main.lua'

ui_page 'html/index.html'
files { 'html/index.html', 'html/style.css', 'html/app.js' }
