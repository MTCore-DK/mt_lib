mt = mt or {}
mt.lib = mt.lib or {}

-- =========================================================
-- LOCALE
-- =========================================================

local function loadLocale(locale)

    local resource =
        GetCurrentResourceName()

    local path =
        ('locales/%s.json'):format(locale)

    local file =
        LoadResourceFile(
            resource,
            path
        )

    if not file then
        return nil
    end

    local success, data =
        pcall(
            json.decode,
            file
        )

    if not success or type(data) ~= 'table' then
        return nil
    end

    return data
end


-- =========================================================
-- LOAD CONFIGURED LOCALE
-- =========================================================

local localeName =
    mt.config.locale or 'en'

mt.locale =
    loadLocale(localeName)


-- =========================================================
-- FALLBACK TO ENGLISH
-- =========================================================

if not mt.locale then

    print(
        ('^3[mt_lib] Locale "%s" not found, falling back to English.^0')
        :format(localeName)
    )

    mt.locale =
        loadLocale('en')
end


-- Prevent nil locale
mt.locale =
    mt.locale or {}


-- =========================================================
-- TRANSLATION
-- =========================================================

function mt.lib.t(key, ...)

    if type(key) ~= 'string' then
        return ''
    end

    local value =
        mt.locale[key]


    -- Fallback to key
    if value == nil then
        value = key
    end


    -- Optional formatting
    if select('#', ...) > 0 then

        local success, result =
            pcall(
                string.format,
                value,
                ...
            )

        if success then
            return result
        end
    end


    return value
end


-- =========================================================
-- CHECK TRANSLATION
-- =========================================================

function mt.lib.hasLocale(key)

    if type(key) ~= 'string' then
        return false
    end

    return mt.locale[key] ~= nil
end


-- =========================================================
-- GET CURRENT LOCALE
-- =========================================================

function mt.lib.getLocale()

    return localeName
end


-- =========================================================
-- GET ALL TRANSLATIONS
-- =========================================================

function mt.lib.getLocales()

    return mt.locale
end


-- =========================================================
-- EXPORTS
-- =========================================================

exports(
    't',
    mt.lib.t
)

exports(
    'hasLocale',
    mt.lib.hasLocale
)

exports(
    'getLocale',
    mt.lib.getLocale
)

exports(
    'getLocales',
    mt.lib.getLocales
)
