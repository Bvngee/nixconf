return {
  {
    'echasnovski/mini.comment',
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false },
      },
    },
    event = 'VeryLazy',
    opts = {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring()
            or vim.bo.commentstring
        end,
      },
    },
  },

  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
        },
      }
    end,
  },

  {
    'echasnovski/mini.surround',
    event = 'VeryLazy',
    opts = {
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`
      },
      silent = false,
    },
  },

  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- stylua: ignore
      -- the neigh_pattern format is two regexp's, for neighboring chars.
      -- I.e. '..' is any|any, '.[^\\]' is any|not-backslash
      -- https://www.lua.org/manual/5.1/manual.html#5.4.1
      mappings = {
        ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][^%a]' }, -- dont activate after a '\'
        ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][^%a]' }, -- or before any char
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][^%a]' },

        [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
        [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
        ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

        -- ['<'] = { action = 'open',  pair = '<>', neigh_pattern = '[^\\].' }, -- Do I want these?
        -- ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' }, -- probably not

        -- At the moment, this doesn't allow autopairing ' or " before or after itself. Maybe change in the future
        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^%a\\\"][^%a\"]', register = { cr = false } },
        ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\\'][^%a\']', register = { cr = false } },
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\`][^%a`]',     register = { cr = false } },
      },
    },
  },

  {
    'echasnovski/mini.files',
    opts = function()
      local files = require('mini.files')
      vim.keymap.set('n', '<leader>fb', files.open)
      return {
        content = {
          filter = nil, -- Predicate for which file system entries to show
          prefix = nil, -- What prefix to show to the left of file system entry
          sort = nil, -- In which order to show file system entries
        },
        mappings = {
          close = 'q',
          go_in = 'l',
          go_in_plus = 'L',
          go_out = 'h',
          go_out_plus = 'H',
          reset = '<BS>',
          reveal_cwd = '@',
          show_help = 'g?',
          synchronize = 's',
          trim_left = '<',
          trim_right = '>',
        },
        options = {
          permanent_delete = true,
          use_as_default_explorer = true,
        },
        windows = {
          -- max_number = math.huge,
          max_number = 1,
          preview = false,
          width_focus = 40,
          width_nofocus = 20,
          width_preview = 25,
        },
      }
    end,
  },

  {
    'echasnovski/mini.cursorword',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    opts = {},
  },

  {
    'echasnovski/mini.move',
    event = 'VeryLazy',
    opts = {
      -- If I ever remove this plugin, I can mess around with these again:
      -- -- move lines up/down
      -- map('v', '<A-j>', ":m '>+1<cr>gv=gv")
      -- map('v', '<A-k>', ":m '<-2<cr>gv=gv")
      --
      -- -- move lines left/right
      -- map('v', '<A-h>', '<gv')
      -- map('v', '<A-l>', '>gv')
      -- map('v', '<', '<gv')
      -- map('v', '>', '>gv')
      mappings = {
        -- Move visual selection in Visual mode.
        left = '<A-h>',
        right = '<A-l>',
        down = '<A-j>',
        up = '<A-k>',

        -- Aove current line in Normal mode
        line_left = '<A-h>',
        line_right = '<A-l>',
        line_down = '<A-j>',
        line_up = '<A-k>',
      },
    },
  },
}
