mt.lib = mt.lib or {}

local menus = {}


-- =========================================================
-- REGISTER MENU
-- =========================================================

function mt.lib.registerMenu(id, menu)

    if type(id) ~= 'string' then
        error('mt.lib.registerMenu: id must be a string')
    end

    if type(menu) ~= 'table' then
        error(
            ('mt.lib.registerMenu: menu "%s" must be a table')
            :format(id)
        )
    end

    menus[id] = menu

    return true
end


-- =========================================================
-- UNREGISTER MENU
-- =========================================================

function mt.lib.unregisterMenu(id)

    if type(id) ~= 'string' then
        return false
    end

    if not menus[id] then
        return false
    end

    menus[id] = nil

    return true
end


-- =========================================================
-- SHOW MENU
-- =========================================================

function mt.lib.showMenu(id)

    if type(id) ~= 'string' then
        return false
    end

    local menu = menus[id]

    if not menu then

        print(
            ('[mt_lib] Menu "%s" is not registered.')
            :format(id)
        )

        return false
    end


    SendNUIMessage({
        action = 'menu',

        id = id,

        menu = menu
    })


    SetNuiFocus(
        true,
        true
    )


    return true
end


-- =========================================================
-- HIDE MENU
-- =========================================================

function mt.lib.hideMenu()

    SendNUIMessage({
        action = 'hideMenu'
    })

    SetNuiFocus(
        false,
        false
    )
end


-- =========================================================
-- MENU SELECT
-- =========================================================

RegisterNUICallback(
    'menuSelect',
    function(data, cb)

        local menuId = data.id

        local menu = menus[menuId]


        if not menu then

            cb('ok')

            return
        end


        if type(menu.onSelect) == 'function' then

            local success, errorMessage =
                pcall(
                    menu.onSelect,
                    data.value,
                    data
                )


            if not success then

                print(
                    ('[mt_lib] Menu "%s" onSelect error: %s')
                    :format(
                        menuId,
                        errorMessage
                    )
                )
            end
        end


        SetNuiFocus(
            false,
            false
        )


        cb('ok')
    end
)


-- =========================================================
-- MENU CLOSE
-- =========================================================

RegisterNUICallback(
    'menuClose',
    function(data, cb)

        local menuId =
            data and data.id

        local menu =
            menuId and menus[menuId]


        if menu and
            type(menu.onClose) == 'function'
        then

            local success, errorMessage =
                pcall(
                    menu.onClose
                )


            if not success then

                print(
                    ('[mt_lib] Menu "%s" onClose error: %s')
                    :format(
                        menuId,
                        errorMessage
                    )
                )
            end
        end


        SetNuiFocus(
            false,
            false
        )


        cb('ok')
    end
)


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'registerMenu',
    mt.lib.registerMenu
)

exports(
    'unregisterMenu',
    mt.lib.unregisterMenu
)

exports(
    'showMenu',
    mt.lib.showMenu
)

exports(
    'hideMenu',
    mt.lib.hideMenu
)
