return {
  -- This is way too invasive, has caused lots of errors, and is too experimental.
  -- I love the syntax highlighting on the cmdline and the fidget.nvim alternative, 
  -- but tbh that's it; I don't need all the other crap. I will instead switch to
  -- fidget.nvim and hope that smth like https://github.com/neovim/neovim/issues/26346
  -- gets merged soon!
  'folke/noice.nvim',
  enabled = false,


  -- event = 'VeryLazy',
  lazy = false,
  dependencies = 'MunifTanjim/nui.nvim',
  opts = {
    -- TODO: why are these routes not working?
    routes = {
      { -- redirect long messages to splits
        filter = {
          event = 'msg_show',
          min_height = 8,
        },
        view = 'split', -- view = 'popup',
      },
    },
    cmdline = {
      enabled = true,
      view = 'cmdline',
      format = {
        cmdline = {
          pattern = '^:',
          lang = 'vim',
          conceal = false,
          icon = false,
        },
        search_down = {
          kind = 'search',
          pattern = '^/',
          lang = 'regex',
          conceal = true,
          icon = '', -- 
        },
        search_up = {
          kind = 'search',
          pattern = '^%?',
          lang = 'regex',
          conceal = true,
          icon = '', -- 
        },
        filter = {
          pattern = '^:%s*!',
          lang = 'bash',
          conceal = false,
          icon = false,
        },
        lua = {
          pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
          lang = 'lua',
          conceal = false,
          icon = false,
        },
        help = {
          pattern = '^:%s*he?l?p?%s+',
          conceal = false,
          icon = false,
        },
        input = {}, -- Used by input()
      },
    },
    messages = {
      enabled = true,
    },
    popupmenu = {
      enabled = false,
    },
    lsp = {
      progress = {
        enabled = true,
        format = {
          -- {
          --   '{progress} ',
          --   key = 'progress.percentage',
          --   contents = {
          --     { '{data.progress.message} ' },
          --   },
          -- },
          '({data.progress.percentage}%) ',
          { '{spinner} ', hl_group = 'NoiceLspProgressSpinner' },
          { '{data.progress.title} ', hl_group = 'NoiceLspProgressTitle' },
          { '{data.progress.client} ', hl_group = 'NoiceLspProgressClient' },
        },
      },
      hover = {
        enabled = false,
        silent = false,
        border = {
          padding = { 0, 1 },
        },
      },
      signature = {
        enabled = false,
      },
      message = {
        enabled = true,
      },
      override = {
        -- override the default lsp markdown formatter with Noice
        ['vim.lsp.util.convert_input_to_markdown_lines'] = false,
        -- override the lsp markdown formatter with Noice
        ['vim.lsp.util.stylize_markdown'] = false,
        -- override cmp documentation with Noice (needs the other options to work)
        ['cmp.entry.get_documentation'] = false,
      },
    },
    notify = {
      enable = true,
      view = 'mini', -- nvim-notify?
    },
    presets = {
      -- bottom_search = true, -- use a classic bottom cmdline for search
      -- command_palette = true, -- position the cmdline and popupmenu together
      -- long_message_to_split = false, -- long messages will be sent to a split
      -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
      -- lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
}
