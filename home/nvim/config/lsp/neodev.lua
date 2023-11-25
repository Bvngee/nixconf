require('neodev').setup({
    override = function(root_dir, library)
        -- even though there might be non-neovim lua in dotfiles, best to turn on anyways
        local enable = root_dir:find("nvim", 1, true) ~= nil
            or root_dir:find("nixconf", 1, true) ~= nil

        if enable then
            library.enabled = true
            library.plugins = true
            library.types = true
            library.runtime = true -- is this one needed?
        end
    end,
})
