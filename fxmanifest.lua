fx_version 'cerulean'
game 'gta5'

description 'Lavado de diferentes tipos de dinero ilegal'
author 'facoe'
version '1.2.0'

shared_script 'config.lua'
client_script 'cl_moneywash.lua'
server_script 'sv_moneywash.lua'

dependencies {
    'qb-core',
    'qb-target',
    'qb-menu',
    'qb-input'
}
