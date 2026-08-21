mt.lib = mt.lib or {}


-- =========================================================
-- SET GLOBAL STATE
-- =========================================================

function mt.lib.setState(key, value)

    if type(key) ~= 'string' then
        error(
            'mt.lib.setState: key must be a string'
        )
    end

    GlobalState[key] = value

    return true
end


-- =========================================================
-- GET GLOBAL STATE
-- =========================================================

function mt.lib.getState(key)

    if type(key) ~= 'string' then
        return nil
    end

    return GlobalState[key]
end


-- =========================================================
-- CHECK GLOBAL STATE
-- =========================================================

function mt.lib.hasState(key)

    if type(key) ~= 'string' then
        return false
    end

    return GlobalState[key] ~= nil
end


-- =========================================================
-- REMOVE GLOBAL STATE
-- =========================================================

function mt.lib.removeState(key)

    if type(key) ~= 'string' then
        return false
    end

    GlobalState[key] = nil

    return true
end


-- =========================================================
-- GET ALL STATE
-- =========================================================

function mt.lib.getAllState()

    local state = {}

    for key, value in pairs(GlobalState) do
        state[key] = value
    end

    return state
end


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'setState',
    mt.lib.setState
)

exports(
    'getState',
    mt.lib.getState
)

exports(
    'hasState',
    mt.lib.hasState
)

exports(
    'removeState',
    mt.lib.removeState
)

exports(
    'getAllState',
    mt.lib.getAllState
)
