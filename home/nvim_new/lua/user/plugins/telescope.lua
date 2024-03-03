return {
	"nvim-telescope/telescope.nvim",
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local action_layout = require("telescope.actions.layout")

		telescope.load_extension("zf-native")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<Esc>"] = actions.close,
            ["<A-p>"] = action_layout.toggle_preview,
					},
					n = {

          },
				},
			},
			extensions = {},
		})
	end,
}
