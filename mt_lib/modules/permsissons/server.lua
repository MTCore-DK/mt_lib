mt.lib = mt.lib or {}


-- =========================================================
-- CHECK ACE PERMISSION
-- =========================================================

function mt.lib.hasPermission(src, permission)

    src = tonumber(src)

    if not src then
        return false
    end

    if type(permission) ~= 'string' then
        return false
    end

    return IsPlayerAceAllowed(
        src,
        permission
    )
end


-- =========================================================
-- CHECK ANY PERMISSION
-- =========================================================

function mt.lib.hasAnyPermission(src, permissions)

    if type(permissions) ~= 'table' then
        return false
    end

    for _, permission in ipairs(permissions) do

        if mt.lib.hasPermission(
            src,
            permission
        ) then
            return true
        end
    end

    return false
end


-- =========================================================
-- CHECK ALL PERMISSIONS
-- =========================================================

function mt.lib.hasAllPermissions(src, permissions)

    if type(permissions) ~= 'table' then
        return false
    end

    for _, permission in ipairs(permissions) do

        if not mt.lib.hasPermission(
            src,
            permission
        ) then
            return false
        end
    end

    return true
end


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'hasPermission',
    mt.lib.hasPermission
)

exports(
    'hasAnyPermission',
    mt.lib.hasAnyPermission
)

exports(
    'hasAllPermissions',
    mt.lib.hasAllPermissions
)
