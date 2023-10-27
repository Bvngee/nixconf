local lspconfig = require('lspconfig')

local servers = {
  nil_ls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        },
        type = {
          -- weakUnionCheck = true,
          -- weakNilCheck = true,
          -- castNumberToInteger = true,
        },
        format = {
          enable = false,
        },
        hint = {
          enable = true,
          arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
          await = true,
          paramName = "Disable", -- "All", "Literal", "Disable"
          paramType = false,
          semicolon = "Disable", -- "All", "SameLine", "Disable"
          setType = true,
        },
        runtime = {
          version = "LuaJIT",
          special = {
            reload = "require",
          },
        },
        diagnostics = {
          --globals = { "vim" }, --lua-dev handles this (in some locations??)
          disable = { "trailing-space", "unused-local", "unused-function", "unused-vararg", }
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true, --necessary
            [vim.fn.stdpath "config" .. "/lua"] = true,
            -- [vim.fn.datapath "config" .. "/lua"] = true, --seems to cause problems? be careful
          },
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      }
    }
  },
  bashls = {},
  rust_analyzer = {},
  clangd = {},
}

local on_attach = function(client, bufnr)

  -- attach nvim-navic
  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, bufnr)
  end

  -- lsp keybinds
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>', opts)
  vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>', opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set({ 'n', 'v' }, 'qq', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format { async = true }
  end, opts)
end

local common_opts = {
  on_attach = on_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities()
}

for server, opts in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend('force', common_opts, opts))
end


local signs = { Error = ' ', Warn = ' ', Info = ' ', Hint = ' ' }

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

vim.diagnostic.config {
  virtual_text = true,
  signs = {
    active = signs, -- show signs
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'none',
    source = 'always',
    header = '',
    prefix = '',
  },
}
