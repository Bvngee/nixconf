return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  config = function()
    local conform = require('conform')

    -- https://github.com/stevearc/conform.nvim#formatters
    conform.setup({
      notify_on_error = true,
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true, -- Do I want this?
      -- },
      format_on_save = false, -- This is annoying sometimes...
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'nixpkgs_fmt' },
        python = { 'ruff_format' },
        rust = { 'rustfmt' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        zig = { 'zigfmt' },

        -- prettier should support all these OOTB
        javascript = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        css = { { 'prettierd', 'prettier' } },
        scss = { { 'prettierd', 'prettier' } },
        less = { { 'prettierd', 'prettier' } },
        html = { { 'prettierd', 'prettier' } },
        json = { { 'prettierd', 'prettier' } },
        jsonc = { { 'prettierd', 'prettier' } },
        yaml = { { 'prettierd', 'prettier' } },
        markdown = { { 'prettierd', 'prettier' } },
        ["markdown.mdx"] = { { 'prettierd', 'prettier' } },

        -- NOTE: these require their respective `prettier-plugin-x` npm packages
        -- installed and added to .prettierrc
        -- TODO: investigate installing npm packages globally if they're not in
        -- nixpkgs?
        astro = { { 'prettierd', 'prettier' } },
        toml = { { 'prettierd', 'prettier' } },
      },
    })

    conform.formatters.clang_format = {
      -- Future: {IndentWidth: vim.XXX, IndentStyle: vim.xxx} ??? .editorconfig???
      prepend_args = { '--fallback-style=llvm', '--style=file' },
    }

    -- TODO(0.10): In newer neovim versions this isn't needed
    -- https://github.com/neovim/neovim/pull/28904
    vim.g.zig_fmt_autosave = 0

    vim.keymap.set({ 'n', 'v' }, '<leader>fo', function()
      require('conform').format({
        lsp_fallback = true,
      })
    end)
  end,
}
