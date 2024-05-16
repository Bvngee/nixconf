return {
  'L3MON4D3/LuaSnip',
  build = (vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0) and 'make install_jsregexp'
    or '',
  dependencies = {
    {
      'rafamadriz/friendly-snippets',
      -- I dont need fucking lorem ipsum in my completion menu
      -- this breaks Lazy's updating - not sure if the `exclude` below actually works?
      build = 'rm snippets/global.json',
    },
  },
  config = function()
    require('luasnip').config.setup({})
    require('luasnip.loaders.from_vscode').lazy_load({
      exclude = {
        'plaintext',
        'markdown',
        'tex',
        'html',
        'global',
        'all',
      },
    })
  end,
}
