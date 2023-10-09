require('neodev').setup({
    override = function(root_dir, library)
        if root_dir:find("nixconf", 1, true) == 1 then
            library.enabled = true;
            library.plugins = true;
        end
    end,
})
