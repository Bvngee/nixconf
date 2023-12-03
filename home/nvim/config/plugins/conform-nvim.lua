local conform = require('conform')

-- https://github.com/stevearc/conform.nvim#formatters
conform.setup {
    formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixpkgs_fmt" },
        python = { "ruff_format" },
        markdown = { { "prettierd", "prettier" } },
        rust = { "rustfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        zig = { "zigfmt" },

        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
    }
}

conform.formatters.clang_format = {
    prepend_args = { "-fallback-style=llvm", "-style=file"}
}

vim.keymap.set({ 'n', 'v' }, '<leader>fo', 
    function()
        require('conform').format {
            lsp_fallback = true,
        }
    end
)
