return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  main = 'ibl',
  opts = {
    indent = {
      char = '▏',
    },
    scope = {
      enabled = false,
    },
    exclude = {
      buftypes = { 'terminal', 'nofile' },
      filetypes = {
        'help',
        'startify',
        'dashboard',
        'packer',
        'neogitstatus',
        'NvimTree',
        'Trouble',
        'text',
      },
    },
  },
}
