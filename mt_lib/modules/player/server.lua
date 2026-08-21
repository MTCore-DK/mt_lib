mt.lib = mt.lib or {}


-- =========================================================
-- GET PLAYER
-- =========================================================

function mt.lib.getPlayer(src)

    src = tonumber(src)

    if not src or src <= 0 then
        return nil
    end

    if not GetPlayerName(src) then
        return nil
    end


    return {
        id = src,

        name = GetPlayerName(src),

        identifiers = GetPlayerIdentifiers(src)
    }
end


-- =========================================================
-- GET PLAYER NAME
-- =========================================================

function mt.lib.getPlayerName(src)

    src = tonumber(src)

    if not src then
        return nil
    end

    return GetPlayerName(src)
end


-- =========================================================
-- GET PLAYER IDENTIFIERS
-- =========================================================

function mt.lib.getIdentifiers(src)

    src = tonumber(src)

    if not src then
        return {}
    end

    return GetPlayerIdentifiers(src)
end


-- =========================================================
-- GET SPECIFIC IDENTIFIER
-- =========================================================

function mt.lib.getIdentifier(src, identifierType)

    src = tonumber(src)

    if not src or not identifierType then
        return nil
    end


    local identifiers =
        GetPlayerIdentifiers(src)


    local prefix =
        identifierType .. ':'


    for _, identifier in ipairs(identifiers) do

        if identifier:sub(
            1,
            #prefix
        ) == prefix then

            return identifier
        end
    end


    return nil
end


-- =========================================================
-- IS PLAYER ONLINE
-- =========================================================

function mt.lib.isPlayerOnline(src)

    src = tonumber(src)

    if not src then
        return false
    end

    return GetPlayerName(src) ~= nil
end


-- =========================================================
-- GET ALL PLAYERS
-- =========================================================

function mt.lib.getPlayers()

    local players = {}

    for _, playerId in ipairs(
        GetPlayers()
    ) do

        local src =
            tonumber(playerId)

        players[#players + 1] =
            mt.lib.getPlayer(src)
    end

    return players
end


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'getPlayer',
    mt.lib.getPlayer
)

exports(
    'getPlayerName',
    mt.lib.getPlayerName
)

exports(
    'getIdentifiers',
    mt.lib.getIdentifiers
)

exports(
    'getIdentifier',
    mt.lib.getIdentifier
)

exports(
    'isPlayerOnline',
    mt.lib.isPlayerOnline
)

exports(
    'getPlayers',
    mt.lib.getPlayers
)
