#!/usr/bin/env tarantool

require('strict').on()

if package.setsearchroot ~= nil then
    package.setsearchroot()
end

local cartridge = require('cartridge')

local ok, err = cartridge.cfg({
    roles = {
        'cartridge.roles.vshard-storage',
        'cartridge.roles.vshard-router',
        'cartridge.roles.crud-storage',
        'cartridge.roles.crud-router',
        'cartridge.roles.metrics',
        'migrator',
        'app.roles.api',
        'app.roles.storage',
    },
})

assert(ok, tostring(err))
