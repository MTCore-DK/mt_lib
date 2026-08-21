mt.lib = mt.lib or {}

local awaiting = nil


-- =========================================================
-- INPUT DIALOG
-- =========================================================

function mt.lib.inputDialog(title, fields)

    if awaiting then
        return nil
    end

    if type(title) ~= 'string' then
        title = 'Input'
    end

    if type(fields) ~= 'table' then
        fields = {}
    end


    local p = promise.new()

    awaiting = p


    SendNUIMessage({
        action = 'input',

        title = title,

        fields = fields
    })


    SetNuiFocus(
        true,
        true
    )


    local result =
        Citizen.Await(p)


    awaiting = nil


    return result
end


-- =========================================================
-- INPUT SUBMIT
-- =========================================================

RegisterNUICallback(
    'inputSubmit',
    function(data, cb)

        if awaiting then

            awaiting:resolve(
                data
            )

            awaiting = nil
        end


        SetNuiFocus(
            false,
            false
        )


        cb('ok')
    end
)


-- =========================================================
-- INPUT CANCEL
-- =========================================================

RegisterNUICallback(
    'inputCancel',
    function(data, cb)

        if awaiting then

            awaiting:resolve(
                nil
            )

            awaiting = nil
        end


        SetNuiFocus(
            false,
            false
        )


        cb('ok')
    end
)


-- =========================================================
-- EXPORT
-- =========================================================

exports(
    'inputDialog',
    mt.lib.inputDialog
)
