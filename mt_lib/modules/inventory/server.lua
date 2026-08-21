mt = mt or {}
mt.lib = mt.lib or {}

-- =========================================================
-- ADD ITEM
-- =========================================================

function mt.lib.addItem(src, item, amount)

    src = tonumber(src)
    amount = tonumber(amount) or 1

    if not src then
        return false
    end

    if type(item) ~= 'string' or item == '' then
        return false
    end

    if amount <= 0 then
        return false
    end


    -- =====================================================
    -- ESX
    -- =====================================================

    if mt.framework.name == 'esx' then

        local ESX = mt.framework.core

        if not ESX then
            return false
        end

        local player =
            ESX.GetPlayerFromId(src)

        if not player then
            return false
        end

        player.addInventoryItem(
            item,
            amount
        )

        return true
    end


    -- =====================================================
    -- QBCORE
    -- =====================================================

    if mt.framework.name == 'qb' then

        local QBCore = mt.framework.core

        if not QBCore then
            return false
        end

        local player =
            QBCore.Functions.GetPlayer(src)

        if not player then
            return false
        end

        local success =
            player.Functions.AddItem(
                item,
                amount
            )

        return success ~= false
    end


    -- =====================================================
    -- vRP
    -- =====================================================

    if mt.framework.name == 'vrp' then

        -- vRP implementations differ between versions.
        -- Add your vRP inventory bridge here.

        return false
    end


    -- =====================================================
    -- STANDALONE
    -- =====================================================

    if mt.framework.name == 'standalone' then

        -- Standalone has no inventory system by default.

        return false
    end


    return false
end


-- =========================================================
-- REMOVE ITEM
-- =========================================================

function mt.lib.removeItem(src, item, amount)

    src = tonumber(src)
    amount = tonumber(amount) or 1

    if not src then
        return false
    end

    if type(item) ~= 'string' or item == '' then
        return false
    end

    if amount <= 0 then
        return false
    end


    -- ESX
    if mt.framework.name == 'esx' then

        local ESX = mt.framework.core

        if not ESX then
            return false
        end

        local player =
            ESX.GetPlayerFromId(src)

        if not player then
            return false
        end

        player.removeInventoryItem(
            item,
            amount
        )

        return true
    end


    -- QBCore
    if mt.framework.name == 'qb' then

        local QBCore = mt.framework.core

        if not QBCore then
            return false
        end

        local player =
            QBCore.Functions.GetPlayer(src)

        if not player then
            return false
        end

        local success =
            player.Functions.RemoveItem(
                item,
                amount
            )

        return success ~= false
    end


    -- vRP
    if mt.framework.name == 'vrp' then
        return false
    end


    -- Standalone
    if mt.framework.name == 'standalone' then
        return false
    end


    return false
end


-- =========================================================
-- GET ITEM
-- =========================================================

function mt.lib.getItem(src, item)

    src = tonumber(src)

    if not src then
        return nil
    end

    if type(item) ~= 'string' or item == '' then
        return nil
    end


    -- ESX
    if mt.framework.name == 'esx' then

        local ESX = mt.framework.core

        if not ESX then
            return nil
        end

        local player =
            ESX.GetPlayerFromId(src)

        if not player then
            return nil
        end

        return player.getInventoryItem(item)
    end


    -- QBCore
    if mt.framework.name == 'qb' then

        local QBCore = mt.framework.core

        if not QBCore then
            return nil
        end

        local player =
            QBCore.Functions.GetPlayer(src)

        if not player then
            return nil
        end

        return player.Functions.GetItemByName(item)
    end


    return nil
end


-- =========================================================
-- GET ITEM COUNT
-- =========================================================

function mt.lib.getItemCount(src, item)

    local data =
        mt.lib.getItem(src, item)

    if not data then
        return 0
    end

    return tonumber(
        data.count or
        data.amount or
        0
    ) or 0
end


-- =========================================================
-- HAS ITEM
-- =========================================================

function mt.lib.hasItem(src, item, amount)

    amount = tonumber(amount) or 1

    return mt.lib.getItemCount(
        src,
        item
    ) >= amount
end


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    'addItem',
    mt.lib.addItem
)

exports(
    'removeItem',
    mt.lib.removeItem
)

exports(
    'getItem',
    mt.lib.getItem
)

exports(
    'getItemCount',
    mt.lib.getItemCount
)

exports(
    'hasItem',
    mt.lib.hasItem
)
