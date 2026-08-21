mt = mt or {}
mt.lib = mt.lib or {}

local targets = {}

local INTERACT_CONTROL = 38 -- E
local CHECK_DISTANCE = 3.0


-- =========================================================
-- ADD TARGET
-- =========================================================

function mt.lib.addTarget(entity, data)

    entity = tonumber(entity)

    if not entity then
        return false
    end

    if type(data) ~= 'table' then
        return false
    end

    if not data.onSelect then
        return false
    end

    targets[entity] = {
        onSelect = data.onSelect,

        canInteract = data.canInteract,

        distance = tonumber(data.distance)
            or CHECK_DISTANCE,

        label = data.label
            or 'Interact',

        groups = data.groups
    }

    return true
end


-- =========================================================
-- REMOVE TARGET
-- =========================================================

function mt.lib.removeTarget(entity)

    entity = tonumber(entity)

    if not entity then
        return false
    end

    if not targets[entity] then
        return false
    end

    targets[entity] = nil

    return true
end


-- =========================================================
-- GET TARGET
-- =========================================================

function mt.lib.getTarget(entity)

    entity = tonumber(entity)

    if not entity then
        return nil
    end

    return targets[entity]
end


-- =========================================================
-- GET ALL TARGETS
-- =========================================================

function mt.lib.getTargets()

    return targets
end


-- =========================================================
-- CHECK INTERACTION
-- =========================================================

local function canInteract(entity, target)

    if not DoesEntityExist(entity) then
        return false
    end

    if target.canInteract then

        local success, result =
            pcall(
                target.canInteract,
                entity
            )

        if not success or not result then
            return false
        end
    end

    return true
end


-- =========================================================
-- TARGET LOOP
-- =========================================================

CreateThread(function()

    while true do

        local sleep = 500

        local ped =
            PlayerPedId()

        local playerCoords =
            GetEntityCoords(ped)

        local aiming =
            IsPlayerFreeAiming(PlayerId())


        if aiming then

            sleep = 0

            local hit, entity =
                GetEntityPlayerIsFreeAimingAt(
                    PlayerId()
                )


            if hit and entity and entity ~= 0 then

                local target =
                    targets[entity]


                if target then

                    local entityCoords =
                        GetEntityCoords(entity)

                    local distance =
                        #(playerCoords - entityCoords)


                    if distance <= target.distance then

                        if canInteract(
                            entity,
                            target
                        ) then


                            -- Optional target UI
                            SendNUIMessage({
                                action = 'target',
                                visible = true,
                                label = target.label
                            })


                            if IsControlJustReleased(
                                0,
                                INTERACT_CONTROL
                            ) then

                                target.onSelect(
                                    entity
                                )

                                SendNUIMessage({
                                    action = 'target',
                                    visible = false
                                })

                                Wait(250)
                            end

                        else

                            SendNUIMessage({
                                action = 'target',
                                visible = false
                            })
                        end

                    else

                        SendNUIMessage({
                            action = 'target',
                            visible = false
                        })
                    end

                else

                    SendNUIMessage({
                        action = 'target',
                        visible = false
                    })
                end

            else

                SendNUIMessage({
                    action = 'target',
                    visible = false
                })
            end

        else

            SendNUIMessage({
                action = 'target',
                visible = false
            })
        end


        Wait(sleep)
    end
end)


-- =========================================================
-- CLEANUP
-- =========================================================

CreateThread(function()

    while true do

        for entity in pairs(targets) do

            if not DoesEntityExist(entity) then
                targets[entity] = nil
            end
        end

        Wait(5000)
    end
end)


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'addTarget',
    mt.lib.addTarget
)

exports(
    'removeTarget',
    mt.lib.removeTarget
)

exports(
    'getTarget',
    mt.lib.getTarget
)

exports(
    'getTargets',
    mt.lib.getTargets
)
