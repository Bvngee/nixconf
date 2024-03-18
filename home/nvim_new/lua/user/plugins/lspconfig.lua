-- specify neodev as a dependency of lspconfig to get loading order right
local neodev = {
  'folke/neodev.nvim',
  opts = {
    override = function(root_dir, library)
      local enable = root_dir:find('nvim', 1, true) ~= nil
        or root_dir:find('nixconf', 1, true) ~= nil
      if enable then
        library.enabled = true
        library.types = true
        library.runtime = true
        library.plugins = true
      end
    end,
  },
}

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  dependencies = {
    'hrsh7th/nvim-cmp', -- to create capabilities
    neodev,
  },
  config = function()
    -- Available keys are:
    -- cmd (table)
    -- filetypes (table)
    -- capabilities (table)
    -- settings (table)
    local servers = {
      nil_ls = {},
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = 'Replace',
            },
            type = {
              -- weakUnionCheck = true,
              -- weakNilCheck = true,
              -- castNumberToInteger = true,
            },
            format = { enable = false },
            hint = {
              enable = true,
              arrayIndex = 'Disable', -- "Enable", "Auto", "Disable"
              await = true,
              paramName = 'Disable', -- "All", "Literal", "Disable"
              paramType = false,
              semicolon = 'Disable', -- "All", "SameLine", "Disable"
              setType = true,
            },
            diagnostics = {
              disable = { 'trailing-space', 'unused-local', 'unused-function', 'unused-vararg' },
            },
            telemetry = { enable = false },
          },
        },
      },
      bashls = {},
      rust_analyzer = {},
      clangd = {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--header-insertion-decorators',
          '--compile-commands-dir="build/"',
          '--enable-config',
        },
      },
      pyright = {},
      tsserver = {},
      zls = {},
      jdtls = { -- not working
        cmd = {
          'jdt-language-server',
          '-configuration',
          '/home/user/.cache/jdtls/config',
          '-data',
          '/home/user/.cache/jdtls/workspace',
        },
      },
    }

    local lspconfig = require('lspconfig')
    local nvim_capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    local default_opts = {
      capabilities = vim.tbl_deep_extend('force', nvim_capabilities, cmp_capabilities),
    }

    for server, opts in pairs(servers) do
      -- Any server-specific capabilities take precedence over our defaults
      local final_opts = vim.tbl_deep_extend('force', default_opts, opts)
      lspconfig[server].setup(final_opts)
    end

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(event)
        local tele = require('telescope.builtin')
        local function map(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = event.buf })
        end
        map('n', 'gd', tele.lsp_definitions)
        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', 'gtd', tele.lsp_type_definitions) -- bad keybind?
        map('n', 'gr', tele.lsp_references)
        map('n', 'gI', tele.lsp_implementations) -- `gi` is a thing already
        map('n', '<leader>ds', tele.lsp_document_symbols)
        map('n', '<leader>ws', tele.lsp_dynamic_workspace_symbols)
        map('n', 'K', vim.lsp.buf.hover)
        map('n', '<leader>k', vim.lsp.buf.signature_help)
        map('n', '<space>rn', vim.lsp.buf.rename)
        map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action)
      end,
    })

    -- standard diagnostic navigation
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
    -- all lsp diagnostics (workspace/document, qflist/loclist) are done via trouble.nvim

    local signs = { Error = ' ', Warn = ' ', Info = ' ', Hint = ' ' }

    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    vim.diagnostic.config({
      underline = true,
      update_in_insert = true, -- do I want this as true?
      signs = {
        active = signs, -- show signs
      },
      virtual_text = {
        spacing = 4,
        source = 'if_many',
        -- prefix = "●" -- 󰝤 󱓻 󱓻 
      },
      severity_sort = true,
      float = {
        focusable = true,
        style = 'minimal',
        border = 'none',
        source = 'always',
        header = '',
        prefix = '',
      },
    })
  end,
}
