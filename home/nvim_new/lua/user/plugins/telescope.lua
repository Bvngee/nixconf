return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'natecraddock/telescope-zf-native.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', --requires a NF
  },
  event = 'VeryLazy',
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local action_layout = require('telescope.actions.layout')
    local action_state = require('telescope.actions.layout')
    local builtin = require('telescope.builtin')
    local extensions = require('telescope').extensions
    local trouble_tele = require('trouble.providers.telescope')

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ['<Esc>'] = actions.close,
            ['<C-c>'] = actions.close,
            ['<C-Esc>'] = { '<Esc>', type = "command" }, -- normal mode

            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,

            ['<C-q>'] = actions.smart_send_to_qflist,
            ['<C-l>'] = actions.smart_send_to_loclist,
            ['<C-t>'] = trouble_tele.open_with_trouble,

            ['<Tab>'] = actions.toggle_selection,
            ['<S-Tab>'] = false,
          },
          n = {
            ['<Esc>'] = actions.close,
            ['<C-c>'] = actions.close,

            ['<C-u>'] = { "10k", type = "command" },
            ['<C-d>'] = { "10j", type = "command" },

            ['<C-q>'] = actions.smart_send_to_qflist,
            ['<C-l>'] = actions.smart_send_to_loclist,
            ['<C-t>'] = trouble_tele.open_with_trouble,

            [' '] = actions.toggle_selection,
            ['<Tab>'] = actions.toggle_selection,
            ['<S-Tab>'] = false,
          },
        },
        multi_icon = '',
      },
      pickers = {
        buffers = {
          show_all_buffers = true,
          sort_lastused = true,
          theme = 'dropdown',
          previewer = false,
          mappings = {
            i = {
              ['<C-d>'] = actions.delete_buffer,
            },
            n = {
              ['dd'] = actions.delete_buffer,
            },
          },
        },
      },
      extensions = {
        ['zf-native'] = {},
      },
    })

    telescope.load_extension('zf-native')

    local function map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
    end

    map('n', '<leader>sF', function()
      builtin.find_files({ hidden = true })
    end)
    map('n', '<leader>sf', builtin.find_files)
    map('n', '<leader>sG', builtin.git_files)
    map('n', '<leader>sg', builtin.live_grep)
    map('n', '<leader>sw', builtin.grep_string)
    map('n', '<leader>sb', builtin.buffers)
    map('n', '<leader>sh', builtin.help_tags)
    map('n', '<leader>sk', builtin.keymaps)
    map('n', '<leader>st', builtin.builtin)
    map('n', '<leader>sd', builtin.diagnostics)

    map('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        previewer = false,
      }))
    end)
    -- vim.keymap.set('n', '<leader>ss', extensions.persisted.persisted, opts)
  end,
}
