return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  opts = {
    input = { },
    select = {
      -- Set to false to disable the vim.ui.select implementation
      enabled = true,

      -- Priority list of preferred vim.select implementations
      -- backend = { 'telescope', 'fzf_lua', 'fzf', 'builtin', 'nui' },
      backend = { 'telescope', 'builtin' },

      -- Options for telescope selector
      -- These are passed into the telescope picker directly. Can be used like:
      -- telescope = require('telescope.themes').get_ivy({...})
      telescope = nil,

      -- Options for builtin selector
      builtin = { },
    },
  },
}
