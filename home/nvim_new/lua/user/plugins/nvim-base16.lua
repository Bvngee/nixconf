return {
  'RRethy/base16-nvim',
  dependencies = {
    {
      'NvChad/nvim-colorizer.lua',
      opts = {
        filetypes = {
          '*',
          '!noice',
        },
        buftypes = {
          '!nofile',
        },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = false, -- "Name" codes like Blue or blue
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = false, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          mode = 'background', -- Set the display mode. foreground, background,  virtualtext
          virtualtext = '██', --■, , 
        },
      },
    },
  },
  lazy = false,
  priority = 1000,
  config = function()
    local base16 = require('base16-colorscheme')

    local config = {
      telescope = false,
      indentblankline = true,
      notify = true,
      ts_rainbow = false,
      cmp = true,
      illuminate = false,
    }

    local c = require('user.generated_base16_colors')

    base16.setup(c, config)

    --- Modifications and additions to nvim-base16's somewhat opinionated highlighting choices

    vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', { fg = c.base08, bg = nil })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', { fg = c.base09, bg = nil })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', { fg = c.base0A, bg = nil })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = c.base0B, bg = nil })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan', { fg = c.base0C, bg = nil })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = c.base0D, bg = nil })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = c.base0E, bg = nil })

    -- I can't figure out how to make the `:!` prompt not blue but eh, whatever
    -- vim.api.nvim_set_hl(0, 'NoiceCmdlinePrompt', { link = 'Normal' })
    -- vim.api.nvim_set_hl(0, 'NoiceCmdlinePopup', { link = 'Normal' })
    -- vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon', { link = 'Normal' })

    vim.api.nvim_set_hl(0, 'MiniCursorword', { bg = c.base01 })
    vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', { bg = c.base01 })

    -- vim.api.nvim_set_hl(0, 'VertSplit', { fg = colors.base01, bg = colors.base01 })

    vim.api.nvim_set_hl(0, 'LineNr', { fg = c.base03, bg = c.base00 })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = c.base04, bg = c.base00 })

    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = c.base01 })
    vim.api.nvim_set_hl(0, 'Float', { bg = c.base01 })

    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = c.base02, bg = c.base00 })

    -- https://github.com/RRethy/nvim-base16/blob/master/lua/base16-colorscheme.lua
    -- for more info. Most @___ like to TS___ (eg. @type links to TSType)
    vim.api.nvim_set_hl(0, '@lsp.type.namespace', { link = '@namespace' })
    vim.api.nvim_set_hl(0, '@lsp.type.type', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.class', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.enum', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.interface', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.struct', { link = '@structure' })
    vim.api.nvim_set_hl(0, '@lsp.type.parameter', { link = '@parameter' })
    vim.api.nvim_set_hl(0, '@lsp.type.variable', { link = '@variable' })
    vim.api.nvim_set_hl(0, '@lsp.type.property', { link = '@property' })
    vim.api.nvim_set_hl(0, '@lsp.type.enumMember', { link = '@constant' })
    vim.api.nvim_set_hl(0, '@lsp.type.function', { link = '@function' })
    vim.api.nvim_set_hl(0, '@lsp.type.method', { link = '@method' })
    vim.api.nvim_set_hl(0, '@lsp.type.macro', { link = '@macro' })
    vim.api.nvim_set_hl(0, '@lsp.type.decorator', { link = '@function' })

    -- this deviates from the base16 spec, but IMO looks better. See
    -- https://github.com/base16-project/base16/blob/main/styling.md
    -- for more info. Probably only works with limited base16 schemes.
    vim.api.nvim_set_hl(0, 'TSProperty', { fg = c.base0C }) --was base05
    vim.api.nvim_set_hl(0, 'Identifier', { fg = c.base05 }) --was base08
    vim.api.nvim_set_hl(0, 'TSVariable', { fg = c.base05 }) --was base08
    vim.api.nvim_set_hl(0, 'TSPunctDelimiter', { fg = c.base05 }) --was base0F
    --vim.api.nvim_set_hl(0, 'TSBoolean', { fg = colors.base0E }) --was base09
    vim.api.nvim_set_hl(0, 'SpecialChar', { fg = c.base0A }) --was base0F
  end,
}
