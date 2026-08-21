mt.lib = mt.lib or {}

local callbacks = {}


-- =========================================================
-- REGISTER CALLBACK
-- =========================================================

function mt.lib.registerCallback(name, fn)

    if type(name) ~= 'string' then
        error('mt.lib.registerCallback: name must be a string')
    end

    if type(fn) ~= 'function' then
        error(
            ('mt.lib.registerCallback: callback "%s" must be a function')
            :format(name)
        )
    end

    callbacks[name] = fn

    return true
end


-- =========================================================
-- CALLBACK REQUEST
-- =========================================================

RegisterNetEvent('mt_lib:cb:req', function(name, id, ...)
    local src = source

    if type(name) ~= 'string' then
        return
    end

    if type(id) ~= 'number' then
        return
    end

    local callback = callbacks[name]

    if not callback then
        print(
            ('[mt_lib] Callback "%s" is not registered.')
            :format(name)
        )

        TriggerClientEvent(
            'mt_lib:cb:res',
            src,
            id,
            nil
        )

        return
    end


    -- =====================================================
    -- EXECUTE CALLBACK
    -- =====================================================

    local success, result = pcall(
        callback,
        src,
        ...
    )


    if not success then

        print(
            ('[mt_lib] Callback "%s" failed: %s')
            :format(name, result)
        )

        TriggerClientEvent(
            'mt_lib:cb:res',
            src,
            id,
            nil
        )

        return
    end


    -- =====================================================
    -- SEND RESULT TO CLIENT
    -- =====================================================

    TriggerClientEvent(
        'mt_lib:cb:res',
        src,
        id,
        result
    )
end)


-- =========================================================
-- EXPORT
-- =========================================================

exports(
    'registerCallback',
    mt.lib.registerCallback
)
