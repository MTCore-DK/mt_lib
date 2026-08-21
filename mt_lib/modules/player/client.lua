mt.lib = mt.lib or {}


-- =========================================================
-- GET PLAYER PED
-- =========================================================

function mt.lib.getPed()
    return PlayerPedId()
end


-- =========================================================
-- GET PLAYER ID
-- =========================================================

function mt.lib.getPlayerId()
    return PlayerId()
end


-- =========================================================
-- GET SERVER ID
-- =========================================================

function mt.lib.getServerId()
    return GetPlayerServerId(
        PlayerId()
    )
end


-- =========================================================
-- GET PLAYER NAME
-- =========================================================

function mt.lib.getPlayerName()
    return GetPlayerName(
        PlayerId()
    )
end


-- =========================================================
-- GET PLAYER COORDINATES
-- =========================================================

function mt.lib.getCoords(entity)
    entity = entity or PlayerPedId()

    if not DoesEntityExist(entity) then
        return nil
    end

    return GetEntityCoords(entity)
end


-- =========================================================
-- GET PLAYER HEADING
-- =========================================================

function mt.lib.getHeading(entity)
    entity = entity or PlayerPedId()

    if not DoesEntityExist(entity) then
        return nil
    end

    return GetEntityHeading(entity)
end


-- =========================================================
-- GET PLAYER VEHICLE
-- =========================================================

function mt.lib.getVehicle()
    local ped = PlayerPedId()

    if not IsPedInAnyVehicle(ped, false) then
        return 0
    end

    return GetVehiclePedIsIn(
        ped,
        false
    )
end


-- =========================================================
-- IS PLAYER IN VEHICLE
-- =========================================================

function mt.lib.isInVehicle()
    return IsPedInAnyVehicle(
        PlayerPedId(),
        false
    )
end


-- =========================================================
-- GET PLAYER HEALTH
-- =========================================================

function mt.lib.getHealth()
    return GetEntityHealth(
        PlayerPedId()
    )
end


-- =========================================================
-- GET PLAYER ARMOUR
-- =========================================================

function mt.lib.getArmour()
    return GetPedArmour(
        PlayerPedId()
    )
end


-- =========================================================
-- GET PLAYER WEAPON
-- =========================================================

function mt.lib.getCurrentWeapon()
    local ped = PlayerPedId()

    local weapon = GetSelectedPedWeapon(
        ped
    )

    return weapon
end


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'getPed',
    mt.lib.getPed
)

exports(
    'getPlayerId',
    mt.lib.getPlayerId
)

exports(
    'getServerId',
    mt.lib.getServerId
)

exports(
    'getPlayerName',
    mt.lib.getPlayerName
)

exports(
    'getCoords',
    mt.lib.getCoords
)

exports(
    'getHeading',
    mt.lib.getHeading
)

exports(
    'getVehicle',
    mt.lib.getVehicle
)

exports(
    'isInVehicle',
    mt.lib.isInVehicle
)

exports(
    'getHealth',
    mt.lib.getHealth
)

exports(
    'getArmour',
    mt.lib.getArmour
)

exports(
    'getCurrentWeapon',
    mt.lib.getCurrentWeapon
)
