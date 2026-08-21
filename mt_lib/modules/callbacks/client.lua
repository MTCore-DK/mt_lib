mt.lib = mt.lib or {}

local pending = {}
local callbackId = 0


-- =========================================================
-- CALLBACK RESPONSE
-- =========================================================

RegisterNetEvent('mt_lib:cb:res', function(id, data)
    local callback = pending[id]

    if not callback then
        return
    end

    callback:resolve(data)

    pending[id] = nil
end)


-- =========================================================
-- GENERATE CALLBACK ID
-- =========================================================

local function generateCallbackId()
    callbackId = callbackId + 1

    if callbackId > 999999 then
        callbackId = 1
    end

    while pending[callbackId] do
        callbackId = callbackId + 1

        if callbackId > 999999 then
            callbackId = 1
        end
    end

    return callbackId
end


-- =========================================================
-- CLIENT CALLBACK
-- =========================================================

function mt.lib.callback(name, ...)
    if type(name) ~= 'string' then
        error('mt.lib.callback: callback name must be a string')
    end

    local id = generateCallbackId()

    local p = promise.new()

    pending[id] = p

    TriggerServerEvent(
        'mt_lib:cb:req',
        name,
        id,
        ...
    )

    local result = Citizen.Await(p)

    pending[id] = nil

    return result
end


-- =========================================================
-- EXPORT
-- =========================================================

exports('callback', mt.lib.callback)
