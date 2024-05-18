return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'RRethy/base16-nvim',
  },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'base16',
      component_separators = { left = '|', right = '|' }, --  
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      --globalstatus = true,
      refresh = {
        statusline = 500,
        tabline = 500,
        winbar = 500,
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = {
        {
          'filename',
          file_status = true,
          path = 1,
          shorting_target = 25,
          symbols = {
            modified = '+',
            readonly = '!',
            unnamed = '[No Name]',
          },
          separator = {
            right = '',
          },
        },
        -- {
        --   'filetype',
        --   icon_only = true,
        --   icon = { align = 'left' },
        --   padding = 0,
        -- },
      },
      lualine_x = {
        {
          function()
            local reg = vim.fn.reg_recording()
            if reg ~= '' then
              reg = '@' .. reg
            end
            return reg
          end,
        },
        '%S',
        {
          'diagnostics',
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        },
      },
      lualine_y = {
        'filetype',
      },
      lualine_z = {
        {
          'searchcount',
        },
        {
          'progress',
          separator = '',
          padding = {
            right = 1,
            left = 1,
          },
          fmt = function(str)
            return str:gsub(' ', '0')
          end,
        },
        {
          'location',
          padding = {
            right = 1,
            left = 0,
          },
          -- fmt = function(str)
          --   return str:gsub(' ', '0')
          -- end,
        },
      },
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  },
}
