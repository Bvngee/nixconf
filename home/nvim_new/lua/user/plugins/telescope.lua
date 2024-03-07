return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'natecraddock/telescope-zf-native.nvim',
    'nvim-lua/plenary.nvim',
  },
  event = 'VeryLazy',
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local action_layout = require('telescope.actions.layout')
    local builtin = require('telescope.builtin')
    local extensions = require('telescope').extensions

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
        ['zf-native'] = {},
      },
    })

    telescope.load_extension('zf-native')

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({ hidden = true })
    end, opts)
    vim.keymap.set('n', '<leader>fg', builtin.git_files, opts)
    vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)
    vim.keymap.set('n', '<leader>lg', builtin.live_grep, opts)
    -- vim.keymap.set('n', '<leader>ss', extensions.persisted.persisted, opts)
  end,
}
