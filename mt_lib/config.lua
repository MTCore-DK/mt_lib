mt = mt or {}

mt.config = {

    -- =====================================================
    -- GENERAL
    -- =====================================================

    name = 'mt_lib',

    version = '1.0.0',

    debug = false,

    -- Automatically clean txAdmin-related UI/data
    txAdminClean = true,


    -- =====================================================
    -- LOCALE
    -- =====================================================

    -- Available:
    -- en, da, de, fr, es, it, nl, no,
    -- sv, fi, pl, pt, tr, ru, cs

    locale = 'en',


    -- =====================================================
    -- UI THEME
    -- =====================================================

    theme = {

        -- Primary
        primary = '#6366f1',

        -- Status
        success = '#22c55e',
        error = '#ef4444',
        warning = '#f59e0b',
        info = '#3b82f6',

        -- Background
        background = '#141414',
        backgroundLight = '#1e1e1e',

        -- Borders
        border = 'rgba(255, 255, 255, 0.08)',
        borderLight = 'rgba(255, 255, 255, 0.12)',

        -- Text
        text = '#f5f5f5',
        textMuted = '#a3a3a3',

        -- Components
        radius = '5px',

        shadow =
            '0 8px 30px rgba(0, 0, 0, 0.45)'
    },


    -- =====================================================
    -- NOTIFICATIONS
    -- =====================================================

    notifications = {

        -- Default notification duration
        duration = 5000,

        -- Maximum notifications displayed at once
        maxVisible = 5,

        -- Position
        position = 'top-right',

        -- Enable notification sounds
        sound = false
    },


    -- =====================================================
    -- PROGRESS
    -- =====================================================

    progress = {

        -- Default duration
        duration = 3000,

        -- Default color
        color = 'primary',

        -- Default icon
        icon = '⏳'
    },


    -- =====================================================
    -- INPUT
    -- =====================================================

    input = {

        -- Close input when pressing ESC
        allowCancel = true
    },


    -- =====================================================
    -- MENU
    -- =====================================================

    menu = {

        -- Close menu with ESC
        allowCancel = true,

        -- Close menu after selecting an option
        closeOnSelect = true
    },


    -- =====================================================
    -- CALLBACKS
    -- =====================================================

    callbacks = {

        -- Timeout in milliseconds
        timeout = 10000,

        -- Debug callback errors
        debug = false
    },


    -- =====================================================
    -- GITHUB / VERSION
    -- =====================================================

    github = {

        version =
            'https://raw.githubusercontent.com/MTCore-DK/mt_lib/main/version.txt',

        repo =
            'https://github.com/MTCore-DK/mt_lib',

        -- Enable automatic version checking
        enabled = true,

        -- Check interval in minutes
        interval = 60
    },


    -- =====================================================
    -- DISCORD
    -- =====================================================

    discord = {

        -- Optional webhook
        webhook = '',

        -- Enable update notifications
        updateNotifications = false
    }

}
