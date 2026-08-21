mt = mt or {}

mt.framework = {
    name = 'standalone',
    core = nil,
    ready = false
}


-- =========================================================
-- FRAMEWORK DETECTION
-- =========================================================

CreateThread(function()

    -- ESX
    if GetResourceState('es_extended') == 'started' then

        mt.framework.name = 'esx'

        local success, core =
            pcall(function()
                return exports['es_extended']:getSharedObject()
            end)

        if success then
            mt.framework.core = core
        end


    -- QBCore
    elseif GetResourceState('qb-core') == 'started' then

        mt.framework.name = 'qb'

        local success, core =
            pcall(function()
                return exports['qb-core']:GetCoreObject()
            end)

        if success then
            mt.framework.core = core
        end


    -- vRP
    elseif GetResourceState('vrp') == 'started' then

        mt.framework.name = 'vrp'

        mt.framework.core = nil


    -- Standalone
    else

        mt.framework.name = 'standalone'

        mt.framework.core = nil
    end


    mt.framework.ready = true


    if mt.config and mt.config.debug then

        print(
            ('[mt_lib] Framework detected: %s')
            :format(
                mt.framework.name
            )
        )
    end

end)


-- =========================================================
-- GET FRAMEWORK
-- =========================================================

function mt.lib.getFramework()

    return mt.framework.name
end


-- =========================================================
-- GET FRAMEWORK CORE
-- =========================================================

function mt.lib.getFrameworkCore()

    return mt.framework.core
end


-- =========================================================
-- CHECK FRAMEWORK
-- =========================================================

function mt.lib.isFramework(framework)

    if type(framework) ~= 'string' then
        return false
    end

    return mt.framework.name ==
        framework:lower()
end


-- =========================================================
-- FRAMEWORK READY
-- =========================================================

function mt.lib.isFrameworkReady()

    return mt.framework.ready
end


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'getFramework',
    mt.lib.getFramework
)

exports(
    'getFrameworkCore',
    mt.lib.getFrameworkCore
)

exports(
    'isFramework',
    mt.lib.isFramework
)

exports(
    'isFrameworkReady',
    mt.lib.isFrameworkReady
)
