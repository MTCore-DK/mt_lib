mt = mt or {}
mt.lib = mt.lib or {}

local zones = {}


-- =========================================================
-- ADD ZONE
-- =========================================================

function mt.lib.addZone(id, zone)

    if type(id) ~= 'string' then
        return false
    end

    if type(zone) ~= 'table' then
        return false
    end

    if not zone.coords then
        return false
    end

    if not zone.radius then
        return false
    end

    zones[id] = {
        id = id,

        coords = zone.coords,

        radius = tonumber(zone.radius) or 2.0,

        inside = false,

        onEnter = zone.onEnter,

        onExit = zone.onExit,

        onTick = zone.onTick
    }

    return true
end


-- =========================================================
-- REMOVE ZONE
-- =========================================================

function mt.lib.removeZone(id)

    if not zones[id] then
        return false
    end

    zones[id] = nil

    return true
end


-- =========================================================
-- GET ZONE
-- =========================================================

function mt.lib.getZone(id)

    return zones[id]
end


-- =========================================================
-- GET ALL ZONES
-- =========================================================

function mt.lib.getZones()

    return zones
end


-- =========================================================
-- CHECK IF PLAYER IS INSIDE
-- =========================================================

function mt.lib.isInsideZone(id)

    local zone = zones[id]

    if not zone then
        return false
    end

    return zone.inside == true
end


-- =========================================================
-- ZONE LOOP
-- =========================================================

CreateThread(function()

    while true do

        local sleep = 1000

        local ped =
            PlayerPedId()

        local coords =
            GetEntityCoords(ped)


        for _, zone in pairs(zones) do

            local distance =
                #(coords - zone.coords)


            -- Player is close enough to process zone
            if distance <= zone.radius then

                sleep = 250


                -- ENTER
                if not zone.inside then

                    zone.inside = true

                    if zone.onEnter then
                        zone.onEnter(
                            zone
                        )
                    end
                end


                -- TICK
                if zone.onTick then

                    zone.onTick(
                        zone,
                        distance
                    )
                end


            -- PLAYER LEFT
            elseif zone.inside then

                zone.inside = false

                if zone.onExit then
                    zone.onExit(
                        zone
                    )
                end
            end


            -- Nearby zone
            if distance <= zone.radius + 25.0 then
                sleep = math.min(
                    sleep,
                    500
                )
            end
        end


        Wait(sleep)
    end
end)


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'addZone',
    mt.lib.addZone
)

exports(
    'removeZone',
    mt.lib.removeZone
)

exports(
    'getZone',
    mt.lib.getZone
)

exports(
    'getZones',
    mt.lib.getZones
)

exports(
    'isInsideZone',
    mt.lib.isInsideZone
)
