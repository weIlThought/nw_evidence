fx_version 'cerulean'
games { 'gta5' }

name "NWRP-LSPD Storage"
description "Police Evidence & Storage System"
author "J.C."
version "1.0.0"
lua54 'yes'


shared_scripts {
    '@ox_lib/init.lua',
	'@es_extended/locale.lua',
	'@es_extended/imports.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

dependencies{
	'ox_lib'
}
