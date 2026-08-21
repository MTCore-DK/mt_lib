mt.lib = mt.lib or {}

function mt.lib.notify(data)
    if type(data) ~= 'table' then
        return
    end

    SendNUIMessage({
        action = 'notify',
        data = {
            title = data.title or 'Notification',
            description = data.description or data.message or '',
            type = data.type or 'info',
            duration = data.duration or 5000,
            icon = data.icon
        }
    })
end

exports('notify', mt.lib.notify)
