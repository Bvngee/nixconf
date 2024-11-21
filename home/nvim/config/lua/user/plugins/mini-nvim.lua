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

  -- Note:
  -- e textobject is snake_case / camelCase
  -- counts are supported, so smth like "c2inq" does "change in 2 next "
  -- b textobject is an alias for }]) aka "brackets"
  -- q textobject is an alias for "'`
  -- u/U is inside function call (arguments), aka "usage"
  -- with mini.comment, there is also a gc textobject for comments (no a/i support)
  {
    'echasnovski/mini.ai',
    -- for ai.gen_spec.treesitter() to work, the treesitter queries for things
    -- like @block or @function need to be added for each lanuage. These are not
    -- provided by default, so we'll use nvim-treesitter-textobjects's collection
    -- of queries. note: it also has an alternative method of textobject creation,
    -- but we will use mini.ai's instead.
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500, -- does this become a performance problem? its nice for tags
        search_method = 'cover_or_next', -- first search for covering ranges, then next ones
        mappings = {
          around = 'a',
          inside = 'i',

          around_next = 'an',
          inside_next = 'in',
          around_last = 'al',
          inside_last = 'il',

          goto_left = 'g[',
          goto_right = 'g]',
        },
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          d = { '%f[%d]%d+' }, -- digits
          e = { -- snake_case_words, camelCaseWords, in lower and upper case
            {
              '%u[%l%d]+%f[^%l%d]',
              '%f[%S][%a%d]+%f[^%a%d]',
              '%f[%P][%a%d]+%f[^%a%d]',
              '^[%a%d]+%f[^%a%d]',
            },
            '^().*()$',
          },
          -- i = LazyVim.mini.ai_indent, -- indent -- requires mini.indent
          g = function() -- Whole buffer
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line('$'),
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name

          -- By default, closing and opening bracket types differ, where closing bracket includes whitespace
          -- in the textobject and opening doesn't. I hate that, I wan't them to behave the same and always
          -- include whitespace.
          ['('] = { '%b()', '^.().*().$' },
          [')'] = { '%b()', '^.().*().$' },
          ['['] = { '%b[]', '^.().*().$' },
          [']'] = { '%b[]', '^.().*().$' },
          ['{'] = { '%b{}', '^.().*().$' },
          ['}'] = { '%b{}', '^.().*().$' },
          ['<'] = { '%b<>', '^.().*().$' },
          ['>'] = { '%b<>', '^.().*().$' },
        },
      }
    end,
  },

  {
    'echasnovski/mini.surround',
    event = 'VeryLazy',
    opts = {
      n_lines = 100,
      search_method = 'cover_or_next', -- do I want this (as opposed to default of 'cover')?
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update the value of `n_lines`
        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
      custom_surroundings = {
        -- Similarly to with mini.ai, I hate how '(' and ')' differ with
        -- inclusion of whitespace, it's too much for my tiny brain to think
        -- about. Now both exclude whitespace. I can always `sai( `.
        -- https://github.com/echasnovski/mini.surround/blob/48a9795c9d352c771e1ab5dedab6063c0a2df037/lua/mini/surround.lua#L1079-L1086
        ['('] = { input = { '%b()', '^.().*().$' }, output = { left = '(', right = ')' } },
        [')'] = { input = { '%b()', '^.().*().$' }, output = { left = '(', right = ')' } },
        ['['] = { input = { '%b[]', '^.().*().$' }, output = { left = '[', right = ']' } },
        [']'] = { input = { '%b[]', '^.().*().$' }, output = { left = '[', right = ']' } },
        ['{'] = { input = { '%b{}', '^.().*().$' }, output = { left = '{', right = '}' } },
        ['}'] = { input = { '%b{}', '^.().*().$' }, output = { left = '{', right = '}' } },
        ['<'] = { input = { '%b<>', '^.().*().$' }, output = { left = '<', right = '>' } },
        ['>'] = { input = { '%b<>', '^.().*().$' }, output = { left = '<', right = '>' } },
      },
    },
  },

  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- stylua: ignore start
      -- the neigh_pattern format is two regexp's, for neighboring chars.
      -- I.e. '..' is any|any, '.[^\\]' is any|not-backslash
      -- https://www.lua.org/manual/5.1/manual.html#5.4.1
      mappings = {
        -- Skip open autopairing after a backslash and before almost anything
        ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][^%w%%%\'%"%.%`%$%\\]' },
        ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][^%w%%%\'%"%.%`%$%\\]' },
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][^%w%%%\'%"%.%`%$%\\]' },
        -- Only skip closing after a backslash
        [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
        [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
        ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
        -- Skip autopairing quotes after themselves and before almost anything
        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^%w\\"][^%w%%%\'%"%.%`%$%\\]', register = { cr = false } },
        ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%w\\\'][^%w%%%\'%"%.%`%$%\\]', register = { cr = false } },
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\`][^%w%%%\'%"%.%`%$%\\]',     register = { cr = false } },
      },
      -- stylua: ignore end
    },
    config = function(_, opts)
      -- Stolen shamelessly from Folke in LazyVim. See
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/mini.lua
      local pairs = require('mini.pairs')
      pairs.setup(opts)
      local open = pairs.open
      ---@diagnostic disable-next-line: duplicate-set-field
      pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= '' then
          return open(pair, neigh_pattern)
        end
        local o, c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])

        -- In Markdown files, use special handling for ``` (multiline code blocks)
        if vim.bo.filetype == 'markdown' and o == '`' and before:match('^%s*``') then
          return '`\n```' .. vim.api.nvim_replace_termcodes('<up>', true, true, true)
        end

        -- If inside a "string" treesitter node, don't do any autopairing
        local ok, captures =
          pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
        for _, capture in ipairs(ok and captures or {}) do
          if vim.tbl_contains({ 'string' }, capture.capture) then
            return o
          end
        end

        -- If the next character is the closing char AND there's more closings than openings
        -- on this line, skip autopairing (only if opening and closing chars are different)
        if next == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), '')
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), '')
          if count_close > count_open then
            return o
          end
        end

        -- Use original mini.pairs open() method
        return open(pair, neigh_pattern)
      end
    end,
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

        -- Move current line in Normal mode
        line_left = '<A-h>',
        line_right = '<A-l>',
        line_down = '<A-j>',
        line_up = '<A-k>',
      },
    },
  },
}
