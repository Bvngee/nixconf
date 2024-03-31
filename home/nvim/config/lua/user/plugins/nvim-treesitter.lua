return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'VeryLazy', 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })()
  end,
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = 'all',
      sync_install = false,
      auto_install = true,
      ignore_install = {
        'comment', -- bad with raindow-delimiters
        'smali', -- failing to download
      },
      highlight = {
        enable = true,
        additional_vim_regex_higihlighting = false,
      },
      indent = { enable = false }, -- wtf does this do?
    })
  end,

  -- Do I want https://github.com/windwp/nvim-ts-autotag ???
}
