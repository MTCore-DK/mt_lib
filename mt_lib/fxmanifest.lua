fx_version 'cerulean'
game 'gta5'

name 'mt_lib'
author 'MT Core'
description 'Modern shared utility library for FiveM'
version '1.9.2'

lua54 'yes'

-- =========================================================
-- NUI
-- =========================================================

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'locales/*.json'
}


-- =========================================================
-- SHARED
-- =========================================================

shared_scripts {
    'config.lua',
    'init.lua',

    -- State
    'modules/state/shared.lua',

    -- Locale
    'modules/locale/shared.lua',

    -- Framework
    'modules/framework/shared.lua'
}


-- =========================================================
-- CLIENT
-- =========================================================

client_scripts {
    -- UI
    'modules/ui/notify.lua',
    'modules/ui/progress.lua',
    'modules/ui/input.lua',
    'modules/ui/menu.lua',

    -- Callbacks
    'modules/callbacks/client.lua',

    -- Player
    'modules/player/client.lua',

    -- Zones
    'modules/zones/client.lua',

    -- Target
    'modules/target/client.lua'
}


-- =========================================================
-- SERVER
-- =========================================================

server_scripts {
    -- Callbacks
    'modules/callbacks/server.lua',

    -- Player
    'modules/player/server.lua',

    -- Permissions
    'modules/permissions/server.lua',

    -- Inventory
    'modules/inventory/server.lua'
}
