local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  window = {},
  completion = {
    completeopt = "menu,menuone,noinsert,noselect",
    side_padding = 0,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      ellipsis_char = '...',
      -- before = function(entry, vim_item)
      --     local source_names = {
      --         nvim_lsp = "[LSP]",
      --         nvim_lua = "[Nvim]",
      --         path = "[Path]",
      --         luasnip = "[Snip]",
      --         buffer = "[Buf]",
      --     }
      --     vim_item.menu = source_names[entry.source.name]
      --     return vim_item
      -- end
      menu = {
        nvim_lsp = "[LSP]",
        nvim_lua = "[Nvim]",
        path = "[Path]",
        luasnip = "[Snip]",
        buffer = "[Buf]",
      }
    })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'treesitter' },
  }, {
    { name = 'buffer', keyword_length = 3 },
  }),
  experimental = {
    ghost_text = false
  },
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path', options = { trailing_slash = true } }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

-- If you want insert `(` after select function or method item
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
