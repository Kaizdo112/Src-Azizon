fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'stakev_hud'
author 'StakeV'
description 'HUD StakeV - phong cách GTA V Modern Premium'
version '0.1.0'

dependencies { 'es_extended' }

shared_script '@es_extended/imports.lua'
client_script 'client/main.lua'

ui_page 'html/index.html'
files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
}
