local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.load_extension('zf-native')
telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<ESC>"] = actions.close,
      },
    },
  }
}

