fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'stakev_identity'
author 'StakeV'
description 'Tạo nhân vật StakeV (thay cho esx_identity): họ tên, ngày sinh, giới tính, chiều cao, ngoại hình'
version '0.1.0'

dependencies { 'es_extended', 'oxmysql', 'skinchanger', 'esx_skin' }

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
