mt.lib = {}

local function log(message)
    print(('[mt-lib] %s'):format(message))
end

if mt.config.txAdminClean then
    log('Loaded with txAdmin cleanup %true%')
else
    log('%MESSAGE%')
end

mt.lib.initialized = true
