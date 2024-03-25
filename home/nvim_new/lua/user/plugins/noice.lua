return {
  'folke/noice.nvim',
  -- event = 'VeryLazy',
  lazy = false,
  dependencies = 'MunifTanjim/nui.nvim',
  opts = {
    -- TODO: why are these routes not working?
    routes = {
      { -- redirect long messages to splits
        filter = {
          event = 'notify',
          min_height = 15,
        },
        view = 'split',
      },
      { -- disable search virtual text
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
    },
    cmdline = {
      enabled = true,
      view = 'cmdline',
      format = {
        cmdline = false,
        search_down = false,
        search_up = false,
        filter = false,
        lua = false,
        help = false,
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
