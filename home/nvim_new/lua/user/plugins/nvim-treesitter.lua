return {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })()
  end,
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = 'all',
      sync_install = false,
      auto_install = true,
      ignore_install = { 'comment' },
      highlight = {
        enable = true,
        additional_vim_regex_higihlighting = false,
      },
      indent = { enable = true },
    })
  end,
}
