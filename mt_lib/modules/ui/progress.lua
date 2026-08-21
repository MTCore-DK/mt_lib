mt.lib = mt.lib or {}

local progressActive = false


-- =========================================================
-- PROGRESS
-- =========================================================

function mt.lib.progress(data)

    if progressActive then
        return false
    end

    if type(data) ~= 'table' then
        data = {}
    end


    local duration =
        tonumber(data.duration) or 3000

    if duration < 0 then
        duration = 0
    end


    progressActive = true


    SendNUIMessage({
        action = 'progressCircle',

        label = data.label or 'Loading...',

        duration = duration,

        icon = data.icon or '⏳',

        color = data.color or 'primary'
    })


    Wait(duration)


    progressActive = false


    return true
end


-- =========================================================
-- CANCEL PROGRESS
-- =========================================================

function mt.lib.cancelProgress()

    if not progressActive then
        return false
    end


    progressActive = false


    SendNUIMessage({
        action = 'hideProgress'
    })


    return true
end


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'progress',
    mt.lib.progress
)

exports(
    'cancelProgress',
    mt.lib.cancelProgress
)
