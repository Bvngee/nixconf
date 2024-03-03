return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'natecraddock/telescope-zf-native.nvim',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local action_layout = require('telescope.actions.layout')

    telescope.load_extension('zf-native')

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ['<Esc>'] = actions.close,
            -- ["<C-p>"] = action_layout.toggle_preview,
          },
          n = {
            ['<Esc>'] = actions.close,
          },
        },
      },
      extensions = {
        ['zf-native'] = {}
      },
    })
  end,
}
