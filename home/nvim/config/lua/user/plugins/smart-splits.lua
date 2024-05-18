return {
  'mrjones2014/smart-splits.nvim',
  dependencies = {
    'kwkarlwang/bufresize.nvim',
  },
  event = 'VeryLazy',
  config = function()
    local smart_splits = require('smart-splits')
    local opts = {
      ignored_buftypes = {
        'nofile',
        'quickfix',
        'qf',
        'prompt',
      },
      ignored_filetypes = { 'NvimTree' },
      default_amount = 2,
      at_edge = 'stop',
      move_cursor_same_row = false,
      cursor_follows_swapped_bufs = true,
      -- resize_mode = {
      --   quit_key = '<ESC>',
      --   resize_keys = { 'h', 'j', 'k', 'l' },
      --   silent = true,
      --   hooks = {
      --     on_enter = function()
      --       vim.notify('Entering resize mode: use h/j/k/l to resize!')
      --       vim.keymap.set('n', 'H', '6h', { remap = true })
      --       vim.keymap.set('n', 'L', '6l', { remap = true })
      --       vim.keymap.set('n', 'J', '6j', { remap = true })
      --       -- -- TODO: This doesn't work (cuz of lsp hover)
      --       vim.keymap.set('n', 'K', '6k', { remap = true })
      --     end,
      --     on_leave = function()
      --       vim.notify('Exiting resize mode!')
      --
      --       vim.keymap.del('n', 'H')
      --       vim.keymap.del('n', 'L')
      --       vim.keymap.del('n', 'J')
      --       vim.keymap.del('n', 'K')
      --
      --       -- -- these are copy-pasted from ../keymaps.lua
      --       -- vim.keymap.set({ 'n', 'v' }, 'H', function()
      --       --   return vim.wo.wrap and 'g^' or '^'
      --       -- end, { remap = true, expr = true })
      --       -- vim.keymap.set({ 'n', 'v' }, 'L', function()
      --       --   return vim.wo.wrap and 'g$' or '$'
      --       -- end, { remap = true, expr = true })
      --
      --       require('bufresize').register()
      --     end,
      --   },
      -- },
      ignored_events = {
        'BufEnter',
        'WinEnter',
      },
      multiplexer_integration = nil,
      log_level = 'info',
    }

    smart_splits.setup(opts)

    -- resizing splits
    vim.keymap.set('n', '<C-A-h>', function() smart_splits.resize_left(6) end)
    vim.keymap.set('n', '<C-A-l>', function() smart_splits.resize_right(6) end)
    vim.keymap.set('n', '<C-A-k>', function() smart_splits.resize_up(4) end)
    vim.keymap.set('n', '<C-A-j>', function() smart_splits.resize_down(4) end)

    -- swapping buffers between windows
    vim.keymap.set('n', '<C-A-left>', smart_splits.swap_buf_left)
    vim.keymap.set('n', '<C-A-right>', smart_splits.swap_buf_right)
    vim.keymap.set('n', '<C-A-down>', smart_splits.swap_buf_down)
    vim.keymap.set('n', '<C-A-up>', smart_splits.swap_buf_up)

    -- -- persistent rezize mode
    -- vim.keymap.set('n', '<leader>rs', smart_splits.start_resize_mode)
  end,
}
