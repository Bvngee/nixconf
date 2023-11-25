require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'base16',
    component_separators = { left = '|', right = '|'}, --  
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 500,
      tabline = 500,
      winbar = 500,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
      'filename',
      -- { function() return vim.api.nvim_buf_get_name(0) .. ' ' .. require('nvim-navic').get_location() end },
    },
    lualine_x = {
      { 
        function() 
          local reg = vim.fn.reg_recording() 
          if reg ~= '' then reg = '@' .. reg end
          return reg
        end
      },
      '%S',
      'diff',
      { 'diagnostics', symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' } },
      'filetype',
    }, 
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}

