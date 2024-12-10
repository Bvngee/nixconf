return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'VeryLazy', 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })()
  end,
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
        -- 'nix', 'bash', 'rust', 'javascript', 'typescript', 'zig', 'cmake', 'meson', 'html', 'css', 'json', 'astro',
      },
      sync_install = false,
      auto_install = true,
      ignore_install = {
        'comment', -- bad with raindow-delimiters
      },

      indent = { enable = false }, -- wtf does this do?

      highlight = {
        enable = true,
        additional_vim_regex_higihlighting = false,
        disable = function(lang, buf)
          local max_filesize = 1024 * 1024 -- 1 MB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          else
            vim.notify('Treesitter highlights disabled due to file size!', vim.log.levels.INFO)
          end
        end,
      },
    })
  end,

  -- Do I want https://github.com/windwp/nvim-ts-autotag ???
}
