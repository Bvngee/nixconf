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
            -- gonna try to force myself to use C-c (or C-esc if thats easier)
            -- ['<Esc>'] = actions.close,
            ['<C-c>'] = actions.close,
            ['<C-Esc>'] = actions.close, 
            -- ['<C-Esc>'] = { '<Esc>', type = 'command' }, -- normal mode

            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,

            -- C-u/C-d are used for preview buffer scrolling :/
            -- ['<C-u>'] = function(prompt_bufnr)
            --   for _ = 1, 10, 1 do
            --     actions.move_selection_previous(prompt_bufnr)
            --   end
            -- end,
            -- ['<C-d>'] = function(prompt_bufnr)
            --   for _ = 1, 10, 1 do
            --     actions.move_selection_next(prompt_bufnr)
            --   end
            -- end,

            ['<C-Down>'] = actions.cycle_history_next,
            ['<C-Up>'] = actions.cycle_history_prev,

            ['<C-q>'] = actions.smart_send_to_qflist,
            ['<C-l>'] = actions.smart_send_to_loclist,
            ['<C-t>'] = trouble_tele.open_with_trouble,

            ['<c-f>'] = actions.to_fuzzy_refine,

            ['<C-Space>'] = actions.toggle_selection,
            ['<Tab>'] = actions.toggle_selection + actions.move_selection_next,
            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_previous,
          },
          n = {
            ['<Esc>'] = actions.close,
            ['<C-c>'] = actions.close,
            ['<C-Esc>'] = actions.close, 

            ['<C-Down>'] = actions.cycle_history_next,
            ['<C-Up>'] = actions.cycle_history_prev,

            ['<C-q>'] = actions.smart_send_to_qflist,
            ['<C-l>'] = actions.smart_send_to_loclist,
            ['<C-t>'] = trouble_tele.open_with_trouble,

            ['<c-f>'] = actions.to_fuzzy_refine,

            ['<C-Space>'] = actions.toggle_selection,
            ['<Tab>'] = actions.toggle_selection + actions.move_selection_next,
            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_previous,
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
        
        -- both live_grep and lsp_dynamic_workspace_symbols override C-space
        -- with to_fuzzy_refine which I use C-f for. See
        -- https://github.com/nvim-telescope/telescope.nvim/blob/5972437de807c3bc101565175da66a1aa4f8707a/lua/telescope/builtin/__lsp.lua#L455
        live_grep = {
          mappings = {
            i = {
              ['<C-Space>'] = actions.toggle_selection,
            },
          },
        },
        lsp_dynamic_workspace_symbols = {
          mappings = {
            i = {
              ['<C-Space>'] = actions.toggle_selection,
            },
          },
        },
      },
      extensions = {
        ['zf-native'] = {},
        ['session-lens'] = {},
        -- persisted = {
        --   layout_config = { width = 0.55, height = 0.55 },
        -- },
      },
    })

    telescope.load_extension('zf-native')
    telescope.load_extension('session-lens')
    -- telescope.load_extension('persisted')

    local function map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { remap = false, silent = true })
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
    map('n', '<leader>sH', builtin.highlights)
    map('n', '<leader>sk', builtin.keymaps)
    map('n', '<leader>st', builtin.builtin)
    map('n', '<leader>sd', builtin.diagnostics)
    map('n', '<leader>sr', builtin.resume)

    map('n', '<leader>s/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        previewer = false,
      }))
    end)
    -- map('n', '<leader>ss', extensions.persisted.persisted, opts)
  end,
}
