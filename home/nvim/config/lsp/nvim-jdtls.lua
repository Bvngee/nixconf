local jdtls = require('jdtls')

local home = os.getenv('HOME')
local root_markers = {'gradlew', 'mvnw', '.git'}
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir ~= nil then -- bruh again
    local workspace_folder = home .. "/.local/share/eclipse/" .. root_dir
end

local config = {
    cmd = { 
        'jdt-language-server',

        -- 💀
        --'-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
                        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                        -- Must point to the                      Change to one of `linux`, `win` or `mac`
                        -- eclipse.jdt.ls installation            Depending on your system.


        -- 💀
        -- See `data directory configuration` section in the README
        '-data', '/path/to/unique/per/project/workspace/folder' 
    },
    root_dir = root_dir,
}

-- jdtls.start_or_attach(config) -- this shit keeps running and failing every single time I open a file. Bruh.
