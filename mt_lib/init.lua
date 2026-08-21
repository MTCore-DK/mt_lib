mt.lib = {}

local function log(message)
    print(('[mt_lib] %s'):format(message))
end

if mt.config.txAdminClean then
    log('Loaded with txAdmin cleanup enabled')
else
    log('Loaded')
end

mt.lib.initialized = true
