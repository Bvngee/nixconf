return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'onsails/lspkind.nvim', -- menu formatting
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    -- 'dmitmel/cmp-cmdline-history', -- get's annoying
    'FelipeLema/cmp-async-path', -- 'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip') -- setup in ./luasnip.lua
    local lspkind = require('lspkind')

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      -- stylua: ignore
      mapping = cmp.mapping.preset.insert({
        -- C-n
        ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        -- C-p
        ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),

        ['<C-Space>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i', 'c' }),
        ['<C-y>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i', 'c' }),

        ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),

        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),

        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        {
          name = 'async_path',
          option = {
            trailing_slash = true,
          },
        },
      }, {
        { name = 'buffer' },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = 'text_symbol',
          maxwidth = 50,
          ellipsis_char = '…',
          show_labelDetails = true,
          menu = { -- not sure I actually want this
            nvim_lsp = 'LSP',
            path = 'Path',
            async_path = 'aPath', -- needed?
            luasnip = 'Snip',
            buffer = 'Buf',
            cmdline = 'Cmd',
            cmdline_history = 'Hist',
          },
        }),
      },
      experimental = {
        ghost_text = {
          hl_group = 'Comment',
        },
      },
    })

    cmp.setup.cmdline({ '/', '?' }, {
      -- stylua: ignore
      mapping = cmp.mapping.preset.cmdline({
        -- C-n
        ['<C-j>'] = cmp.mapping( cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { 'c' }),
        -- C-p
        ['<C-k>'] = cmp.mapping( cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { 'c' }),
      }),
      sources = cmp.config.sources({
        { name = 'buffer' },
      }),
    })

    cmp.setup.cmdline(':', {
      -- stylua: ignore
      mapping = cmp.mapping.preset.cmdline({
        -- C-n
        ['<C-j>'] = cmp.mapping( cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { 'c' }),
        -- C-p
        ['<C-k>'] = cmp.mapping( cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { 'c' }),
      }),
      sources = cmp.config.sources({
        {
          name = 'async_path',
          option = {
            trailing_slash = true,
          },
        },
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' }, -- would be really nice to only have async_path in :e ...
          },
        },
      }),
    })
  end,
}
